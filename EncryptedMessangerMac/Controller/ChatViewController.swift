//
//  ChatViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 11.08.2022.
//

import Cocoa

class ChatViewController: NSViewController {
    
    @IBOutlet weak var navBarView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tabBarView: NSView!
    
    var user = UserDefaultsManager.user
    weak var chat: Chat? {
        didSet {
            fetchChatMessages()
        }
    }
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarView()
        setupTableView()
        setupTabBarView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        MessagesWebSocket.shared.addListener(self)
    }
    override func viewDidDisappear() {
        super.viewDidDisappear()
        MessagesWebSocket.shared.removeListener(self)
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
    
    private func setupNavBarView() {
        navBarView.wantsLayer = true
        navBarView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        let gesture = NSClickGestureRecognizer(target: self, action: #selector(showChatSettings))
        navBarView.addGestureRecognizer(gesture)
    }
    
    private func setupTableView() {
        tableView.register(NSNib(nibNamed: "UserMessageTableCellView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "usermessageCell"))
        tableView.register(NSNib(nibNamed: "MessageTableCellView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "messageCell"))
        
        tableView.delegate = self
        tableView.dataSource = self
            
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Edit", action: #selector(edit), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Delete", action: #selector(delete), keyEquivalent: ""))
        tableView.menu = menu
        
        tableView.scrollRowToVisible(tableView.numberOfRows - 1)
    }
    
    private func setupTabBarView() {
        tabBarView.wantsLayer = true
        tabBarView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }
    
    @objc private func showChatSettings() {
        (self.parent as? ChatTabViewController)?.transitToSettings()
    }
    
    @objc private func edit() {
        
    }
    
    @objc private func delete() {
        
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
    
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
//        guard let tableView = notification.object as? NSTableView, let cell = tableView.view(atColumn: 0, row: tableView.selectedRow, makeIfNecessary: false) as? MessageCell else { return }
        
        
    }
}

extension ChatViewController: MessagesWebSocketListener {
    func didRecievedMessage(_ message: Message) {
//        if message.chatID == chat?.id && message.userID != user?.id {
//            DispatchQueue.main.async { [weak self] in
//                self?.add(message)
//            }
//        }
    }
}
