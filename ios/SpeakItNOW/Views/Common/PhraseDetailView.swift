//
//  PhraseDetailView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/25.
//

import SwiftUI
import UIKit

struct PhraseDetailView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    @Environment(\.dismiss) var dismiss
    @StateObject private var speaker = ConversationSpeaker()
    
    let phrase: Phrase
    let source: PhraseDetailSource
    let onStartOutput: (Phrase, PhraseDetailSource) -> Void
    
    var isAdded: Bool {phraseStore.isAdded(phrase)}
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                PhraseDetailHeaderView(
                    phrase: phrase,
                    onClose: { dismiss() },
                    onAddMyPhrase: {
                        let generator = UINotificationFeedbackGenerator()
                        generator.prepare()
                        Task {
                            await phraseStore.addMyPhrase(phrase)
                            await MainActor.run {
                                if phraseStore.errorMessage == nil {
                                    generator.notificationOccurred(.success)
                                } else {
                                    generator.notificationOccurred(.error)
                                }
                            }
                        }
                    },
                    onRemoveMyPhrase: {
                        let generator = UINotificationFeedbackGenerator()
                        generator.prepare()
                        Task {
                            await phraseStore.removeMyPhrase(phrase)
                            await MainActor.run {
                                if phraseStore.errorMessage == nil {
                                    generator.notificationOccurred(.success)
                                } else {
                                    generator.notificationOccurred(.error)
                                }
                            }
                        }
                    },
                    onStartOutput: { onStartOutput(phrase, source) },
                    onSpeak: { text in speaker.speak(text) },
                    isAdded: isAdded,
                    source: source
                )
                .padding(.bottom, 16)

                Divider()
                    .overlay(Color.white.opacity(0.12))

                if let message = phraseStore.errorMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        MeaningSection(detailedMeaning: phrase.phraseDetails.detailedMeaning)
                        ContextSection(contexts: phrase.phraseDetails.contexts)
                        CollocationSection(
                            collocations: phrase.phraseDetails.collocations,
                            onSpeak: { text in speaker.speak(text) }
                        )
                        OriginSection(origin: phrase.phraseDetails.origin)
                        TipsSection(tips: phrase.phraseDetails.tips)
                        if !phrase.phraseDetails.similar.isEmpty {
                            SimilarSection(
                                similar: phrase.phraseDetails.similar,
                                onSpeak: { text in speaker.speak(text) }
                            )
                        }
                    }
                    .padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 20)
        }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            speaker.stop()
        }
    }
    
}

#Preview("My Phrase") {
    PhraseDetailView(
        phrase: MockPhraseData.lowKey,
        source: .myPhrase,
        onStartOutput: { _, _ in }
    )
    .environmentObject(PhraseStore())
}

#Preview("Search Result") {
    PhraseDetailView(
        phrase: MockPhraseData.lowKey,
        source: .search,
        onStartOutput: { _, _ in }
    )
    .environmentObject(PhraseStore())
}
