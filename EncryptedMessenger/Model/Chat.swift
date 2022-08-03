//
//  Chat.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

class Chat: Codable {
    var id: UUID?
    var name: String
    var keyBase64: String
    var users: [User]?
    
    init(name: String, keyBase64: String, users: [User]?) {
        self.name = name
        self.keyBase64 = keyBase64
        self.users = users
    }
}
