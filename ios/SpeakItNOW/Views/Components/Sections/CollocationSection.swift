//
//  CollocationSection.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct CollocationSection: View {
    let collocations: [Collocation]
    let onSpeak: (String) -> Void
    
    var body: some View {
        SectionCard {
            SectionTitle(title: "コロケーション")
            ForEach(collocations) { collocation in
                CollocationItemCard(
                    collocation: collocation,
                    onSpeak: onSpeak
                )
            }
            
        }
    }
}

#Preview {
    CollocationSection(
        collocations: MockPhraseData.lowKey.phraseDetails.collocations,
        onSpeak: { _ in }
    )
}
