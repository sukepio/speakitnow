//
//  PhraseDetailView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/25.
//

import SwiftUI

struct PhraseDetailView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    @Environment(\.dismiss) var dismiss
    
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
                onAddMyPhrase: { phraseStore.addMyPhrase(phrase) },
                onRemoveMyPhrase: { phraseStore.removeMyPhrase(phrase) },
                onStartOutput: { onStartOutput(phrase, source) },
                isAdded: isAdded
            )
            .padding(.bottom, 10)
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 意味
                    MeaningSection(detailedMeaning: phrase.details.detailedMeaning)
                    // 使用される文脈
                    ContextSection(contexts: phrase.details.contexts)
                    // コロケーション
                    CollocationSection(collocations: phrase.details.collocations)
                    // 語源
                    OriginSection(origin: phrase.details.origin)
                    // 使い方のヒント
                    TipsSection(tips: phrase.details.tips)
                    // 類似表現
                    if !phrase.details.similar.isEmpty {
                        SimilarSection(similar: phrase.details.similar)
                    }
                    
                }
                .padding(.top, 12)
            }
            
        }
        .padding(20)
                
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
