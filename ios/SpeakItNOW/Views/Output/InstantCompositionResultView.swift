//
//  InstantCompositionResultView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/04.
//

import SwiftUI

struct InstantCompositionResultView: View {
    @ObservedObject var instantCompositionViewModel: InstantCompositionViewModel
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 お疲れ様でした！")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Button("終了して戻る") {
                onDismiss()
            }
            .font(.headline)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

//#Preview {
//    InstantCompositionResultView()
//}
