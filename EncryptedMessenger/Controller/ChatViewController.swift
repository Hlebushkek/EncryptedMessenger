//
//  ChatViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputViewContainer: UIView!
    @IBOutlet weak var inputViewContainerHeightConstraint: NSLayoutConstraint!
    
    var chat: Chat?
    
    private var messages: [Message] = [
        Message(content: "Message123"),
        Message(content: "Message123"),
        Message(content: "Message123 Message123 Message123 Message123 Message123 Message123"),
        Message(content: "Message123"),
        Message(content: "Message123 Message123 Message123"),
        Message(content: "Message123"),
        Message(content: "Message123 Message123"),
        Message(content: "Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123 Message123"),
        Message(content: "Message123 Message123 Message123"),
        Message(content: "Message123"),
        Message(content: "Message123"),
        Message(content: "Message123 Message123 Message123 Message123 Message123 Message123 Message123")
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
        
        setupChatInfo()
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.transform = CGAffineTransform(rotationAngle: (-.pi))
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width - 10)
        tableView.contentInset = UIEdgeInsets(top: 78, left: 0, bottom: -16, right: 0)
        
        //tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
    }
    
    private func setupChatInfo() {
        self.navigationItem.title = chat?.name
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            inputViewContainerHeightConstraint.constant += keyboardSize.height - 20
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        inputViewContainerHeightConstraint.constant = 72
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageTableViewCell else { return UITableViewCell()}
        
        cell.setupCell(with: messages[indexPath.row])
        cell.transform = CGAffineTransform(rotationAngle: (-.pi))
        return cell
    }
    
}
