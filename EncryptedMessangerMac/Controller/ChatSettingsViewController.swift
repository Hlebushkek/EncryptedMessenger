//
//  ChatSettingsViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 21.08.2022.
//

import Cocoa

class ChatSettingsViewController: NSViewController {

    @IBOutlet weak var navBarView: NSView!
    
    @IBOutlet weak var chatImageView: EditableProfileImageView!
    @IBOutlet weak var chatNameLabel: NSTextField!
    @IBOutlet weak var chatUsersCountLabel: NSTextField!
    
    @IBOutlet weak var tableView: NSTableView!
    
    weak var chat: Chat?
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarView.wantsLayer = true
        navBarView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchUsers()
        
        chatImageView.delegate = self
        
        if let imgBase = chat?.imageBase64 {
            chatImageView.image = Utilities.image(from: imgBase)
        } else {
            let config = NSImage.SymbolConfiguration(pointSize: 32, weight: .regular).applying(.init(hierarchicalColor: .systemBlue))
            chatImageView.image = NSImage(systemSymbolName: "person.2.circle.fill", accessibilityDescription: "")?.withSymbolConfiguration(config)
        }
        
        chatNameLabel.stringValue = chat?.name ?? "[Undefined]"
        chatUsersCountLabel.stringValue = "x members"
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        (self.parent as? ChatTabViewController)?.transitToChat()
    }
    
    private func fetchUsers() {
        ChatRequest(chatID: chat?.id).getChatUsers { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                print("Users get successfuly")
                DispatchQueue.main.async { [weak self] in
                    self?.users = users
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ChatSettingsViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "userCell"), owner: nil) as? UserTableCellView else { return nil }
        
        cell.setupCell(for: users[row])
        return cell
    }
}

extension ChatSettingsViewController: EditableProfileImageViewDelegate {
    func newImageDidSet(imgPath: URL) {
        print(imgPath.path)
    }
}
