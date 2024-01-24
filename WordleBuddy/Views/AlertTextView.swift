//
//  AlertTextView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/20/24.
//

import SwiftUI

struct AlertTextView: View {
    let word: String

    var body: some View {
        VStack {
                Text(word)
                    .font(.system(size: 18, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.primary.opacity(0.6)))
        }
    }
}

#Preview {
    AlertTextView(word: "Duplicate Word")
}
