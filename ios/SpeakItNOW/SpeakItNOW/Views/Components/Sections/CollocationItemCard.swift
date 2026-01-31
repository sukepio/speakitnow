//
//  CollocationItemCard.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct CollocationItemCard: View {
    let collocation: Collocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.caption)
                Text(collocation.text)
                    .fontWeight(.semibold)
            }
            Text(collocation.meaningJa)
                .foregroundStyle(.secondary)
            
            Divider()
            
            ConversationTurnView(speaker: .a,
                                 en: collocation.conversation.first.en,
                                 ja: collocation.conversation.first.ja)
            
            ConversationTurnView(speaker: .b,
                                 en: collocation.conversation.second.en,
                                 ja: collocation.conversation.second.ja)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
    }
}

#Preview {
    CollocationItemCard(
        collocation: MockPhraseData.lowKey.details.collocations[0]
    )
}
