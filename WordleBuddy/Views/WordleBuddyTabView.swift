//
//  WordleBuddyTabView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/29/23.
//

import SwiftUI

struct WordleBuddyTabView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    @State private var defaultPage: Int = 1
    
    var body: some View {
        TabView(selection: $defaultPage) {
            WordleGenView()
                .tabItem { Text("Wordle Gen🤮") }
                .environmentObject(model)
                .tag(1)
                .preferredColorScheme(model.inDarkMode ? .dark : .light)
            FilterUsedView()
                .tabItem { Text("Check If Used 😤")}
                .environmentObject(model)
                .tag(2)
                .preferredColorScheme(model.inDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    WordleBuddyTabView()
        .environmentObject(WordleBuddyLogic())
}
