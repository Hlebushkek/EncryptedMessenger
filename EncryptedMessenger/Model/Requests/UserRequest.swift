//
//  UserRequest.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import Foundation

struct UserRequest {
    let resource: URL
    
    init(userID: UUID) {
        let resourceString = "http://192.168.3.2:8080/api/user/\(userID)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
    
    func getChats(completion: @escaping (Result<[Chat], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("chat")
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let chats = try JSONDecoder().decode([Chat].self, from: jsonData)
                completion(.success(chats))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
}
