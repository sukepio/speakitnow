//
//  PhraseRow.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct PhraseRow: View {
    let phrase : Phrase
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(phrase.text)
                    .font(.headline)
                Text(phrase.meaningJa)
                    .font(.caption2)
            }
            Spacer()
            
        }
//        .padding(10)
        .background(.white)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 0))
        }
        
    }
}

#Preview {
    PhraseRow(phrase: MockPhraseData.lowKey)
}
