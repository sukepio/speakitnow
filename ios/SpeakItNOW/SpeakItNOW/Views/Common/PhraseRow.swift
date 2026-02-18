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
                    .font(.system(size: 20))
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text(phrase.meaningJa)
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
                    .fontWeight(.medium)
            }
            Spacer()
            
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
    }
}

#Preview {
    PhraseRow(phrase: MockPhraseData.lowKey)
}
