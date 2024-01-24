//
//  FilterUsedView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/29/23.
//

import SwiftUI

struct FilterUsedView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    @State private var isFiltering: Bool = false

    var body: some View {
        VStack {
            Text("Word Usage Checker")
                .font(.system(size: 32, weight: .heavy, design: .monospaced))
            
            MatrixGrid(width: 5, height: 1, spacing: 4
            ) { _, col in
                LetterBoxView(letter: $model.filterusedLetters[col], row: 0, col: col, gameFlow: .FilterUsed)
            }.padding(20)

            Spacer()
            
            // TODO: Implement filter used functionality
            if isFiltering {
                let x = "hi"
                Text("hi")
            }
            
            Spacer()
            HStack {
                Button {
                    model.resetFilterUsed()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.red.opacity(0.9))
                        Text("Clear")
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                    }
                    .frame(maxWidth: 300, maxHeight: 50)
                }
                Button {
                    print("filter!")
                    isFiltering.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                        Text("Enter")
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                    }
                    .frame(maxWidth: 300, maxHeight: 50)
                }
            }.padding(5)
            
            KeyboardView(gameFlow: .FilterUsed)
                .environmentObject(model)
                .padding(10)
        }
        
    }
}

#Preview {
    FilterUsedView()
        .environmentObject(WordleBuddyLogic())
}
