//
//  Colors.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/15/24.
//

import SwiftUI
import UIKit

extension Color {
    static var wrong: Color {
        Color(UIColor(named: "wrong")!)
    }
    static var right: Color {
        Color(UIColor(named: "right")!)
    }
    static var misplaced: Color {
        Color(UIColor(named: "")!)
    }
    static var unused: Color {
        Color(UIColor(named: "wrong")!)
    }
    static var systemBackground: Color {
        Color(.systemBackground)
    }
}

extension Shape {
    func style<StrokeStyle: ShapeStyle, FillStyle: ShapeStyle>(
        withStroke strokeContent: StrokeStyle,
        lineWidth: CGFloat = 1,
        fill fillContent: FillStyle
    ) -> some View {
        stroke(strokeContent, lineWidth: lineWidth)
            .background(fill(fillContent))
    }
}
