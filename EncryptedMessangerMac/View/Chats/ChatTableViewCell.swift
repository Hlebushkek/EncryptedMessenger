//
//  ChatTableViewCell.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 11.08.2022.
//

import Cocoa

class ChatTableViewCell: NSTableCellView {
    
    @IBOutlet weak var chatImage: NSImageView!
    
    @IBOutlet weak var chatName: NSTextField!
    @IBOutlet weak var chatLastMessage: NSTextField!
    
    public func setupCell(with chat: Chat) {
        
        let config = NSImage.SymbolConfiguration(paletteColors: [.black, .red])
        chatImage.image = NSImage(systemSymbolName: "pencil.circle.fill", accessibilityDescription: nil)?.withSymbolConfiguration(config)
        chatImage.layer?.contentsGravity = .resizeAspectFill
        chatImage.layer?.cornerRadius = chatImage.bounds.width / 2
        
        chatName.stringValue = chat.name
        
        chatLastMessage.maximumNumberOfLines = 2
        chatLastMessage.stringValue = "Last chat message"
    }
    
    func apply(_ theme: Theme) {
        
    }
    
}
