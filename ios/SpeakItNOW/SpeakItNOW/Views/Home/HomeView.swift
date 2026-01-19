//
//  HomeView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("おすすめフレーズ")
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                    }
                }
                
                ForEach(phraseStore.recommendedPhrases){ phrase in PhraseRow(phrase: phrase, isSelected: phrase.id == phraseStore.selectedPhraseId)
                }
                
                Button {
                    
                } label: {
                    Text("今すぐアウトプット")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(20)
                
            }
                .padding()
                .background(.white)
                .cornerRadius(20)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PhraseStore())
}
