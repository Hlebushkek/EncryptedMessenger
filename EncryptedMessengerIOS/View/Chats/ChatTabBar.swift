//
//  ChatTabBar.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

import UIKit

class ChatTabBar: UITabBar {

    var tabBarState: ChatTabBarState = .Default
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let baseSize = super.sizeThatFits(size)
        
        switch tabBarState {
        case .Default:
            return baseSize
        case .Typing(let keyboardHeight):
            self.frame.origin = CGPoint(x: 0, y: keyboardHeight + 6)
            return baseSize
//            return CGSize(width: baseSize.width, height: baseSize.height - 8)
        }
    }
    
}

enum ChatTabBarState {
    case Default
    case Typing(CGFloat)
}
