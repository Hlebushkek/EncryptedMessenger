//
//  TranslateRequest.swift
//  EncryptedMessengerIOS
//
//  Created by Hlib Sobolevskyi on 31.08.2022.
//

import Foundation

struct TranslationRequest {
    let baseURLStr = "https://\(Utilities.TRANSLATION_API_URL)"
    let key = "YOUR_API_KEY_HERE"
    
    func translate(from: TranslateLanguage, to: TranslateLanguage, text: String, completion: @escaping (Result<TranslationResponse, ResourceRequestError>) -> Void) {
        guard let requestURL = URL(string: baseURLStr + "?key=\(key)") else { return }
        
        let requestBody = TranslationRequestBody(q: text, source: from, target: to, format: "text")
        
        do {
            var urlRequest = URLRequest(url: requestURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(requestBody)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
                guard let jsonData = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let resources = try decoder.decode(TranslationResponse.self, from: jsonData)
                    completion(.success(resources))
                } catch {
                    print(error)
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            print(error.localizedDescription)
            completion(.failure(.encodingError))
        }
    }
}

struct TranslationRequestBody: Codable {
    let q: String
    let source: TranslateLanguage
    let target: TranslateLanguage
    let format: String
}

struct TranslationResponse: Codable {
    let data: Translations
}

struct Translations: Codable {
    let translations: [TranslatedText]
}

struct TranslatedText: Codable {
    let translatedText: String
}

enum TranslateLanguage: String, Codable {
    case EN = "en"
    case UA = "ua"
    case DE = "de"
    case FR = "fr"
    case IT = "it"
    case RU = "ru"
}
