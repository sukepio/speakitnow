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
        VStack(spacing: 0) {
            // ヘッダー
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
            .padding(.bottom, 10)
            
            Divider()
            
            if let message = phraseStore.errorMessage {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 意味
                    MeaningSection(detailedMeaning: phrase.phraseDetails.detailedMeaning)
                    // 使用される文脈
                    ContextSection(contexts: phrase.phraseDetails.contexts)
                    // コロケーション
                    CollocationSection(
                        collocations: phrase.phraseDetails.collocations,
                        onSpeak: { text in speaker.speak(text) }
                    )
                    // 語源
                    OriginSection(origin: phrase.phraseDetails.origin)
                    // 使い方のヒント
                    TipsSection(tips: phrase.phraseDetails.tips)
                    // 類似表現
                    if !phrase.phraseDetails.similar.isEmpty {
                        SimilarSection(
                            similar: phrase.phraseDetails.similar,
                            onSpeak: { text in speaker.speak(text) }
                        )
                    }
                    
                }
                .padding(.top, 12)
            }
            
        }
        .padding(20)
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
