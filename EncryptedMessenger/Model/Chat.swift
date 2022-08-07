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
    var imageBase64: String?
    var keyBase64: String
    
    init(name: String, imageBase64: String?, keyBase64: String) {
        self.name = name
        self.imageBase64 = imageBase64
        self.keyBase64 = keyBase64
    }
}
