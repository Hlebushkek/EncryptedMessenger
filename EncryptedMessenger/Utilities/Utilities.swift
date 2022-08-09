//
//  Utilities.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

class Utilities {
    static func base64String(from image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    
    static func image(from base64Str: String) -> UIImage? {
        let imageData = Data(base64Encoded: base64Str)
        
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    static var API_URL_STR: String {
        return try! Config.value(for: "API_URL")
    }
}
