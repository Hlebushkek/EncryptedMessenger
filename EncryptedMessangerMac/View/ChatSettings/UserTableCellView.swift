//
//  UserTableCellView.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 25.08.2022.
//

import Cocoa

class UserTableCellView: NSTableCellView {
    
    @IBOutlet weak var userImageView: NSImageView!
    @IBOutlet weak var userNameLabel: NSTextField!
    @IBOutlet weak var userLastOnlineLabel: NSTextField!
    @IBOutlet weak var userChatRoleLabel: NSTextField!
    
    public func setupCell(for user: User) {
        if let str = user.imageBase64, let img = Utilities.image(from: str){
            userImageView.image = img
        } else {
            userImageView.image = NSImage(systemSymbolName: "person.circle", accessibilityDescription: nil)
        }
        
        userNameLabel.stringValue = user.email
        userLastOnlineLabel.stringValue = "online"
        
        userChatRoleLabel.stringValue = "admin"
    }
}
