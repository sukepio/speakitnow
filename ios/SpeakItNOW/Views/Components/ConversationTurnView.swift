//
//  ConversationTurnView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct ConversationTurnView: View {
    let speaker: Speaker
    let en: String
    let ja: String
    let onSpeak: (String) -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(speaker.label)
                .font(.caption.bold())
                .foregroundStyle(.blue)
                .frame(width: 28, height: 28)
                .background(Color.blue.opacity(0.14))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(en)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)

                Text(ja)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 4)

            EnglishSpeechButton(
                text: en,
                accessibilityLabel: "話者\(speaker.label)の英文を再生",
                onSpeak: onSpeak
            )
        }
    }
}

#Preview {
    ConversationTurnView(
        speaker: Speaker.a,
        en: "this is English",
        ja: "これは英語です",
        onSpeak: { _ in }
    )
}
