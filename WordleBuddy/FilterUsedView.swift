//
//  FilterUsedView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/29/23.
//

import SwiftUI

struct FilterUsedView: View {
    @EnvironmentObject var model: WordleBuddyLogic

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FilterUsedView()
        .environmentObject(WordleBuddyLogic())
}
