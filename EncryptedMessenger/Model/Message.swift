//
//  Message.swift.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

final class Message: Codable {
    var id: UUID?
    var content: String
    var date: Date?
    var userID: UUID?
    var chatID: UUID?
    
    init(content: String, userID: UUID? = nil, chatID: UUID? = nil) {
        self.content = content
        self.userID = userID
        self.chatID = chatID
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(UUID?.self, forKey: .id)
        self.content = try values.decode(String.self, forKey: .content)
        
        self.date = try values.decode(Date.self, forKey: .date)
        
        self.userID = try values.decode([String: UUID?].self, forKey: .userID)["id"] as? UUID
        self.chatID = try values.decode([String: UUID?].self, forKey: .chatID)["id"] as? UUID
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case date
        case userID = "user"
        case chatID = "chat"
    }
}
