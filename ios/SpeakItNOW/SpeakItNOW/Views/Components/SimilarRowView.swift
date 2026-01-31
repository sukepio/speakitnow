//
//  SimilarRowView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct SimilarRowView: View {
    let phrase: String
    let meaningJa: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(phrase)
                .fontWeight(.semibold)
            Text(meaningJa)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    SimilarRowView(phrase: "subtle", meaningJa: "控えめな")
}
