let lettersCorrect = [".", "b", ".", ".", "t"]
let testString = "adout"
let correctLettersRegex = try Regex(lettersCorrect.joined())
if let match = try? correctLettersRegex.wholeMatch(in: testString) {
    print("match!")
} else {
    print("no match :(")
}
