//
//  SearchView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    @StateObject var searchViewModel = SearchViewModel()

    @State private var selectedPhrase: SearchedResultItem? = nil
    @State private var path: [DetailRoute] = []
        
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                Text("検索")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("", text: $searchViewModel.searchText, prompt: Text("Enter a word, phrase, idiom"))
                        .foregroundStyle(.black)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch()
                        }
                    
                    if searchViewModel.canSearch {
                        Button {
                            searchViewModel.resetSearch()
                            selectedPhrase = nil
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.gray)
                                .padding(2)
                                .contentShape(Rectangle())
                        }
                            .buttonStyle(.plain)
                    }
                    

                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.top, 32)
                
                content
                    .padding(.top, 24)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
        }
    }
    
    private func performSearch() {
        Task {
            await searchViewModel.performSearch()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if searchViewModel.isLoading {
            ProgressView()
                .tint(.white)
        } else if let message = searchViewModel.errorMessage {
            Text(message)
                .foregroundStyle(.red)
        } else if searchViewModel.isInitialState {
            Text("アウトプットしたい語句を検索しましょう")
                .foregroundStyle(.white)
        } else if searchViewModel.hasNoResults {
            Text("検索に該当する語句が見つかりませんでした")
                .foregroundStyle(.white)
        } else {
            List {
                ForEach(searchViewModel.results) { searchResult in
                    PhraseRow(item: searchResult.content)
                      .contentShape(Rectangle())
                      .onTapGesture {
                          selectedPhrase = searchResult
                      }
                      .listRowSeparator(.hidden)
                      .listRowBackground(Color.clear)
                      .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
              }
          }
            .sheet(item: $selectedPhrase) { phrase in
                NavigationStack(path: $path) {
                    PhraseDetailView(
                        phrase: ,
                        source: .search,
                        onStartOutput: { phrase, source in
                            path.append(.output(pharase: phrase, source: .search))
                        }
                    )
                    .navigationDestination(for: DetailRoute.self) { route in
                        switch route {
                        case.output(let phrase, let source):
                            OutputView(
                                phrase: phrase,
                                source: source
                            )
                        }
                    }
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(PhraseStore())
}

#Preview {
    SearchView().environmentObject(PhraseStore())
}

