//
//  UserMessageTableCellView.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 14.08.2022.
//

import Cocoa

class UserMessageTableCellView: NSTableCellView, MessageCell {
    
    @IBOutlet weak var messageContentView: GradientView!
    @IBOutlet weak var messageLabel: NSTextField!

    func setup(with message: Message) {
        messageLabel.stringValue = message.content
    }
    
    func apply(_ theme: Theme) {
        setupGradient(with: theme.userMessageColors)
    }
    
    func setupGradient(with colors: [Color]?) {
        messageContentView.colors = colors
        messageContentView.startPoint = CGPoint(x: 1, y: 1)
        messageContentView.endPoint = CGPoint(x: 0, y: 0)
        messageContentView.layer?.cornerRadius = 8
    }
    
}
