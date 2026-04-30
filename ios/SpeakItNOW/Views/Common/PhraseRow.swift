//
//  PhraseRow.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct PhraseRow<Item:PhraseDisplayable>: View {
    let item : Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.displayText)
                    .font(.system(size: 20))
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                
                Text(item.displayMeaningJa)
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
    PhraseRow(item: MockPhraseData.lowKey)
}
