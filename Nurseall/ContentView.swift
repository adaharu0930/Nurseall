//
//  ContentView.swift
//  Nurseall
//
//  Created by デジタルヘルス on 2024/10/25.
//

import SwiftUI
import AVFoundation

struct PatientAuthView: View {
    @State private var isAuthComplete = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isAuthComplete {
                    Text("認証が完了しました")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    
                    // 認証完了後に自動で看護記録画面に遷移するためのNavigationLink
                    NavigationLink(destination: NurseRecordView(), isActive: $isAuthComplete) {
                        EmptyView()
                    }
                } else {
                    CameraView(isAuthComplete: $isAuthComplete)
                        .edgesIgnoringSafeArea(.all)
                    
                    Text("患者のARマーカーを読み取ってください")
                        .font(.headline)
                        .padding(.bottom, 50)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.6))
                }
            }
        }
    }
}

struct NurseRecordView: View {
    var body: some View {
        VStack {
            Text("看護記録の画面")
                .font(.largeTitle)
                .padding()
            
            // ここに看護記録の詳細や操作機能を追加できます
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var isAuthComplete: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CameraViewControllerDelegate {
        var parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func didCompleteAuth() {
            parent.isAuthComplete = true
        }
    }
}

protocol CameraViewControllerDelegate {
    func didCompleteAuth()
}

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: CameraViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // カメラの設定
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }

        // プレビューの設定
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            captureSession.stopRunning()
            delegate?.didCompleteAuth()
        }
    }
}
