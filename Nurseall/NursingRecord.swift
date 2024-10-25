//
//  NursingRecord.swift
//  Nurseall
//
//  Created by デジタルヘルス on 2024/10/25.
//

import SwiftUI

struct NursingRecordView: View {
    // 動的なデータのための変数（後で実際のデータで埋めることが可能）
    @State private var recordDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date() // デフォルトで昨日の日付を設定
    @State private var patientName: String = "〇〇〇〇 〇〇〇"
    @State private var bloodPressure: String = ""
    @State private var temperature: String = ""
    @State private var pulse: String = ""
    
    // SOAP記録
    @State private var subjective: String = "" // S: 主観的データ
    @State private var objective: String = ""  // O: 客観的データ
    @State private var assessment: String = "" // A: アセスメント
    @State private var plan: String = ""       // P: 計画
    
    @State private var isDatePickerPresented: Bool = false // 日付選択ピッカーを表示/非表示にする状態
    
    var body: some View {
        VStack(spacing: 20) {
            // ヘッダーとカレンダーボタン
            HStack {
                Spacer()
                Text("看護記録")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                // カレンダーボタン
                Button(action: {
                    isDatePickerPresented.toggle() // 日付ピッカーの表示を切り替え
                }) {
                    Image(systemName: "calendar")
                        .font(.title)
                }
                .sheet(isPresented: $isDatePickerPresented) {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        VStack {
                            DatePicker(
                                "記録日選択",
                                selection: $recordDate,
                                in: ...Calendar.current.date(byAdding: .day, value: -1, to: Date())!, // 過去の日付のみを許可
                                displayedComponents: .date
                            )
                            .datePickerStyle(WheelDatePickerStyle()) // ホイールスタイル
                            .labelsHidden() // ラベルを非表示にしてシンプルなデザインに
                            .environment(\.locale, Locale(identifier: "ja_JP")) // 日付フォーマットを日本語に設定

                            // OKボタン
                            Button(action: {
                                isDatePickerPresented = false // 日付ピッカーを閉じる
                            }) {
                                Text("OK")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                    }
                }
            }
            .padding(.top, 20)
            
            // 記録日と患者名
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("記録日")
                    Spacer()
                    Text(dateFormatter.string(from: recordDate)) // 日付を表示
                }
                .font(.subheadline)
                
                HStack {
                    Text("氏名")
                    Spacer()
                    Text(patientName)
                }
                .font(.subheadline)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // バイタルデータのセクション
            VStack(alignment: .leading, spacing: 10) {
                Text("バイタルデータ")
                    .font(.headline)
                
                HStack {
                    Text("血圧")
                    Spacer()
                    TextField("入力", text: $bloodPressure)
                        .keyboardType(.asciiCapable) // 半角英数字を許可
                }
                
                HStack {
                    Text("体温")
                    Spacer()
                    TextField("入力", text: $temperature)
                        .keyboardType(.asciiCapable) // 半角英数字を許可
                }
                
                HStack {
                    Text("脈拍")
                    Spacer()
                    TextField("入力", text: $pulse)
                        .keyboardType(.asciiCapable) // 半角英数字を許可
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // SOAPノートのセクション
            VStack(alignment: .leading, spacing: 10) {
                Text("看護記録 (SOAP)")
                    .font(.headline)
                
                // S: 主観的データ
                HStack {
                    Text("S:")
                    Spacer()
                    TextField("主観的データ", text: $subjective)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // O: 客観的データ
                HStack {
                    Text("O:")
                    Spacer()
                    TextField("客観的データ", text: $objective)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // A: アセスメント
                HStack {
                    Text("A:")
                    Spacer()
                    TextField("アセスメント", text: $assessment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // P: 計画
                HStack {
                    Text("P:")
                    Spacer()
                    TextField("計画", text: $plan)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    // 日付を yyyy/MM/dd 形式で表示するためのフォーマッター
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
}

struct NursingRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NursingRecordView()
    }
}
