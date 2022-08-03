//
//  ResourceRequestError.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 01.08.2022.
//

import Foundation

enum ResourceRequestError: Error {
    case noData
    case decodingError
    case encodingError
}
