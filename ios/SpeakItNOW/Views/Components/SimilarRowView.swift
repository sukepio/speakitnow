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
                    .foregroundStyle(.white)
                Text(meaningJa)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            EnglishSpeechButton(
                text: phrase,
                accessibilityLabel: "\(phrase)を再生",
                onSpeak: onSpeak
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 3)
        
    }
}

#Preview {
    SimilarRowView(
        phrase: "subtle",
        meaningJa: "控えめな",
        onSpeak: { _ in }
    )
}
