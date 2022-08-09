//
//  ChatRequest.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import Foundation

struct ChatRequest {
    let resource: URL
    
    init(chatID: UUID? = nil) {
        
        var resourceString = "https://\(Utilities.API_URL_STR)/api/chat"
        if let chatID = chatID {
            resourceString.append("/\(chatID)")
        }
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
    
    func findChat(name: String, completion: @escaping (Result<Chat, ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
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
                let chats = try JSONDecoder().decode(Chat.self, from: jsonData)
                completion(.success(chats))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
    
    func getChatUsers(completion: @escaping (Result<[User], ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("user")
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                print("NO DATA")
                completion(.failure(.noData))
                return
            }
            
            do {
                
                let users = try JSONDecoder().decode([User].self, from: jsonData)
                completion(.success(users))
            } catch {
                print(error.localizedDescription)
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
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let messages = try decoder.decode([Message].self, from: jsonData)
                completion(.success(messages))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
}
