//
//  TestView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/27.
//

import SwiftUI

struct TestView: View {
    
    @StateObject var store = PhraseStore()
    
    var body: some View {
        Text(store.phrases.first?.phraseDetails.tips ?? store.errorMessage ?? "")
            .task {
                await store.loadPhrases()
            }
    }
}

#Preview {
    TestView()
}
