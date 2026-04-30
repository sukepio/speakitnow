//
//  SearchViewModel.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/09.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [SearchedResultItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = PhraseRepository()
    
    private var hasSearched: Bool = false
    
    var trimmedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var canSearch: Bool {
        !trimmedQuery.isEmpty
    }
    
    var isInitialState: Bool {
        !hasSearched && results.isEmpty && trimmedQuery.isEmpty
    }
    
    var hasNoResults: Bool {
        hasSearched && !isLoading && errorMessage == nil && results.isEmpty
    }
    
    // 検索
    func performSearch() async {
        if trimmedQuery.isEmpty {
            return
        }
        
        hasSearched = true
        
        errorMessage = nil
        isLoading = true
        
        do {
            defer {
                isLoading = false
            }
            
            let searchResult: [Phrase] = try await repository.searchPhrases(query: trimmedQuery)
            let searchResultItems: [SearchedResultItem] = convertToSearchedResultItems(phrases: searchResult)
            if !searchResultItems.isEmpty {
                results = searchResultItems
                return
            }
            // LLM検索
            
        } catch {
            errorMessage = "エラーが発生しました。"
        }
        
        results = []
    }
    
    func resetSearch() {
        searchText = ""
        results = []
        // TODO: what to do when pressing the clear button in the middle of searching
        isLoading = false
        errorMessage = nil
        hasSearched = false
    }
    
    private func convertToSearchedResultItems(phrases: [Phrase]) -> [SearchedResultItem] {
        phrases.map { phrase in
            SearchedResultItem(
                content: SearchResultContent.saved(phrase)
            )
        }
    }
    
    private func convertToSearchedResultItems(generatedPhrases: [GeneratedPhrase]) -> [SearchedResultItem] {
        generatedPhrases.map { phrase in
            SearchedResultItem(
                content: SearchResultContent.generated(phrase)
            )
        }
    }
    
}
