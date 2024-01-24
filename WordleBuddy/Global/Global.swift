//
//  Global.swift
//  WordleBuddy
//
//  Created by Ryan Frohman on 1/9/24.
//

import UIKit

enum Global {
    
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    static var minDim: CGFloat {
        min(screenWidth, screenHeight)
    }
    
    static var boardWidth: CGFloat {
        switch minDim {
        case 0...320:
            screenWidth - 55
        case 320...430:
            screenWidth - 50
        case 431...1000:
            350
        default:
            500
        }
    }
}
