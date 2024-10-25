//
//  NurseallApp.swift
//  Nurseall
//
//  Created by デジタルヘルス on 2024/10/25.
//

import SwiftUI

@main
struct NurseallApp: App {
    var body: some Scene {
        WindowGroup {
            PatientAuthView()
            NursingRecordView()
        }
    }
}
