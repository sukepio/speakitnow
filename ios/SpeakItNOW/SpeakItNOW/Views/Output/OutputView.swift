//
//  OutputView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/08.
//

import SwiftUI

struct OutputView: View {
    @State private var selectedPhrase: Phrase? = nil
    let phrase: Phrase
    let source: PhraseDetailSource
    
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                Text("アウトプット")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                PhraseRow(phrase: phrase)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedPhrase = phrase
                    }
            }
            .sheet(item: $selectedPhrase) { phrase in
                PhraseDetailView(
                    phrase: phrase,
                    source: .output,
                    onStartOutput: { _, _ in}
                )
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
}

#Preview {
    OutputView(
        phrase: MockPhraseData.lowKey, source: .myPhrase
    )
}
