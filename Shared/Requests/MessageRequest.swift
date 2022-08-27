//
//  MessageRequest.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 27.08.2022.
//

import Foundation

struct MessageRequest {
    let resource: URL
    
    init(messageID: UUID? = nil) {
        var resourceString = "https://\(Utilities.API_URL_STR)/api/message"
        if let messageID = messageID {
            resourceString.append("/\(messageID)")
        }
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
    
    func delete(completion: @escaping () -> Void) {
        var urlRequest = URLRequest(url: resource)
        urlRequest.httpMethod = "DELETE"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { _, _, _ in
            completion()
        })
        dataTask.resume()
        
    }
}
