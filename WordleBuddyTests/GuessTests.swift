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
        Letter(letter: "a", loc: 0, color: .Gray),
        Letter(letter: "b", loc: 1, color: .Gray),
        Letter(letter: "c", loc: 2, color: .Gray),
        Letter(letter: "d", loc: 3, color: .Gray),
        Letter(letter: "e", loc: 4, color: .Gray)
    ]
    
    let yellowLetters: [Letter] = [
        Letter(letter: "a", loc: 0, color: .Yellow),
        Letter(letter: "b", loc: 1, color: .Yellow),
        Letter(letter: "c", loc: 2, color: .Yellow),
        Letter(letter: "d", loc: 3, color: .Yellow),
        Letter(letter: "e", loc: 4, color: .Yellow)
    ]
    
    let greenLetters: [Letter] = [
        Letter(letter: "a", loc: 0, color: .Green),
        Letter(letter: "b", loc: 1, color: .Green),
        Letter(letter: "c", loc: 2, color: .Green),
        Letter(letter: "d", loc: 3, color: .Green),
        Letter(letter: "e", loc: 4, color: .Green)
    ]
    
    func testGray() throws {
        let guess = Guess(word: grayLetters)
        let regexes = guess.getRegex()
        XCTAssert(regexes.count == 5)
        for pattern in regexes {
            XCTAssert(((try? pattern.wholeMatch(in: "fghij")) != nil))
        }
    }
    
    func testGreen() throws {
        let guess = Guess(word: greenLetters)
        let regexes = guess.getRegex()
        XCTAssert(regexes.count == 5)
        for pattern in regexes {
            XCTAssert(((try? pattern.wholeMatch(in: "abcde")) != nil))
        }
    }
    
    func testYellow() throws {
        let guess = Guess(word: yellowLetters)
        let regexes = guess.getRegex()
        XCTAssert(regexes.count == 5)
        for pattern in regexes {
            XCTAssert(((try? pattern.wholeMatch(in: "bcdea")) != nil))
        }
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
        XCTAssert(guess.getRegex().count == 5)
    }
    
    func testMultipleLetters() throws {
        /*
         Guess:  River
         Actual: Giver
                 rGGGG
         */
        
        let guess = Guess(word: [
            Letter(letter: "r", loc: 0, color: .Gray),
            Letter(letter: "i", loc: 1, color: .Green),
            Letter(letter: "v", loc: 2, color: .Green),
            Letter(letter: "e", loc: 3, color: .Green),
            Letter(letter: "r", loc: 4, color: .Green),
        ])
        
        let regexes = guess.getRegex()
        print(regexes.count)
        XCTAssert(regexes.count == 8)
        
    }
}
