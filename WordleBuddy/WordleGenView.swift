//
//  WordleGenView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/29/23.
//

import SwiftUI

struct WordleGenView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    @State private var wordleWord: String = ""
    @State private var wordleWords: [Guess] = [] // TODO: Refactor to be [Guess]
    
    @State private var invalidEntry: Bool = false
    @State private var invalidEntryText: String = ""
    
    @State private var emptySubmit: Bool = false
    @State private var emptyGuess: Guess = Guess(word: [])
    
    @State private var navigationPath: [[Substring]] = []
    
    private func processWord() {
        if wordleWords.count == 5 {
            self.invalidEntryText = "Already have 5 words added!"
            invalidEntry.toggle()
        } else if wordleWord.count != 5 {
            self.invalidEntryText = "\(wordleWord.capitalized) does not have 5 letters!"
            invalidEntry.toggle()
        } else if !model.contains(wordleWord[wordleWord.startIndex..<wordleWord.endIndex]){
            self.invalidEntryText = "\(wordleWord.capitalized) is not in the wordle database!"
            invalidEntry.toggle()
        } else if wordleWords.map({$0.getString()}).contains(wordleWord) {
            self.invalidEntryText = "\(wordleWord.capitalized) has already been added!"
            invalidEntry.toggle()
        } else {
            self.wordleWords.append(Guess(word: wordleWord))
        }
        self.wordleWord = ""
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack {
                    // Enter wordle word logic
                    VStack {
                        TextField("Enter your wordle guess", text: $wordleWord)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .onSubmit {
                                processWord()
                            }
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Add") {
                            processWord()
                            
                        }.alert(invalidEntryText, isPresented: $invalidEntry, actions: {
                            Button("Ok") {}
                        })
                        .buttonStyle(.bordered)
                    }
                    .frame(height: 200)
                    
                    // Up to 5 rows of wordle words
                    ForEach($wordleWords) { $word in
                        WordleWordView(guess: $word)
                    }
                    if self.wordleWords.count < 5 {
                        ForEach(wordleWords.count+1...5, id:\.self) { _ in
                            WordleWordView(guess: $emptyGuess)
                        }
                    }
                    Spacer(minLength: 30)
                    
                    // Generate possible words based on input
                    Button("Generate Possilities🫣") {
                        if wordleWords.count == 0 {
                            emptySubmit = true
                        } else {
                            let wordleSubstringWords = self.wordleWords.map {
                                let wordString = $0.getString()
                                return wordString[wordString.startIndex..<wordString.endIndex]
                            }
                            // TODO: Append wordle generated words to path
                            navigationPath.append(wordleSubstringWords)
                            self.wordleWords = []
                        }
                    }
                    .buttonStyle(.bordered)
                    .alert("No words entered!", isPresented: $emptySubmit) {
                        Button("Ok") {}
                    }
                    
                }
            }.navigationDestination(for: [Substring].self) { generated in
                WordsGeneratedView(generatedWords: generated)
            }
        }
    }
}

// TODO: Add option to filter used
struct WordsGeneratedView: View {
    let words: [Substring]
    
    init(generatedWords: [Substring]) {
        self.words = generatedWords
    }
    
    var body: some View {
        VStack {
            List(words, id:\.self) { word in
                Text("Possible Word: \(String(word))")
            }
        }
    }
}

struct WordleWordView: View {
    @Binding var guess: Guess
    
//    init(word: String) {
//        var letters: [Letter] = []
//        for ch in word {
//            // Start all letters as gray, user can modify after added
//            let currLetter = Letter(letter: "\(ch)", color: .Gray)
//            letters.append(currLetter)
//        }
//        print("Before adding", letters)
//        self.guess = Guess(word: letters)
//        print("After adding", self.guess)
//    }
    
    var body: some View {
        HStack {
            ForEach(0...4, id:\.self) { i in
                Text("\(self.guess.word.count == 5 ? self.guess.word[i].letter : "")")
                    .foregroundStyle(.black)
                    .font(.system(size: 48, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.gray)
                    .frame(width: 40, height: 40, alignment: .center)
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(guess.word.count == 0 || guess.word[i].color == .Gray ? .gray : (guess.word.count != 5 || guess.word[i].color == .Yellow ? .yellow : .green))
                    .onTapGesture {
                        if guess.word.count != 0 {
                            guess.word[i].rotateColor()
                        }
                    }
                    .border(.black)
            }
        }.padding()
    }
}

#Preview {
    WordleGenView()
        .environmentObject(WordleBuddyLogic())
}
