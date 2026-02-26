//
//  InstantCompositionPlayView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/20.
//

import SwiftUI

struct InstantCompositionPlayView: View {
    @Environment(\.dismiss) private var dimiss
    @State private var isFliped: Bool = false
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                VStack {
                    HStack {
                        Button {
                            dimiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("1 / 5問目")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(10)
                    
                    ProgressView(value: 0.2)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                ZStack {
                    if !isFliped {
                        CardFrontView(isFliped: $isFliped)
                    } else {
                        CardBackView(isFliped: $isFliped)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y:1, z: 0))
                    }
                }
                .rotation3DEffect(
                    .degrees(isFliped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(20)
        }
    }
    
    
}


#Preview {
    InstantCompositionPlayView()
}
