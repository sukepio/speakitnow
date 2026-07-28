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
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 0) {
                Text("(\(speaker.label)):")
                    .frame(width: 40, alignment: .leading)
                    .foregroundStyle(.black)
                Text(en)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)

                Spacer(minLength: 8)

                EnglishSpeechButton(
                    text: en,
                    accessibilityLabel: "話者\(speaker.label)の英文を再生",
                    onSpeak: onSpeak
                )
            }
            Text(ja)
                .font(.caption)
                .foregroundStyle(.black)
                .padding(.leading, 40)
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
