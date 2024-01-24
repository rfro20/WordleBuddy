//
//  KeyboardView.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/15/24.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    let gameFlow: WordleBuddyFlow
    
    let row1 = "qwertyuiop".map{String($0)}
    let row2 = "asdfghjkl".map{String($0)}
    let row3 = "zxcvbnm".map{String($0)}
    let buttonSpacing = 3.0
    var body: some View {
        VStack {
            HStack(spacing: buttonSpacing) {
                ForEach(row1, id:\.self) { letter in
                    KeyboardButtonView(letter: letter, gameFlow: gameFlow)
                        .environmentObject(model)
                }
            }
            HStack(spacing: buttonSpacing) {
                ForEach(row2, id:\.self) { letter in
                    KeyboardButtonView(letter: letter, gameFlow: gameFlow)
                        .environmentObject(model)
                }
            }
            HStack(spacing: buttonSpacing) {
                ForEach(row3, id:\.self) { letter in
                    KeyboardButtonView(letter: letter, gameFlow: gameFlow)
                        .environmentObject(model)

                }
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if gameFlow == .WordleGen {
                        model.deleteLetter()
                    } else {
                        model.deleteFilterLetter()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                        Image(systemName: "delete.left")
                            .foregroundColor(.primary)
                            .font(.system(size: 26))
                    }.frame(width: 50, height: 50)

                }
            }
        }
    }
}

struct KeyboardButtonView: View {
    @EnvironmentObject var model: WordleBuddyLogic
    
    let letter: String
    let gameFlow: WordleBuddyFlow
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            if gameFlow == .WordleGen {
                model.appendLetter(letter: self.letter)
            } else {
                model.appendFilterLetter(letter: self.letter)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
                Text(letter.uppercased())
                    .font(.system(size: 30, weight: .medium, design: .monospaced))
                    .foregroundColor(.primary)
            }.frame(width: 35, height: 50)
            
        }
        .buttonStyle(.plain)
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

#Preview {
    KeyboardView(gameFlow: .WordleGen)
        .environmentObject(WordleBuddyLogic())
}
