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
        VStack(alignment: .leading) {
            Text(phrase.text)
                .font(.headline)
            Text(phrase.meaningJa)
                .font(.caption2)
        }
    }
}

#Preview {
    PhraseRow(phrase: MockPhraseData.lowKey, isSelected: false)
}
