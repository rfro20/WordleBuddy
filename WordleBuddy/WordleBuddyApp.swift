//
//  WordleBuddyApp.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/3/23.
//

import SwiftUI

@main
struct WordleBuddyApp: App {
    @StateObject var model = WordleBuddyLogic()
    var body: some Scene {
        WindowGroup {
            WordleBuddyTabView()
                .environmentObject(model)
        }
    }
}
