//
//  ChatsViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 17.04.2022.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
        guard let user = UserDefaultsManager.user else { return }
        
        UserRequest(userID: user.id).getChats(completion: { result in
            switch result {
            case .failure(let error):
                let message = "There was an error getting the user chats"
                print(message)
                print(error)
            case .success(let chats):
                DispatchQueue.main.async { [weak self] in
                    self?.chats = chats
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

extension ChatsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatTabBarController = segue.destination as? ChatTabBarController,
           let chatVC = chatTabBarController.viewControllers?.first as? ChatViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            chatVC.chat = chats[index]
        }
    }
}
