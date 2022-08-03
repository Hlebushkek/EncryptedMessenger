//
//  ChatRequest.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import Foundation

struct ChatRequest {
    let resource: URL
    
    init(chatID: UUID) {
        let resourceString = "http://192.168.3.2:8080/api/chat/\(chatID)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
}
