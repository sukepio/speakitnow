//
//  PhraseDetailView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/25.
//

import SwiftUI

struct PhraseDetailView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    @Environment(\.dismiss) var dismiss
    let phrase: Phrase
    var isAdded: Bool {phraseStore.isAdded(phrase)}
    
    var body: some View {
        VStack(spacing: 0) {
            PhraseDetailHeaderView(
                phrase: phrase,
                onClose: { dismiss() },
                onAddMyPhrase: { phraseStore.addMyPhrase(phrase) },
                onRemoveMyPhrase: { phraseStore.removeMyPhrase(phrase) },
                onStartOutput: { print("Start Output") },
                isAdded: isAdded
            )
            .padding(.bottom, 10)
            
            Divider()
            
            ScrollView {
                Text("意味")
                Text(phrase.details.detailedMeaning)
                Text("オリジン")
                Text(phrase.details.origin)
                Text("文脈")
                Text(phrase.details.contexts[0])
                Text("コロケーション")
                ForEach(phrase.details.collocations) { collocation in
                    Text(collocation.text)
                    Text(collocation.meaningJa)
                    Text("例")
                    Text(collocation.conversation.first.en)
                    Text(collocation.conversation.first.ja)
                    Text(collocation.conversation.second.en)
                    Text(collocation.conversation.second.ja)
                }
                Text("ヒント")
                Text(phrase.details.tips)
                Text("類似語")
            }
            
        }
        .padding(20)
                
    }
}

#Preview {
    PhraseDetailView(phrase: MockPhraseData.lowKey)
        .environmentObject(PhraseStore())
}
