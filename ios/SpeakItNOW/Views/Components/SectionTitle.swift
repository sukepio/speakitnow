//
//  SectionTitle.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/29.
//

import SwiftUI

struct SectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .opacity(0.7)
    }
}

#Preview {
    SectionTitle(title: "意味")
}
