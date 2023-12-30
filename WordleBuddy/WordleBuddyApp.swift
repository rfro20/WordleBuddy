//
//  WordleBuddyApp.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/3/23.
//

import SwiftUI

@main
struct WordleBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            WordleGenView()
                .environmentObject(WordleBuddyLogic())
        }
    }
}
