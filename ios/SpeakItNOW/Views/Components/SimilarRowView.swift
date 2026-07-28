//
//  SimilarRowView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct SimilarRowView: View {
    let phrase: String
    let meaningJa: String
    let onSpeak: (String) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(phrase)
                    .fontWeight(.semibold)
                Text(meaningJa)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            EnglishSpeechButton(
                text: phrase,
                accessibilityLabel: "\(phrase)を再生",
                onSpeak: onSpeak
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    SimilarRowView(
        phrase: "subtle",
        meaningJa: "控えめな",
        onSpeak: { _ in }
    )
}
