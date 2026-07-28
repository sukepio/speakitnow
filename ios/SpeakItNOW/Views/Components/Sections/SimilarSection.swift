//
//  SimilarSection.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct SimilarSection: View {
    let similar: [SimilarPhrase]
    let onSpeak: (String) -> Void
    
    var body: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 8) {
                SectionTitle(title: "類似語")
                ForEach(similar) { similar in
                    SimilarRowView(
                        phrase: similar.phrase,
                        meaningJa: similar.meaningJa,
                        onSpeak: onSpeak
                    
                    )
                }
            }
        }
    }
}

#Preview {
    SimilarSection(
        similar: MockPhraseData.lowKey.phraseDetails.similar,
        onSpeak: { _ in }
    )
}
