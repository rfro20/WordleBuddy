//
//  WordleBuddyTests.swift
//  WordleBuddyTests
//
//  Created by Ryan Frohman on 12/3/23.
//

import XCTest
@testable import WordleBuddy

final class WordleBuddyTests: XCTestCase {
    
    func testLoadWords() throws {
        let expectedNumWords = 14855
        let backend = WordleBuddyLogic()
        XCTAssert(backend.wordleWords.count == expectedNumWords)
    }
    
    func testWordleDec27() throws {
        let guess1 = Guess(word: [
            Letter(letter: "f", color: .Gray),
            Letter(letter: "l", color: .Gray),
            Letter(letter: "a", color: .Yellow),
            Letter(letter: "k", color: .Gray),
            Letter(letter: "e", color: .Gray)
        ])
        let guess2 = Guess(word: [
            Letter(letter: "s", color: .Yellow),
            Letter(letter: "a", color: .Green),
            Letter(letter: "v", color: .Gray),
            Letter(letter: "o", color: .Gray),
            Letter(letter: "r", color: .Gray)
        ])
        let guess3 = Guess(word: [
            Letter(letter: "p", color: .Gray),
            Letter(letter: "a", color: .Green),
            Letter(letter: "n", color: .Gray),
            Letter(letter: "s", color: .Green),
            Letter(letter: "y", color: .Green)
        ])
        
        let guesses = [guess1, guess2, guess3]
        let backend = WordleBuddyLogic()
        let possibleWords = backend.getWordleWords(words: guesses)
        XCTAssert(possibleWords.contains("daisy"))
        XCTAssert(possibleWords.count == 7)
    }
    
}
