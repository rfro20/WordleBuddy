//
//  model.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 12/27/23.
//

import Foundation
import RegexBuilder
import SwiftSoup
import SwiftUI

enum WordleBuddyFlow {
    case WordleGen
    case FilterUsed
}

class WordleBuddyLogic: ObservableObject {
    
    // For programatically changing between light and dark mode
    @Published var inDarkMode: Bool = false
    
    // Grid of each letter and its color
    @Published var letters: [[Letter?]]
    
    // For tracking in the letters matrix when a user would like to append/delete a letter
    var currentRow: Int = 0
    var currentCol: Int = 0
    
    // Used to display text on the filter used page after a user hits submit
    @Published var filterusedText: String = ""
    
    // Used to display alert messages such as "duplicate word" or "invalid entry"
    @Published var alertText: String = ""
    
    // Used to "shake" a specific row if the user entered a duplicate word in that row
    @Published var shakeRow: [Int]
    @Published var shakeRowFilterUsed: Int
    
    // Letters the user will input for filterused functionality
    @Published var filterusedLetters: [Letter?]
    
    // For tracking in the filterusedLetters array when a user would like to append/delete a letter
    var currentColFilter: Int = 0
    
    var loadingFilter: Bool = true
    
    // Width -> Cols, Height -> Rows
    let width: Int = 5
    let height: Int = 5
    
    var isValidSubmit: Bool {
        return currentCol % 5 == 0 && currentRow > 0
    }
    
    private let usedWordsURL = "https://www.rockpapershotgun.com/wordle-past-answers"
    private let fileName = "words.txt"
    
    private var wordleWords = Set<Substring>() // wordle gen functionality
    private var usedWords = Set<String>() // filterused functionality
    
    init() {
        letters = Array(repeating: Array(repeating: nil, count: width), count: height)
        shakeRow = Array(repeating: 0, count: width)
        shakeRowFilterUsed = 0
        filterusedLetters = Array(repeating: nil, count: width)
        readWordleWords()
        Task {
            await readUsedWords()
        }
    }
    
    func reset() {
        letters = Array(repeating: Array(repeating: nil, count: width), count: height)
        currentRow = 0
        currentCol = 0
    }
    
    func resetFilterUsed() {
        filterusedLetters = Array(repeating: nil, count: width)
        currentColFilter = 0
    }
    
