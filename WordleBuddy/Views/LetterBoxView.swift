//
//  LetterBoxView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/16/24.
//

import SwiftUI

struct LetterBoxView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    @Binding var letter: Letter?
    let row: Int
    let col: Int
    let gameFlow: WordleBuddyFlow
    
    init(letter: Binding<Letter?>, row: Int, col: Int, gameFlow: WordleBuddyFlow) {
        self._letter = letter
        self.row = row
        self.col = col
        self.gameFlow = gameFlow
    }
    
    private var boxColor: Color {
        switch letter?.color {
        case .Green:
            .green
        case .Yellow:
            .yellow
        case .Gray:
            .gray
        default:
            .primary
            .opacity(gameFlow == .WordleGen ? (row == model.currentRow && col == model.currentCol ? 0.6 : 0.2) : (col == model.currentColFilter ? 0.6 : 0.2))
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .style(withStroke: Color.black, 
                       lineWidth: row == model.currentRow && col == model.currentCol ? 3 : 1,
                       fill: boxColor)
                .aspectRatio(1, contentMode: .fit)
            if let letter = letter {
                Text(letter.letter.uppercased())
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    .onTapGesture {
                        if gameFlow == .WordleGen {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            model.changeColor(row: row, col: col)
                        }
                    }
            }
        }
    }
}

#Preview {
    return LetterBoxView(letter: .constant(nil), row: 0, col: 0, gameFlow: .WordleGen)
        .environmentObject(WordleBuddyLogic())
}
