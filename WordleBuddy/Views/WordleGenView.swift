//
//  WordleGenView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/29/23.
//

import SwiftUI

struct WordleGenView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    // For alerting when no words are submitted to wordle gen
    @State private var emptySubmit: Bool = false
    
    // For adding wordle gen view on submit
    @State private var navigationPath: [[Substring]] = []
        
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                MatrixGrid(width: 5, height: 5, spacing: 4
                ) { row, col in
                    LetterBoxView(letter: $model.letters[row][col], row: row, col: col, gameFlow: .WordleGen)
                        .modifier(Shake(animatableData: CGFloat(model.shakeRow[row])))
                        .environmentObject(model)
                }
                
                KeyboardView(gameFlow: .WordleGen)
                    .environmentObject(model)
                    .padding(10)
                
                HStack {
                    Button(action: {
                        model.reset()
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        Text("Clear")
                            .foregroundStyle(.white)
                            .frame(height:10)
                            .font(.system(size:16, weight:.medium, design:.monospaced))
                    }
                    .buttonStyle(GrowingButton(backgroundColor: .red, pressedColor: .gray))
                    
                    // Generate possible words based on input
                    Button(action: {
                        if !model.isValidSubmit {
                            model.shakeRow(row: model.currentRow)
                            model.showMessage(text: "Invalid Submit")
                        } else {
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            let possibleWords = model.getWordleWords()
                            navigationPath.append(possibleWords)
                        }
                    }) {
                        Text("Generate 🫣")
                            .foregroundStyle(.white)
                            .frame(height:10)
                            .font(.system(size:16, weight:.medium, design:.monospaced))
                    }
                    .buttonStyle(GrowingButton(backgroundColor: .blue, pressedColor: .gray))
                    .alert("No words entered!", isPresented: $emptySubmit) {
                        Button("Ok") {}
                    }
                    
                }
            }
            .navigationDestination(for: [Substring].self) { substr in
                switch substr {
                case ["settings"]:
                    SettingsView()
                        .environmentObject(model)
                default:
                    GeneratedWordsView(generatedWords: substr)
                }
            }
            .frame(width: Global.boardWidth, height: Global.boardWidth * 6 / 5)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navigationPath.append(["settings"])
                        // TODO: Set up settings page
                        // 1) Dark Mode
                        // any other settings can be added here
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
                    Text("WordleBuddy")
                        .font(.system(size: 28, weight: .medium, design: .monospaced))
                }
            }
        }
        .overlay(alignment: .top) {
            if model.alertText != "" {
                AlertTextView(word: model.alertText)
                    .offset(y: 60)
            }
        }
    }
}

struct GrowingButton: ButtonStyle {
    private let backgroundColor: Color
    private let pressedColor: Color
    init(backgroundColor: Color, pressedColor: Color) {
        self.backgroundColor = backgroundColor
        self.pressedColor = pressedColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? self.pressedColor: self.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 2 : 1)
            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
    }
}

#Preview {
    WordleGenView()
        .environmentObject(WordleBuddyLogic())
}

struct MatrixGrid<Content: View>: View {
    typealias GridItemFactory = (_ row: Int, _ column: Int) -> Content
    let width: Int
    let height: Int
    let spacing: CGFloat
    let gridItemFactory: GridItemFactory
    
    private var columns: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: width)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
            ForEach(0..<height) { row in
                ForEach(0..<width) { column in
                    gridItemFactory(row, column)
                }
            }
        }
    }
}
