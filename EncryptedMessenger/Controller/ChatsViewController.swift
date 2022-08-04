//
//  ChatsViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 17.04.2022.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//    let chats = [
//        ("pencil.circle.fill", "Chat 1", "Chat last message 1"),
//        ("pencil.circle.fill", "Chat 2", "Chat last message 2 Chat last message 2 Chat last message 2 Chat last message 2 Chat last message 2 Chat last message 2"),
//        ("pencil.circle.fill", "Chat 3", "Chat last message 3"),
//    ]
    var chats: [Chat] = [] {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateChats()
    }
    
    private func updateChats() {
        UserRequest(userID: UUID(uuidString: "63DE2F33-86D0-4838-8111-A2783CC6E941")!).getChats(completion: { result in
            switch result {
            case .failure(let error):
                let message = "There was an error getting the user chats"
                print(message)
                print(error)
            case .success(let chats):
                DispatchQueue.main.async { [weak self] in
                    self?.chats = chats
                    self?.chats.append(contentsOf: [
                        Chat(name: "Chat123", keyBase64: "", users: nil),
                        Chat(name: "Chat123", keyBase64: "", users: nil),
                        Chat(name: "Chat123", keyBase64: "", users: nil),
                        Chat(name: "Chat123", keyBase64: "", users: nil),
                        Chat(name: "Chat123", keyBase64: "", users: nil)
                    ])
                }
            }
        })
    }
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatTableViewCell else { return UITableViewCell()}
        
        cell.setupCell(chat: chats[indexPath.row])
        return cell
    }
    
}
