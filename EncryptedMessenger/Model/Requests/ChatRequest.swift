//
//  ChatRequest.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import Foundation

struct ChatRequest {
    let resource: URL
    
    init(chatID: UUID) {
        let resourceString = "http://192.168.3.2:8080/api/chat/\(chatID)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
    
    func findChat(name: String, completion: @escaping (Result<[Chat], ResourceRequestError>) -> Void) {
        var components = URLComponents(url: resource, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "name", value: name)]
        
        guard let url = components?.url else {
            print("Could not create url")
            return
        }
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
    
    func getChatMessages(completion: @escaping (Result<[Message], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("message")
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let messages = try JSONDecoder().decode([Message].self, from: jsonData)
                completion(.success(messages))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
}
