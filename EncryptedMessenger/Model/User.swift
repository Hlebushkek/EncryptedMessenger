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
    var imageBase64: String?
    var email: String
    var password: String
    var phoneNumber: String?
    
    init(name: String, imageBase64: String?, email: String, password: String,phoneNumber: String? = nil) {
        self.name = name
        self.imageBase64 = imageBase64
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
    }
}
