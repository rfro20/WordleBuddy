//
//  WordleBuddyTabView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/29/23.
//

import SwiftUI

struct WordleBuddyTabView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    var body: some View {
        TabView {
            WordleGenView()
                .tabItem { Text("Wordle Gen🤮") }
                .environmentObject(model)
            FilterUsedView()
                .tabItem { Text("Check If Used 😤")}
                .environmentObject(model)
        }
    }
}

#Preview {
    WordleBuddyTabView()
}
