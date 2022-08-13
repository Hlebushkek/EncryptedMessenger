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
        chatImage.layer?.cornerRadius = chatImage.bounds.width / 2
        
        let config = NSImage.SymbolConfiguration(paletteColors: [.black, .red])
        chatImage.image = NSImage(systemSymbolName: "pencil.circle.fill", accessibilityDescription: nil)?.withSymbolConfiguration(config)
        
        chatName.stringValue = chat.name
        
        chatLastMessage.maximumNumberOfLines = 2
        chatLastMessage.stringValue = "Last chat message"
    }
    
}
