//
//  UserRequest.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import Foundation

struct UserRequest {
    let resource: URL
    
    init(userID: UUID? = nil) {
        
        var resourceString = "https://\(Utilities.API_URL_STR)/api/user"
        if let userID = userID {
            print(userID)
            resourceString.append("/\(userID)")
        }
        print(resourceString)
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Unable to createURL")
        }
        self.resource = resourceURL
    }
    
    func findUser(email: String, password: String, completion: @escaping (Result<User, ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("search")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "email", value: email), URLQueryItem(name: "password", value: password)]
        
        guard let url = components?.url else {
            print("Could not create url")
            return
        }
        print(url)
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                completion(.success(user))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
    
    func update(with updateData: User, completion: @escaping (Result<User, ResourceRequestError>) -> Void) {
        do {
            var urlRequest = URLRequest(url: resource)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try JSONEncoder().encode(updateData)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print(urlRequest)
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let user = try JSONDecoder().decode(User.self, from: jsonData)
                    completion(.success(user))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingError))
        }
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
    
    func attachChat(chatID: UUID, completion: @escaping (Result<HTTPURLResponse, ResourceRequestError>) -> Void) {
        let url = resource.appendingPathComponent("chat").appendingPathComponent(chatID.uuidString)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                print("Error in connecting user to chat")
                completion(.failure(.noData))
                return
            }
            print("Successfuly connect user to chat")
            completion(.success(httpResponse))
        }
        
        dataTask.resume()
    }
}
