//
//  model.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/27/23.
//

import Foundation
import RegexBuilder

class WordleBuddyLogic: ObservableObject {
    let fileName = "words.txt"
    
    private var wordleWords = Set<Substring>()
    
    init() {
        readWords()
    }
    
    // Helper function to read in words.txt and store in wordleWords set
    func readWords() {
        do {
            if let url = Bundle.main.url(forResource: "words", withExtension: "txt") {
                let contents = try String(contentsOf: url)
                let lines = contents.split(separator: "\n")
                for line in lines {
                    wordleWords.insert(line)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Returns true if the given word is a possible wordle word, false otherwise
    func contains(_ word: Substring) -> Bool {
        if word.count != 5 {
            return false
        }
        
        let lowerCase = word.lowercased()
        return self.wordleWords.contains(lowerCase[lowerCase.startIndex..<lowerCase.endIndex])
    }
    
    // Given a list of "guesses" aka patterns the wordle word must match, GetWordleWords returns
    // all the words that match that pattern
    func getWordleWords(words: [Guess]) -> [Substring] {
        var ans: [Substring] = Array(wordleWords)
        
        for guess in words {
            for pattern in guess.regexes {
                ans = filterWords(words: ans, pattern: pattern)
            }
        }
        
        return ans
    }
    
    // Given an input list of words and a regex pattern, returns the words that satisfy the pattern
    func filterWords(words: [Substring], pattern: Regex<Substring>) -> [Substring] {
        return words.filter {
            if let _ = try? pattern.wholeMatch(in: $0) {
                return true
            }
            return false
        }
    }
}


struct Guess: Identifiable, CustomStringConvertible {
    var description: String {
        "Word: " + word.map {$0.letter}.joined()
    }
    
    var id: UUID = UUID()
    var word: [Letter]
    var regexes: [Regex<Substring>] = []
    
    init() {
        self.word = []
        self.regexes = getRegex()
    }
    
    init(word: [Letter]) {
        self.word = word
        self.regexes = getRegex()
    }
    
    init(word: String) {
        self.word = []
        for ch in word {
            let currLetter = Letter(letter: "\(ch)", color: .Gray)
            self.word.append(currLetter)
        }
        self.regexes = getRegex()
    }
    
    func getString() -> String {
        return word.map {
            $0.letter
        }.joined()
    }
    
    func getRegex() -> [Regex<Substring>] {
        var ans: [Regex<Substring>] = []
        
        var lettersToIgnore: [String] = []
        var lettersCorrect: [String] = [".", ".", ".", ".", "."]
    
        // Make regexes for yellow, add letters to ignored for gray, and add letters to correct for green
        for i in 0..<self.word.count {
            switch self.word[i].color {
            case .Gray:
                lettersToIgnore.append(self.word[i].letter)
            case .Yellow:
                // Everything but the i'th position can have that letter
                let regex = Regex {
                    Repeat(count: i) {
                        .any
                    }
                    NegativeLookahead(self.word[i].letter)
                    Repeat(count: 5-i) {
                        .any
                    }
                }
                ans.append(regex)
            case .Green:
                lettersCorrect[i] = self.word[i].letter
            }
        }
        
        // Add lettersToIgnore to regex list
        if lettersToIgnore.count > 0 {
            let ignoreLetterRegex = Regex {
                NegativeLookahead {
                    ZeroOrMore(.any)
                    ChoiceOf(lettersToIgnore)
                }
                ZeroOrMore(.any)
            }
            ans.append(ignoreLetterRegex)
        }
        
        // Add lettersCorrect to regex list
        do {
            let correctLettersRegex = try Regex<Substring>(lettersCorrect.joined())
            ans.append(correctLettersRegex)
        } catch {
            print("Couldn't create regex?") // Should never throw an error
        }
                
        return ans
    }
}

struct Letter: Identifiable {
    var id: UUID = UUID()
    
    let letter: String // Character of letter
    var color: WordColor // Gray, Green, or Yellow
    
    init(letter: String, color: WordColor) {
        self.letter = letter
        self.color = color
    }
    
    mutating func rotateColor() {
        switch self.color {
        case .Gray:
            self.color = .Yellow
        case .Yellow:
            self.color = .Green
        case .Green:
            self.color = .Gray
        }
    }
}
                       
// Wordle Letter Possible colors in game flow
enum WordColor {
    case Green
    case Gray
    case Yellow
}

extension ChoiceOf where RegexOutput == Substring {
    init<S: Sequence<String>>(_ components: S) {
        let exps = components.map { AlternationBuilder.buildExpression($0) }
        
        guard !exps.isEmpty else {
            fatalError("Empty choice!")
        }
        
        self = exps.dropFirst().reduce(AlternationBuilder.buildPartialBlock(first: exps[0])) { acc, next in
            AlternationBuilder.buildPartialBlock(accumulated: acc, next: next)
        }
    }
}
