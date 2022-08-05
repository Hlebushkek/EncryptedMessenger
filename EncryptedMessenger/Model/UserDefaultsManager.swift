//
//  UserDefaultsManager.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 05.08.2022.
//

import Foundation

class UserDefaultsManager {
    static var user: User? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.User.rawValue)
        }
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.User.rawValue) as? User
        }
    }
}

enum UserDefaultsKeys: String {
    case User = "CurrentUser"
}
