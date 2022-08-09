//
//  MessagesWebSocket.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 07.08.2022.
//

import Foundation

class MessagesWebSocket {
    
    private init() {}
    public static var shared = MessagesWebSocket()
    
    private var listeners: [MessagesWebSocketListener] = []
    public func addListener(_ newListener: MessagesWebSocketListener) {
        if listeners.contains(where: { $0 === newListener }) { return }
        listeners.append(newListener)
    }
    public func removeListener(_ listener: MessagesWebSocketListener) {
        if let index = listeners.firstIndex(where: { $0 === listener }) {
            listeners.remove(at: index)
        }
    }
    
    private var webSocketTask: URLSessionWebSocketTask!
    private var recieveTimer: Timer!
    
    func setupWebSocket() {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://\(Utilities.API_URL_STR)/echo")!)
        webSocketTask.resume()
        
        guard let user = try? JSONEncoder().encode(UserDefaultsManager.user) else {
            print("Could not encode User")
            return
        }
        let userData = URLSessionWebSocketTask.Message.data(user)
        webSocketTask.send(userData) { error in
            if let error = error {
                print("Websocket couldn't send message. \(error.localizedDescription)")
            }
        }
        
        recieveTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(recieveMessage), userInfo: nil, repeats: true)
    }
    
    @objc func recieveMessage() {
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                print("Can't recieve message. \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .data(let data):
                    print(data.description)
                    do {
                        let message = try JSONDecoder().decode(Message.self, from: data)
                        for listener in self.listeners {
                            listener.didRecievedMessage(message)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case .string(let str):
                    print(str)
                default:
                    print("Undefined Message Type")
                    return
                }
            }
        }
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
}

protocol MessagesWebSocketListener: AnyObject {
    func didRecievedMessage(_ message: Message)
}
