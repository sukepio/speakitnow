////
////  HomeView.swift
////  
////
////  Created by 助名直人 on 2026/01/17.
////
//
//import SwiftUI
//
//struct HomeView: View {
//    @EnvironmentObject var phraseStore: PhraseStore
//    
//    var isEnabled: Bool {
//        phraseStore.selectedPhraseId != nil
//    }
//    
//    var body: some View {
//        ZStack {
//            Color(Color.black.opacity(0.9))
//                .ignoresSafeArea()
//            
//            VStack(alignment: .leading, spacing: 16) {
//                HStack {
//                    Text("おすすめフレーズ")
//                    
//                    Spacer()
//                    
//                    Button {
//                        
//                    } label: {
//                        Image(systemName: "arrow.trianglehead.2.clockwise")
//                    }
//                }
//                
//                ForEach(phraseStore.recommendedPhrases){ phrase in
//                    RecommendedPhraseRow(phrase: phrase, isSelected: phrase.id == phraseStore.selectedPhraseId)
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            withAnimation(.easeInOut(duration: 0.2)) {
//                                phraseStore.selectedPhraseId = phraseStore.selectedPhraseId != phrase.id ? phrase.id : nil
//                            }
//                        }
//                }
//                
//                Button {
//                    
//                } label: {
//                    Text("今すぐアウトプット")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white.opacity(isEnabled ? 1 : 0.8))
//                }
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical)
//                    .background(Color.blue.opacity(isEnabled ? 1 : 0.35))
//                    .cornerRadius(20)
//                    .disabled(!isEnabled)
//                
//            }
//                .padding()
//                .background(.white)
//                .cornerRadius(20)
//        }
//    }
//}
//
//#Preview {
//    HomeView()
//        .environmentObject(PhraseStore())
//}
