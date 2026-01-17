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

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)

            Text("My Phrases")
                .tabItem {
                    Label("My Phrases", systemImage: "bookmark")
                }
                .tag(Tab.myPhrases)

            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)

            Text("History")
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(Tab.history)
        }
        .tint(.blue)
    }
}


#Preview {
    RootTabView()
}

