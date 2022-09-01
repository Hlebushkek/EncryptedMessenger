//
//  UserDefaultsManager.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 05.08.2022.
//

import Foundation

class UserDefaultsManager {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    static var user: User? {
        set {
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.User.rawValue)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.User.rawValue) else { return nil }
            let user = try? decoder.decode(User.self, from: data)
            return user
        }
    }
    
    static var cachedChats: [Chat] {
        set {
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.CachedChats.rawValue)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.CachedChats.rawValue) else { return [] }
            let chats = try? decoder.decode([Chat].self, from: data)
            return chats ?? []
        }
    }
    
    static var chatFolders: [ChatFolder] {
        set {
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: UserDefaultsKeys.ChatFolders.rawValue)
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.ChatFolders.rawValue) else { return [] }
            let chatFolders = try? decoder.decode([ChatFolder].self, from: data)
            return chatFolders ?? []
        }
    }
}

enum UserDefaultsKeys: String {
    case User = "CurrentUser"
    case CachedChats = "CachedChats"
    case ChatFolders = "ChatFolders"
}
