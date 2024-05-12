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
    @State private var navigationPath: [String] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {

                MatrixGrid(width: 5, height: 1, spacing: 4
                ) { _, col in
                    LetterBoxView(letter: $model.filterusedLetters[col], row: 0, col: col, gameFlow: .FilterUsed)
                        .modifier(Shake(animatableData: CGFloat(model.shakeRowFilterUsed)))
                }.padding(20)
                
                Spacer()
                
                KeyboardView(gameFlow: .FilterUsed)
                    .environmentObject(model)
                    .padding(10)
                HStack {
                    Button {
                        model.resetFilterUsed()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.red.opacity(0.9))
                            Text("Clear")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .medium, design: .monospaced))
                        }
                        .frame(maxWidth: 300, maxHeight: 50)
                    }
                    Button {
                        let currWord = model.filterusedLetters.getWord()
                        if currWord.count != 5 {
                            model.shakeRowFilter()
                            model.showFiltered(text: "Invalid Word!")
                        } else {
                            let isUsed = model.isUsed(currWord[...])
                            if isUsed {
                                model.showFiltered(text: "\(currWord) HAS been used")
                            } else {
                                model.showFiltered(text: "\(currWord) has NOT been used")
                            }
                        }
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                            Text("Enter")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .medium, design: .monospaced))
                        }
                        .frame(maxWidth: 300, maxHeight: 50)
                    }
                }.padding(5)

            }
            .navigationDestination(for: String.self) { str in
                switch str {
                case "settings":
                    SettingsView()
                        .environmentObject(model)
                default:
                    Text("Coming Soon!")
                        .font(.system(size: 48, design: .monospaced))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // TODO: Set up settings page
                        // 1) Dark Mode
                        // any other settings can be added here
                        navigationPath.append("settings")
                    } label: {
                        Image(systemName: "gear.circle")
                            .scaleEffect(1.2)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Set up help page
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .scaleEffect(1.2)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Word Checker")
                        .font(.system(size: 26, weight: .medium, design: .monospaced))
                }
            }
        }
        .overlay {
            if model.filterusedText != "" {
                AlertTextView(word: model.filterusedText)
                    .offset(y: -100)
                    .scaleEffect(1.2)
            }
        }
    }
}

#Preview {
    FilterUsedView()
        .environmentObject(WordleBuddyLogic())
}