    // Helper function to read in words.txt and store in-memory in wordleWords
    func readWordleWords() {
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
    
    // Scrapes the used words website to get all 5 letter words and store them in-memory in usedWords
    func readUsedWords() async {
        defer {
            loadingFilter = false
        }
        
        do {
            if let url = URL(string: usedWordsURL) {
                let (data, _) = try await URLSession.shared.data(from: url)
                let html = String(data: data, encoding: .ascii)!
                let doc: Document = try SwiftSoup.parse(html)
                
                let lis: Elements = try doc.select("li")
                for element in lis {
                    let currWord = try element.text()
                    
                    if currWord.count == 5 && isValidInput(currWord) && currWord.uppercased() == currWord {
                        usedWords.insert(currWord.lowercased())
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Given an input letter, tries to append to the board if all 25 spots are not filled.
    // If they are all filled, returns false.
    func appendLetter(letter: String) -> Bool {
        // letters[currentRow][currentCol] will track an empty position to put it. if that doesn't track to a valid location, return
        guard 0 <= currentRow && currentRow < height && 0 <= currentCol && currentCol < width else {
            return false
        }
        
        self.letters[currentRow][currentCol] = Letter(letter: letter, loc: currentCol, color: .Gray)
        currentCol += 1
    
        if currentCol == width && currentRow < height - 1 {
            if validateNoDuplicates() {
                currentRow += 1
            } else {
                shakeRow(row: currentRow)
                self.letters[currentRow] = Array(repeating: nil, count: width)
                self.showMessage(text: "Duplicate Word")
            }
            currentCol = 0
        }
        return true
    }
    
    func shakeRow(row: Int) {
        guard 0 <= row && row < height else {
            return
        }
        
        withAnimation {
            self.shakeRow[row] += 1
        }
        self.shakeRow[row] = 0
    }
    
    func shakeRowFilter() {
        withAnimation {
            self.shakeRowFilterUsed += 1
        }
        self.shakeRowFilterUsed = 0
    }
    
    // Utility function to make sure the current line of input in the board is not already present
    private func validateNoDuplicates() -> Bool {
        var words = Set<String>()
        
        for i in 0...currentRow {
            let currWord = letters[i].map {
                $0?.letter ?? ""
            }.joined().uppercased()
            words.insert(currWord)
        }
        
        return words.count == currentRow + 1
    }
    
    // Tries to delete letter from board if there is at least one letter on the board
    func deleteLetter() -> Bool {
        guard currentRow > 0 || currentCol > 0 else {
            return false
        }
        
        if currentCol > 0 {
            currentCol -= 1
        } else {
            // if currentRow was zero, this code would never get reached (currentCol is zero here)
            currentRow -= 1
            currentCol = width - 1
        }
        
        self.letters[currentRow][currentCol] = nil
        return true
    }
    
    func appendFilterLetter(letter: String) -> Bool {
        guard currentColFilter < 5 else {
            return false
        }
        filterusedLetters[currentColFilter] = Letter(letter: letter, loc: filterusedLetters.count, color: .Gray)
        currentColFilter += 1
        return true
    }
    
    func deleteFilterLetter() -> Bool {
        guard currentColFilter > 0 else {
            return false
        }
        currentColFilter -= 1
        filterusedLetters[currentColFilter] = nil
        return true
    }
    
    // Rotates the color in the letters matrix at the specified position. Order is: Green -> Yellow -> Gray -> ...
    func changeColor(row: Int, col: Int) {
        guard 0 <= row && row < height && 0 <= col && col < width else {
            return
        }
        switch letters[row][col]?.color {
        case .Green:
            letters[row][col]!.color = .Yellow
        case .Yellow:
            letters[row][col]!.color = .Gray
        case .Gray:
            letters[row][col]!.color = .Green
        default:
            return
        }
    }
    
    // Returns true if all letters in the string are alphabetic, false otherwise
    private func isValidInput(_ string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        return string.unicodeScalars.allSatisfy(allowedCharacters.contains)
    }
    
    func showMessage(text: String) {
        withAnimation {
            self.alertText = text
        }
        withAnimation(.linear(duration: 0.2).delay(1.3)) {
            self.alertText = ""
        }
    }
    
    func showFiltered(text: String) {
        withAnimation {
            self.filterusedText = text
        }
        withAnimation(.linear(duration: 0.2).delay(4)) {
            self.filterusedText = ""
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
    
    // Returns true if a given word has been used on a previous daily wordle, false otherwise
    func isUsed(_ word: Substring) -> Bool {
        if word.count != 5 {
            return false
        }
        
        let lowerCase = word.lowercased()
        return self.usedWords.contains(lowerCase)
    }
    
    // Given the current state of the letters matrix, GetWordleWords returns
    // all the words that match that pattern for each row
    func getWordleWords() -> [Substring] {
        var ans: [Substring] = Array(wordleWords)
        
        for i in 0..<currentRow {
            let currGuess = Guess(word: letters[i])
            for pattern in currGuess.getRegex() {
                ans = filterWords(words: ans, pattern: pattern)
            }
        }
        
        return ans.sorted()
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
        "Word: " + word.description
    }
    
    var id: UUID = UUID()
    var word: [Letter?]
    
    init() {
        self.word = []
    }
    
    init(word: [Letter?]) {
        self.word = word
    }
    
    init(word: [Letter]) {
        self.word = word
    }
    
    init(word: String) {
        self.word = []
        for i in 0..<word.count {
            let ch = word[word.index(word.startIndex, offsetBy: i)]
            let currLetter = Letter(letter: "\(ch.lowercased())", loc: i, color: .Gray)
            self.word.append(currLetter)
        }
    }
    
    func getString() -> String {
        return word.map {
            $0?.letter ?? ""
        }.joined().uppercased()
    }
    
    func getRegex() -> [Regex<Substring>] {
        var ans: [Regex<Substring>] = []
        
        // Inserts letters into 
        var count: [String:[Letter]] = [:]
        func insertInOrder(letter: Letter?) {
            var letters = count[letter!.letter]!
            for i in 0..<letters.count {
                if letter!.color.rawValue < letters[i].color.rawValue {
                    letters.insert(letter!, at: i)
                    count[letter!.letter] = letters
                    return
                }
            }
            letters.append(letter!)
            count[letter!.letter] = letters
        }
        
        // Get count of each letter in word for processing by-letter
        for ch in self.word {
            if count.contains(where: {$0.key == ch?.letter}) {
                insertInOrder(letter: ch)
            } else {
                count[ch!.letter] = [ch!]
            }
        }
        
        for (_, letterList) in count {
            ans += getRegexes(letters: letterList)
        }
        
        return ans
    }
    
    func getRegexes(letters: [Letter]) -> [Regex<Substring>] {
        if letters.count == 0 {
            return []
        }
        
        let currLetter = letters[0].letter
        var numOccurences: Int = 0
        var cantBeInLocs: [Int] = []
        var inLocs: [Int] = []
        
        for letter in letters {
            switch letter.color {
            case .Green:
                numOccurences += 1
                inLocs.append(letter.loc)
            case .Yellow:
                numOccurences += 1
                cantBeInLocs.append(letter.loc)
            case .Gray:
                if numOccurences > 0 {
                    cantBeInLocs.append(letter.loc)
                }
            }
        }
        
        if numOccurences > 0 {
            var ans: [Regex<Substring>] = [mustHaveCount(ch: currLetter, count: numOccurences)]
            
            for loc in cantBeInLocs {
                ans.append(cantBeInPos(ch: currLetter, loc: loc))
            }
            
            for loc in inLocs {
                ans.append(inPos(ch: currLetter, loc: loc))
            }
            
            return ans
        } else {
            return [notInWord(ch: currLetter)]
        }
    }
}

struct Letter: Identifiable, Hashable, CustomStringConvertible {
    var description: String {
        letter + " with color \(color)"
    }
    
    var id: UUID = UUID()
    
    let letter: String // Character of letter
    let loc: Int // Position of the letter in its respective word
    var color: LetterColor // Gray, Green, or Yellow
    
    init(letter: String, loc: Int, color: LetterColor = .Gray) {
        self.letter = letter
        self.loc = loc
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
// Sorted by Green -> Yellow -> Gray
enum LetterColor: Int {
    case Green = 0
    case Yellow = 1
    case Gray = 2
}

// Regex Stuff
func mustHaveCount(ch: String, count: Int) -> Regex<Substring> {
    return Regex {
        Repeat(count: count) {
            ZeroOrMore {
                .any
            }
            ch
            ZeroOrMore {
                .any
            }
        }
    }
}

func cantBeInPos(ch: String, loc: Int) -> Regex<Substring> {
    return Regex {
        Repeat(count: loc) {
            .any
        }
        NegativeLookahead {
            ch
        }
        Repeat(count: 5 - loc) {
            .any
        }
    }
}

func inPos(ch: String, loc: Int) -> Regex<Substring> {
    return Regex {
        Repeat(count: loc) {
            .any
        }
        ch
        Repeat(count: 5 - loc - 1) {
            .any
        }
    }
}

func notInWord(ch: String) -> Regex<Substring> {
    return Regex {
        NegativeLookahead {
            ZeroOrMore(.any)
            ch
        }
        ZeroOrMore(.any)
    }
}

