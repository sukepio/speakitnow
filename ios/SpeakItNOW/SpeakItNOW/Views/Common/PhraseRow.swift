//
//  PhraseRow.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct PhraseRow: View {
    let phrase : Phrase
    var isSelected : Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(phrase.text)
                    .font(.headline)
                Text(phrase.meaningJa)
                    .font(.caption2)
            }
            Spacer()
            Image(systemName: "checkmark")
                .opacity(isSelected ? 1 : 0)
                .foregroundStyle(isSelected ? Color.red : Color.clear)
        }
//        .padding(10)
        .background(isSelected ? Color.red.opacity(0.08) : Color.clear)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: isSelected ? 1 : 0))
                .foregroundStyle(isSelected ? Color.red : Color.clear)
        }
        
    }
}

#Preview {
    PhraseRow(phrase: MockPhraseData.lowKey, isSelected: true)
}
