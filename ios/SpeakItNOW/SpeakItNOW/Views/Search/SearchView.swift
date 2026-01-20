//
//  SearchView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var isLoading: Bool = false
    @State private var results: [Phrase] = []
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                Text("Search")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("", text: $query, prompt: Text("Enter phrase or word"))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.top, 32)
                
                if results.isEmpty && query.isEmpty {
                    Text("学びたい語句を入力して検索しましょう")
                        .foregroundStyle(.white)
                        .padding(.top, 24)
                }
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    SearchView()
}
