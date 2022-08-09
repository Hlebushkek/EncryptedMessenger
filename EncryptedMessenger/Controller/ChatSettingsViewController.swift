//
//  ChatSettingsViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 06.08.2022.
//

import UIKit

class ChatSettingsViewController: UIViewController {

    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var user = UserDefaultsManager.user
    var users: [User] = [] {
        didSet { tableView.reloadData() }
    }
    weak var chat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUsers()
    }
    
    private func getUsers() {
        ChatRequest(chatID: chat?.id).getChatUsers { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                print("Users get successfuly")
                DispatchQueue.main.async {
                    self.users = users
                }
            }
        }
    }

}

extension ChatSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "userCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserTableViewCell else { return UITableViewCell() }
        
        cell.setupCell(for: users[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if users[indexPath.row].id == user?.id { return nil }
        
        return indexPath
    }
    
}
