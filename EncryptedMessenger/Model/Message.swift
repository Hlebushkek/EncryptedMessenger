//
//  Message.swift.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

class Message: Codable {
    var id: UUID?
    var content: String
    var userID: UUID?
    var chatID: UUID?
    
    init(content: String, userID: UUID? = nil, chatID: UUID? = nil) {
        self.content = content
        self.userID = userID
        self.chatID = chatID
    }
}
