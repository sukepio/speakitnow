//
//  BulletRow.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct BulletRow: View {
    let text: String
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .frame(width: 5, height: 5)
                .foregroundStyle(.blue)
            Text(text)
                .foregroundStyle(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    BulletRow(
        text: "感情や好みを控えめに伝えるとき"
    )
}
