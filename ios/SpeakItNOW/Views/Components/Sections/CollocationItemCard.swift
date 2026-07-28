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
                Image(systemName: "play.fill")
                    .foregroundStyle(.black)
                
                Text(collocation.text)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)

                Spacer()

                EnglishSpeechButton(
                    text: collocation.text,
                    accessibilityLabel: "\(collocation.text)を再生",
                    onSpeak: onSpeak
                )
            }
            Text(collocation.meaningJa)
                .foregroundStyle(.black)
                .fontWeight(.medium)
                .font(.system(size: 14))
            
            Divider()
            
            ConversationTurnView(speaker: .a,
                                 en: collocation.conversationPair.first.en,
                                 ja: collocation.conversationPair.first.ja,
                                 onSpeak: onSpeak)
            
            ConversationTurnView(speaker: .b,
                                 en: collocation.conversationPair.second.en,
                                 ja: collocation.conversationPair.second.ja,
                                 onSpeak: onSpeak)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
    }
}

#Preview {
    CollocationItemCard(
        collocation: MockPhraseData.lowKey.phraseDetails.collocations[0],
        onSpeak: { _ in }
    )
}
