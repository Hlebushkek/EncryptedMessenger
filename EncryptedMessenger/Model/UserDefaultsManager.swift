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
}

enum UserDefaultsKeys: String {
    case User = "CurrentUser"
}
