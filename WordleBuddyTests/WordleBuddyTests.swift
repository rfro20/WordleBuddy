//
//  WordleBuddyTests.swift
//  WordleBuddyTests
//
//  Created by Ryan Frohman on 12/3/23.
//

import XCTest
@testable import WordleBuddy

final class WordleBuddyTests: XCTestCase {
    
    // Not using anymore because it works
//    func testLoadWords() throws {
//        let expectedNumWords = 14855
//        let backend = WordleBuddyLogic()
//        XCTAssert(backend.wordleWords.count == expectedNumWords)
//    }
    
    func testWordleDec27() throws {
        let guess1 = Guess(word: [
            Letter(letter: "f", loc: 0, color: .Gray),
            Letter(letter: "l", loc: 1, color: .Gray),
            Letter(letter: "a", loc: 2, color: .Yellow),
            Letter(letter: "k", loc: 3, color: .Gray),
            Letter(letter: "e", loc: 4, color: .Gray)
        ])
        let guess2 = Guess(word: [
            Letter(letter: "s", loc: 0, color: .Yellow),
            Letter(letter: "a", loc: 1, color: .Green),
            Letter(letter: "v", loc: 2, color: .Gray),
            Letter(letter: "o", loc: 3, color: .Gray),
            Letter(letter: "r", loc: 4, color: .Gray)
        ])
        let guess3 = Guess(word: [
            Letter(letter: "p", loc: 0, color: .Gray),
            Letter(letter: "a", loc: 1, color: .Green),
            Letter(letter: "n", loc: 2, color: .Gray),
            Letter(letter: "s", loc: 3, color: .Green),
            Letter(letter: "y", loc: 4, color: .Green)
        ])
        
        let backend = WordleBuddyLogic()
        backend.letters = [guess1.word, guess2.word, guess3.word, [nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil]]
        backend.currentRow = 3
        backend.currentCol = 0
        let possibleWords = backend.getWordleWords()
        XCTAssert(possibleWords.contains("daisy")) // wordle word of the day
    }

    func testAppendAndDeleteLetter() throws {
        let model = WordleBuddyLogic()
        for _ in 0..<model.height {
            for _ in 0..<model.width {
                XCTAssert(model.appendLetter(letter: "a"))
            }
        }
        XCTAssert(!model.appendLetter(letter: "a"))
        for _ in 0..<model.height {
            for _ in 0..<model.width {
                XCTAssert(model.deleteLetter())
            }
        }
        XCTAssert(!model.deleteLetter())
    }
    
}
