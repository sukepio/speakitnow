//
//  EnglishSpeechButton.swift
//  SpeakItNOW
//

import SwiftUI

struct EnglishSpeechButton: View {
    let text: String
    let accessibilityLabel: String
    let onSpeak: (String) -> Void

    var body: some View {
        Button {
            onSpeak(text)
        } label: {
            Image(systemName: "speaker.wave.2.fill")
                .font(.subheadline)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    EnglishSpeechButton(
        text: "Speak this phrase.",
        accessibilityLabel: "英語表現を再生",
        onSpeak: { _ in }
    )
}
