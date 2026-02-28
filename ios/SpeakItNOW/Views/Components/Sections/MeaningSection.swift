//
//  MeaningSection.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct MeaningSection: View {
    let detailedMeaning: String
    
    var body: some View {
        SectionCard {
            SectionTitle(title: "意味")
            Text(detailedMeaning)
                .font(.body)
        }
    }
}

#Preview {
    MeaningSection(detailedMeaning: """
「low-key」は、何かを大げさにせず、控えめ・さりげない形で行うときに使われます。
感情や評価を抑えて伝えたいときや、「実はちょっと〜」というニュアンスでもよく使われます。
""")
}
