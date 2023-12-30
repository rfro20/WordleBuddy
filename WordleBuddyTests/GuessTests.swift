//
//  GuessTests.swift
//  WordleBuddyTests
//
//  Created by Ryan Frohman on 12/27/23.
//

import XCTest
@testable import WordleBuddy

final class GuessTests: XCTestCase {
    let grayLetters: [Letter] = [
        Letter(letter: "a", color: .Gray),
        Letter(letter: "b", color: .Gray),
        Letter(letter: "c", color: .Gray),
        Letter(letter: "d", color: .Gray),
        Letter(letter: "e", color: .Gray)
    ]
    
    let yellowLetters: [Letter] = [
        Letter(letter: "a", color: .Yellow),
        Letter(letter: "b", color: .Yellow),
        Letter(letter: "c", color: .Yellow),
        Letter(letter: "d", color: .Yellow),
        Letter(letter: "e", color: .Yellow)
    ]
    
    let greenLetters: [Letter] = [
        Letter(letter: "a", color: .Green),
        Letter(letter: "b", color: .Green),
        Letter(letter: "c", color: .Green),
        Letter(letter: "d", color: .Green),
        Letter(letter: "e", color: .Green)
    ]
    
    func testGray() throws {
        let guess = Guess(word: grayLetters)
        XCTAssert(guess.regexes.count == 2)
    }
    
    func testGreen() throws {
        let guess = Guess(word: greenLetters)
        XCTAssert(guess.regexes.count == 1)
    }
    
    func testYellow() throws {
        let guess = Guess(word: yellowLetters)
        XCTAssert(guess.regexes.count == 6)
    }
    
    func testMix() throws {
        let mixture: [Letter] = [
            grayLetters[0],
            greenLetters[1],
            yellowLetters[2],
            yellowLetters[3],
            grayLetters[4]
        ]
        let guess = Guess(word: mixture)
        XCTAssert(guess.regexes.count == 4)
    }
}
