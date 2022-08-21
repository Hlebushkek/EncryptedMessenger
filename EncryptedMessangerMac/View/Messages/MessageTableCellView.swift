//
//  MessageTableCellView.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 20.08.2022.
//

import Cocoa

class MessageTableCellView: NSTableCellView, MessageCell {
    
    @IBOutlet weak var userImageView: NSImageView!
    
    @IBOutlet weak var messageContentView: GradientView!
    @IBOutlet weak var messageLabel: NSTextField!
    
    private weak var message: Message?
    
    func setup(with message: Message) {
        self.message = message

        userImageView.image = NSImage(systemSymbolName: "person.fill", accessibilityDescription: nil)
        userImageView.layer?.cornerRadius = userImageView.bounds.width / 2

        messageLabel.stringValue = message.content
        
        setupContetnView()
    }
    
    private func setupContetnView() {
        messageContentView.colors = [NSColor.systemGray, NSColor.systemGray]
        messageContentView.startPoint = CGPoint(x: 1, y: 1)
        messageContentView.endPoint = CGPoint(x: 0, y: 0)
        messageContentView.layer?.cornerRadius = 8
    }
    
}
