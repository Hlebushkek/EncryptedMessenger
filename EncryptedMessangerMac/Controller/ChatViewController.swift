//
//  ChatViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 11.08.2022.
//

import Cocoa

class ChatViewController: NSViewController {
    
    @IBOutlet weak var tabBar: NSView!
    @IBOutlet weak var tableView: NSTableView!
    
    var user = UserDefaultsManager.user
    weak var chat: Chat? {
        didSet {
            fetchChatMessages()
        }
    }
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NSNib(nibNamed: "UserMessageTableCellView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "usermessageCell"))
        tableView.register(NSNib(nibNamed: "MessageTableCellView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "messageCell"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tabBar.wantsLayer = true
        tabBar.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        tabBar.layer?.masksToBounds = true
        tabBar.layer?.borderWidth = 1
        tabBar.layer?.borderColor = NSColor.gray.cgColor
        
        let gesture = NSClickGestureRecognizer(target: self, action: #selector(showChatSettings))
        tabBar.addGestureRecognizer(gesture)
    }
    
    private func fetchChatMessages() {
        guard let id = chat?.id else { return }
        
        ChatRequest(chatID: id).getChatMessages { result in
            switch result {
            case .failure(let error):
                let errorMessage = "There was a problem getting the Chat Messages"
                print(error)
                print(errorMessage)
            case .success(let messages):
                DispatchQueue.main.async { [weak self] in
                    self?.messages = messages.reversed()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func showChatSettings() {
        (self.parent as? ChatTabViewController)?.showSettings()
    }
    
}

extension ChatViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let isUser = user?.id == messages[row].userID
        let identifier = isUser ? "usermessageCell" : "messageCell"
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? MessageCell else { return nil }
        
        cell.setup(with: messages[row])
        
        return cell
    }
    
}
