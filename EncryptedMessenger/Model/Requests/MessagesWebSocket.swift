//
//  MessagesWebSocket.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 07.08.2022.
//

import Foundation

class MessagesWebSocket {
    
    private init() {}
    static var shared = MessagesWebSocket()
    
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
    
    var webSocketTask: URLSessionWebSocketTask!
    var recieveTimer: Timer!
    
    func setupWebSocket() {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://192.168.3.2:8080/echo")!)
        webSocketTask.resume()
        
        guard let user = try? JSONEncoder().encode(UserDefaultsManager.user) else { return }
        let userData = URLSessionWebSocketTask.Message.data(user)
        
//        let message = URLSessionWebSocketTask.Message.string(
//        """
//            { "user": "user123"}
//        """)
        webSocketTask.send(userData) { error in
            if let error = error {
                print("Websocket couldn't send message. \(error.localizedDescription)")
            }
        }
        recieveTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(recieveMessage), userInfo: nil, repeats: true)
    }
    
    @objc func recieveMessage() {
        print("recieveMessage")
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                print("Can't recieve message. \(error.localizedDescription)")
            case .success(let message):
                print("Message: \(message)")
                switch message {
                case .data(let data):
                    print(data.description)
                    if let message = try? JSONDecoder().decode(Message.self, from: data) {
                        for listener in self.listeners {
                            listener.didRecievedMessage(message)
                        }
                    }
                case .string(let str):
                    print(str)
                default:
                    print("Undefined Message")
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
