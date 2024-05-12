//
//  SettingsView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/24/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    var body: some View {
        VStack {
            Toggle(isOn: $model.inDarkMode) {
                Text("Dark Mode🌚")
                    .offset(x: 10)
                // TODO: Add any other settings as needed
            }.padding()
            
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.system(size: 32, weight: .medium, design: .monospaced))
            }
        }
        
    }
}

#Preview {
    SettingsView()
        .environmentObject(WordleBuddyLogic())
}
