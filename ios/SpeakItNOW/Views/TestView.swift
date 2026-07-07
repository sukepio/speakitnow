//
//  TestView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/27.
//

import SwiftUI

struct TestView: View {
    
    @StateObject var store = PhraseStore()
    private let repository = PhraseRepository()
    @State var phrase: String = "before fetch"
    
    var body: some View {
//        Text(store.phrases.first?.phraseDetails.tips ?? store.errorMessage ?? "")
//            .task {
//                await store.loadPhrases()
//            }
        
        TextField("", text: $phrase)
//        
//        Button {
//            Task {
//                do {
//                    print("test")
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        } label : {
//            Text("Press here")
//        }
    }
}

#Preview {
    TestView()
}
