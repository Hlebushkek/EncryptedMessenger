//
//  Utilities.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

class Utilities {
    static func convertImageToBase64String (img: UIImage) -> String? {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    
    static func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
}
