//
//  Utilities.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    typealias Image = UIImage
#elseif os(macOS)
    import AppKit
    typealias Image = NSImage
#endif

class Utilities {
    static func base64String(from image: Image) -> String? {
#if os(iOS) || os(watchOS) || os(tvOS)
        return image.jpegData(compressionQuality: 1)?.base64EncodedString()
#elseif os(macOS)
        return image.tiffRepresentation?.base64EncodedString()
#endif
    }
    static func image(from base64Str: String) -> Image? {
        let imageData = Data(base64Encoded: base64Str)
        
        if let imageData = imageData {
            return Image(data: imageData)
        }
        return nil
    }
    
    
    
    static var API_URL_STR: String {
        return try! Config.value(for: "API_URL")
    }
    static var TRANSLATION_API_URL: String {
        return try! Config.value(for: "TRANSLATION_URL")
    }
}
