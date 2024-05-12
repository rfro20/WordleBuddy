//
//  GeneratedWordsView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/15/24.
//

import SwiftUI

struct GeneratedWordsView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    let generatedWords: [Substring]
    @State var filterUsedWords: [Substring]
    
    @State var displayWords: [Substring]
    @State var isFiltering: Bool = false
    
    init(generatedWords: [Substring]) {
        self.generatedWords = generatedWords
        self.filterUsedWords = []
        displayWords = generatedWords
    }
    
    var body: some View {
        VStack {
            if displayWords.count > 0 || isFiltering {
                Text("All Possible Words")
                    .font(.system(size: 32, weight: .heavy, design: .monospaced))
                // TODO: See if word count can be cleaner
                Text("Word Count: \(displayWords.count)")
                    .font(.system(size: 16, weight: .light, design: .monospaced))
                List(displayWords, id:\.self) { word in
                    Text("\(String(word))")
                        .font(.system(size: 24, weight: .medium, design: .monospaced))
                }
                .frame(maxWidth: .infinity, maxHeight: 500)
                .padding(10)
                Button {
                    if !isFiltering {
                        self.displayWords = filterUsedWords
                    } else {
                        self.displayWords = generatedWords
                    }
                    isFiltering.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isFiltering ? .blue.opacity(0.8) : .red.opacity(0.8))
                        Text(isFiltering ? "Restore" : "Remove Used Words")
                            .font(.system(size: 24, weight: .medium, design: .monospaced))
                            .foregroundStyle(.white)
                    }.frame(maxWidth: 300, maxHeight: 50) 
                }
            } else {
                Text("No words found :(")
                    .font(.system(size: 32, weight: .heavy, design: .monospaced))
                    .frame(height: 50)
                Text("Please make sure you entered your guesses correctly")
                    .font(.system(size: 16, weight: .light, design: .monospaced))
            }
            
        }.task {
            while model.loadingFilter {}
            self.filterUsedWords = generatedWords.filter{!model.isUsed($0)}
        }
        
    }
}

#Preview {
    GeneratedWordsView(generatedWords: ["cigar", "logic", "balls"])
        .environmentObject(WordleBuddyLogic())
}
