//
//  PhraseDetailHeaderView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/26.
//

import SwiftUI

struct PhraseDetailHeaderView: View {
    let phrase: Phrase
    let onClose: () -> Void
    let onAddMyPhrase: () -> Void
    let onRemoveMyPhrase: () -> Void
    let onStartOutput: () -> Void
    let onSpeak: (String) -> Void
    let isAdded: Bool
    let source: PhraseDetailSource
    @State private var isSettingsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("英語表現")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.55))

                Spacer()

                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("閉じる")
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 12) {
                    Text(phrase.text)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 4)

                    EnglishSpeechButton(
                        text: phrase.text,
                        accessibilityLabel: "\(phrase.text)を再生",
                        onSpeak: onSpeak
                    )
                }

                Text(phrase.meaningJa)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                Button {
                    if isAdded {
                        onRemoveMyPhrase()
                    } else {
                        onAddMyPhrase()
                    }
                } label: {
                    Label(
                        isAdded ? "保存を解除" : "フレーズ帳に保存",
                        systemImage: isAdded ? "bookmark.slash.fill" : "bookmark.fill"
                    )
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isAdded ? .red : .blue)
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .background((isAdded ? Color.red : Color.blue).opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke((isAdded ? Color.red : Color.blue).opacity(0.75), lineWidth: 1)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)

                if source != .output {
                    Button {
                        isSettingsPresented = true
                    } label: {
                        Label("アウトプット", systemImage: "bolt.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .contentShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .sheet(isPresented: $isSettingsPresented) {
            InstantCompositionSettingsScreen(
                questionCount: 5,
                selectedDifficulty: Difficulty.beginner,
                selectedScene: SceneType.daily,
                selectedFormalLevel: FormalLevel.casual,
                isPlayScreenShown: false,
                phrase: phrase
            )
        }
    }
}

#Preview {
    PhraseDetailHeaderView(
        phrase: MockPhraseData.lowKey,
        onClose: { print("Close sheet") },
        onAddMyPhrase: { print("Add to my phrase") },
        onRemoveMyPhrase: { print("Remove from my phrase") },
        onStartOutput: { print("Start output") },
        onSpeak: { _ in },
        isAdded: false,
        source: .myPhrase
    )
}
