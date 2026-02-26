//
//  CardBackView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/21.
//

import SwiftUI

struct CardBackView: View {
    @Binding var isFliped: Bool
    
    var body: some View {
        VStack {
            Text("Let's decide on the fly.")
            Button {
                isFliped = false
            } label: {
                Text("次へ")
            }
        }
        .padding(20)
        .frame(width: 320, height: 480, alignment: .top)
        .background(.white)
        .cornerRadius(20)
    }
}
//
//#Preview {
//    CardBackView()
//}
