//
//  ChatFolder.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 02.09.2022.
//

import Foundation

class ChatFolder: Codable {
    var name: String = ""
    var chatIDs: [UUID] = []
}
