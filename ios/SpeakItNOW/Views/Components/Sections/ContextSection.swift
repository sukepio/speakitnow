//
//  ContextSection.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct ContextSection: View {
    let contexts: [String]
    
    var body: some View {
        SectionCard {
            SectionTitle(title: "使われる文脈")
            ForEach(contexts, id: \.self) { context in
                BulletRow(text: context)
            }
        }
    }
}

#Preview {
    ContextSection(
        contexts: [
        "感情や好みを控えめに伝えるとき",
        "公にしない・大げさにしない行動"
    ])
}
