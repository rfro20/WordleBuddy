import RegexBuilder
import Foundation

func multipleLetterRegexFlow2(letters: [Letter]) -> [Regex<Substring>] {
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

func multipleLetterRegexFlow(letters: [Letter], inWord: Bool) -> [Regex<Substring>] {
    if letters.count == 0 {
        return []
    }
    
    let one = letters[0]
    let remainder = Array(letters.suffix(from: 1))
    switch one.color {
    case .Green:
        return [inPos(ch: one.letter, loc: one.loc)] + multipleLetterRegexFlow(letters: remainder, inWord: true)
    case .Yellow:
        return [mustHave(ch: one.letter), cantBeInPos(ch: one.letter, loc: one.loc)] + multipleLetterRegexFlow(letters: remainder, inWord: true)
    case .Gray:
        if inWord {
            // If the first letter in sorted order is gray, then they're all gray..
            var ans: [Regex<Substring>] = []
            for letter in letters {
                ans.append(cantBeInPos(ch: letter.letter, loc: letter.loc))
            }
            return ans
        } else {
            return [notInWord(ch: one.letter)]
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


// Regex Stuff
func mustHave(ch: String) -> Regex<Substring> {
    return Regex {
        ZeroOrMore {
            .any
        }
        ch
        ZeroOrMore {
            .any
        }
    }
}

func mustHaveTwo(ch: String) -> Regex<Substring> {
    return Regex {
        ZeroOrMore {
            .any
        }
        ch
        ZeroOrMore {
            .any
        }
        ch
        ZeroOrMore {
            .any
        }
    }
}

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

struct RegexTest {
    let str: String
    let matches: Bool
}

let testRegex = mustHaveCount(ch: "a", count: 5)
let scenarios : [RegexTest] = [
    RegexTest(str: "aaaaa", matches: true),
    RegexTest(str: "abcde", matches: false),
    RegexTest(str: "aabbaaa", matches: true),
    RegexTest(str: "abababb", matches: false),
    RegexTest(str: "aaabcdefghijklmnopqrstuvwxyzaa", matches: true),
]

for scenario in scenarios {
    if let _ = try? testRegex.wholeMatch(in: scenario.str) {
        print("matches if match: ", scenario.matches)
    } else {
        print("matches if doesn't match: ", scenario.matches)
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
