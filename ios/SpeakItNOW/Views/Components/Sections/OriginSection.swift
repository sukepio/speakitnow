//
//  OriginSection.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct OriginSection: View {
    let origin: String
    
    var body: some View {
        SectionCard {
            SectionTitle(title: "語源")
            Text(origin)
                .font(.body)
        }
    }
}

#Preview {
    OriginSection(origin: MockPhraseData.lowKey.phraseDetails.origin)
}
