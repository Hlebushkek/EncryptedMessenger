//
//  ChatsViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 11.08.2022.
//

import Cocoa

class ChatsViewController: NSViewController {
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    @IBOutlet weak var tableView: NSTableView!
    
    private var splitVC: MainSplitViewController?
    var chats: [Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserRequest().findUser(email: "email1@gmail.com", password: "pass123") { result in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let user):
//                UserDefaultsManager.user = user
//            }
//        }
        splitVC = self.parent as? MainSplitViewController

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchChats()
    }
    
    private func fetchChats() {
        guard let user = UserDefaultsManager.user else { return }
        
        progressIndicator.startAnimation(self)
        chats = UserDefaultsManager.cachedChats
        
        UserRequest(userID: user.id).getChats(completion: { result in
            switch result {
            case .failure(let error):
                let message = "There was an error getting the user chats"
                print(message)
                print(error)
            case .success(let chats):
                DispatchQueue.main.async { [weak self] in
                    self?.chats = chats
                    self?.tableView.reloadData()
                    self?.progressIndicator.stopAnimation(self)
                    UserDefaultsManager.cachedChats = chats
                }
            }
        })
    }
    
}

extension ChatsViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return chats.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "chatCell"), owner: self) as? ChatTableViewCell else { return nil }
       
        cell.setupCell(with: chats[row])
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let chat = chats[tableView.selectedRow]
            splitVC?.updateChat(chat: chat)
        } //else { splitVC?.updateDetailedInfo(info: nil) }
    }
    
}
