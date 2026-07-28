//
//  CollocationItemCard.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct CollocationItemCard: View {
    let collocation: Collocation
    let onSpeak: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "link")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.blue)
                
                Text(collocation.text)
                    .foregroundStyle(.white)
                    .font(.headline)

                Spacer()

                EnglishSpeechButton(
                    text: collocation.text,
                    accessibilityLabel: "\(collocation.text)を再生",
                    onSpeak: onSpeak
                )
            }
            Text(collocation.meaningJa)
                .foregroundStyle(.white.opacity(0.65))
                .font(.subheadline)
            
            Divider()
                .overlay(Color.white.opacity(0.1))
            
            ConversationTurnView(speaker: .a,
                                 en: collocation.conversationPair.first.en,
                                 ja: collocation.conversationPair.first.ja,
                                 onSpeak: onSpeak)
            
            ConversationTurnView(speaker: .b,
                                 en: collocation.conversationPair.second.en,
                                 ja: collocation.conversationPair.second.ja,
                                 onSpeak: onSpeak)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        }
    }
}

#Preview {
    CollocationItemCard(
        collocation: MockPhraseData.lowKey.phraseDetails.collocations[0],
        onSpeak: { _ in }
    )
}
