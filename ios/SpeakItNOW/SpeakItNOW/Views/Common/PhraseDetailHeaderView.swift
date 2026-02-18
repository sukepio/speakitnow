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
    let isAdded: Bool
    let source: PhraseDetailSource
    
    var body: some View {
        HStack() {
            Spacer()
            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .padding(10)
                    .contentShape(Rectangle())
            }
               .buttonStyle(.plain)
        }
        
        VStack(alignment: .leading) {
            Text(phrase.text)
                .font(.title)
            Text(phrase.meaningJa)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)
        
        HStack() {
            Button {
                if isAdded {
                    onRemoveMyPhrase()
                } else {
                    onAddMyPhrase()
                }
            } label: {
                HStack {
                    Text(isAdded ? "Myフレーズ帳から削除" : "Myフレーズ帳に保存")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(isAdded ? .red : .blue)
                }
            }
                .frame(maxWidth: .infinity)
                .frame(height: 34)
                .background(isAdded ? Color.red.opacity(0.08) : .white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isAdded ? Color.red : Color.blue, lineWidth: 1)
                )
            
            
            if source != .output {
                Button {
                    onStartOutput()
                } label: {
                    Text("今すぐアウトプット")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 34)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.clear, lineWidth: 1))
            }
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
        isAdded: false,
        source: .myPhrase
    )
}
