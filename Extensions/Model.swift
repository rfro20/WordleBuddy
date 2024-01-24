//
//  Model.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/18/24.
//

import Foundation

extension [Letter?] {
    func getWord() -> String {
        var ans: [String] = []
        for ch in self {
            ans.append(ch?.letter ?? "")
        }
        
        return ans.joined()
    }
}
