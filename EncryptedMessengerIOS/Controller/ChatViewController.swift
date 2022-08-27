//
//  ChatViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var user = UserDefaultsManager.user
    weak var chat: Chat?
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchChatMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideKeyboardWhenTappedAround()
        makeNavBarUI()
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        tableView.register(UINib(nibName: "UserMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "usermessageCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width - 10)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        //Task: Find out why content needs inset
        
        //tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MessagesWebSocket.shared.addListener(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    func messageDidSend(_ message: Message) {
        add(message)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show")
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableViewBottomConstraint.constant = keyboardSize.height - 32
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide")
        tableViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc override func dismissKeyboard() {
        self.tabBarController?.tabBar.endEditing(true)
    }
    
    private func makeNavBarUI() {
        let label = UILabel()
        label.text = chat?.name
        label.isUserInteractionEnabled = true
        self.tabBarController?.navigationItem.titleView = label
        let tap = UITapGestureRecognizer(target: self, action: #selector(showChatSettings))
        self.tabBarController?.navigationItem.titleView?.addGestureRecognizer(tap)
    }
    
    @objc func showChatSettings() {
        self.performSegue(withIdentifier: "chatSettingsSegue", sender: self)
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isUser = user?.id == messages[indexPath.row].userID
        let identifier = isUser ? "usermessageCell" : "messageCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return UITableViewCell() }
        
        cell.setup(with: messages[indexPath.row])
        cell.transform = CGAffineTransform(rotationAngle: (-.pi))
        return cell
    }
    
    func add(_ message: Message) {
        messages.insert(message, at: 0)
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        }, completion: nil)
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

extension ChatViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChatSettingsViewController {
            vc.chat = chat
        }
    }
}
