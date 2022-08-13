//
//  ChatsViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 17.04.2022.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTabel), for: .valueChanged)
        
        fetchChats()
    }
    
    private func fetchChats() {
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
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completion in
            print("delete")
        })
        delete.image = UIImage(systemName: "trash")
        
        let pin = UIContextualAction(style: .normal, title: "Pin", handler: { action, view, completion in
            print("pin")
        })
        pin.image = UIImage(systemName: "pin")
        pin.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [delete, pin])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let pin = UIAction(title: "Pin", image: UIImage(systemName: "pin")) { _ in
                print("Pin")
            }
            let mute = UIAction(title: "Mute", image: UIImage(systemName: "bell")) { _ in
                print("Mute")
            }
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [pin, mute])
            
            return menu
        }
        
        return config
    }
    
    @objc func refreshTabel() {
        fetchChats()
    }
    
    func add(_ chat: Chat) {
        chats.append(chat)
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(row: chats.count-1, section: 0)], with: .bottom)
        }, completion: nil)
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
