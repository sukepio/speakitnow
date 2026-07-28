//
//  TipsSection.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct TipsSection: View {
    let tips: String
    var body: some View {
        SectionCard {
            SectionTitle(title: "使い方のヒント")
            Text(tips)
                .font(.body)
        }
    }
}

#Preview {
    TipsSection(tips: MockPhraseData.lowKey.phraseDetails.tips)
}
