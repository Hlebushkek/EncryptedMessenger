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
    }
    
    func apply(_ theme: Theme) {
        setupGradient(with: theme.messageColors)
    }
    
    func setupGradient(with colors: [Color]?) {
        
        messageContentView.colors = colors
        messageContentView.startPoint = CGPoint(x: 1, y: 1)
        messageContentView.endPoint = CGPoint(x: 0, y: 0)
        messageContentView.layer?.cornerRadius = 8
        
        if colors == nil {
            let view = NSView()
            view.frame = messageContentView.bounds
            view.wantsLayer = true
            view.layer?.cornerRadius = 8
            
            var backgroundFilters = [CIFilter]()
            if let blurFilter = CIFilter(name: "CIGaussianBlur") {
                blurFilter.setDefaults()
                blurFilter.setValue(16, forKey: kCIInputRadiusKey)
                backgroundFilters = [blurFilter]
            }
            view.backgroundFilters = backgroundFilters
            
            self.messageContentView.colors = [Color.systemBlue, Color.systemRed]
            messageContentView.addSubview(view, positioned: .below, relativeTo: messageContentView.subviews.first!)
        }
    }
    
}
