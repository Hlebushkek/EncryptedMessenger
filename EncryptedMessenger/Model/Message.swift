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
    
    init(content: String) {
        self.content = content
    }
}
