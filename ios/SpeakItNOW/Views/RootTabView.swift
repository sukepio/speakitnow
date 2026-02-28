//
//  RootTabView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

enum Tab {
    case home, myPhrases, search, history
}

struct RootTabView: View {
    @State private var selectedTab: Tab = .home
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = .white
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            tabItemView(destination: HomeView(), imageName: "house", title: "Home", tag: Tab.home)
            tabItemView(destination: SearchView(), imageName: "magnifyingglass", title: "Search", tag: Tab.search)
            tabItemView(destination: MyPhrasesView(), imageName: "bookmark", title: "My Phrases", tag: Tab.myPhrases)
            tabItemView(destination: Text("History"), imageName: "clock", title: "History", tag: Tab.history)
        }
        .tint(.blue)
    }
    
    @ViewBuilder
    private func tabItemView<Destination: View>(destination: Destination, imageName: String, title: String, tag: Tab) -> some View {
        destination
            .tabItem {
                Label(title, systemImage: imageName)
            }
            .tag(tag)
    }
}


#Preview {
    RootTabView().environmentObject(PhraseStore())
}

