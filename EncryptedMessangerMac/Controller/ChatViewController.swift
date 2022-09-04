//
//  ChatViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 11.08.2022.
//

import Cocoa

class ChatViewController: NSViewController, AbstractViewController {
    
    @IBOutlet weak var navBarView: NSView!
    @IBOutlet weak var chatImageView: ProfileImageView!
    @IBOutlet weak var chatNameLabel: NSTextField!
    @IBOutlet weak var chatMembersCount: NSTextField!
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var tabBarView: NSView!
    @IBOutlet weak var messageTextField: MessageInputTextField!
    @IBOutlet weak var sendMessageButton: NSButton!
    
    var theme: Theme = UserDefaultsManager.theme
    
    var user = UserDefaultsManager.user
    weak var chat: Chat? {
        didSet {
            fetchChatMessages()
            updateNavBar()
        }
    }
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        MessagesWebSocket.shared.addListener(self)
    }
    override func viewDidDisappear() {
        super.viewDidDisappear()
        MessagesWebSocket.shared.removeListener(self)
    }
    
    func setupUI() {
        setupNavBarView()
        setupTableView()
        setupTabBarView()
        
        applyTheme()
    }
    
    private func setupNavBarView() {
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
        menu.addItem(NSMenuItem(title: "Translate", action: #selector(translate), keyEquivalent: ""))
        tableView.menu = menu
    }
    
    private func setupTabBarView() {
        messageTextField.messageInputDelegate = self
        sendMessageButton.alphaValue = 0
    }
    
    private func updateNavBar() {
        guard let chat = chat else { return }
        
        if let imgStr = chat.imageBase64 {
            chatImageView.image = Utilities.image(from: imgStr)
        }
        
        chatNameLabel.stringValue = chat.name
        chatMembersCount.stringValue = "x members"
    }
    
    func applyTheme() {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = theme.backgroundColor.cgColor
        
        self.navBarView.wantsLayer = true
        self.navBarView.layer?.backgroundColor = theme.secondaryBackgroundColor.cgColor
        
        self.tabBarView.wantsLayer = true
        self.tabBarView.layer?.backgroundColor = theme.secondaryBackgroundColor.cgColor
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
                    self?.messages = messages
                    self?.tableView.reloadData()
                    self?.tableView.scrollRowToVisible(self!.tableView.numberOfRows)
                }
            }
        }
    }
    
    @IBAction func sendMessageButtonWasPressed(_ sender: Any) {
        guard !messageTextField.stringValue.isEmpty else { return }
        
        let message = Message(content: messageTextField.stringValue, userID: user?.id, chatID: chat?.id)
        ResourceRequest<Message>(resourcePath: "message").save(message) { result in
            switch result {
            case .failure(let error):
                print(error)
                let errorMessage = "There was a problem saving the message"
                print(errorMessage)
            case .success(let message):
                print("Message: \(message.content) was successfuly created")
                DispatchQueue.main.async { [weak self] in
                    self?.add(message)
                }
            }
        }
        
        messageTextField.stringValue = ""
    }
}

extension ChatViewController {
    @objc private func showChatSettings() {
        (self.parent as? ChatTabViewController)?.transitToSettings()
    }
    
    @objc private func edit() {
        
    }
    
    @objc private func delete() {
        let row = tableView.clickedRow
        guard row > 0 else { return }
        
        if messages[row].userID == user?.id {
            MessageRequest(messageID: messages[row].id).delete {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.removeRows(at: [row], withAnimation: .slideLeft)
                    self?.messages.remove(at: row)
                }
            }
        } else {
            print("This is not your message, you can't delete it")
        }
    }
    
    @objc private func translate() {
        let row = tableView.clickedRow
        guard row >= 0 else { return }
        
        if !messages[row].content.isEmpty {
            showTranslation(for: messages[row])
        }
    }
    
    private func showTranslation(for message: Message) {
        guard let translationVC = NSStoryboard.main?.instantiateController(withIdentifier: "translationVC") as? MessageTranslationViewController else { return }
        translationVC.translate(message: message)
        presentAsSheet(translationVC)
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
        cell.apply(theme)
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
    }
    
    func add(_ message: Message) {
        messages.append(message)
        tableView.insertRows(at: [messages.count-1], withAnimation: .slideUp)
        tableView.scroll(CGPoint(x: 0, y: tableView.frame.height))
    }
}

extension ChatViewController: MessagesWebSocketListener {
    func didRecievedMessage(_ message: Message) {
        if message.chatID == chat?.id && message.userID != user?.id {
            DispatchQueue.main.async { [weak self] in
                self?.add(message)
            }
        }
    }
}

extension ChatViewController: MessageInputTextFieldDelegate {
    func userDidStartTyping() {
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            sendMessageButton.animator().alphaValue = 1
        })
    }
    
    func userDidEndTyping() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            sendMessageButton.animator().alphaValue = 0
        })
    }
    
    func userDidTrySendMessage() {
        sendMessageButtonWasPressed(self)
    }
}
