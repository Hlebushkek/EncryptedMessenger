//
//  User.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

class User: Codable {
    var id: UUID?
    var name: String
    var email: String
    var phoneNumber: String?
    var chats: [Chat]
    
    init(name: String, email: String, phoneNumber: String? = nil, chats: [Chat]) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.chats = chats
    }
}
