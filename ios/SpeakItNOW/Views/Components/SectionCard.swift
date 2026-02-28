//
//  SectionCard.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import SwiftUI

struct SectionCard<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.2))
        )
        
    }
}

//#Preview {
//    SectionCard()
//}
