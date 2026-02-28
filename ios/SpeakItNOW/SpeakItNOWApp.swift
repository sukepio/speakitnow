//
//  SpeakItNOWApp.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/14.
//

import SwiftUI

@main
struct SpeakItNOWApp: App {
    @StateObject var phraseStore = PhraseStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.environmentObject(phraseStore)
    }
}
