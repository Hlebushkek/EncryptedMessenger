//
//  ChatTabBarController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import UIKit

class ChatTabBarController: UITabBarController {
    
    private lazy var textField: MessageTextField = {
        let textField = MessageTextField()
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor.systemBackground
        textField.placeholder = "Message"
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let sendButton = UIButton(configuration: .filled())
        sendButton.tintColor = .systemBlue
        sendButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessageButtonWasPressed), for: .touchUpInside)
        sendButton.layer.cornerRadius = 10
        sendButton.backgroundColor = UIColor.systemBackground
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    private var ChatVC: ChatViewController? {
        get {
            return self.viewControllers?.first as? ChatViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tabBar.frame.origin = CGPoint(x: 0, y: keyboardSize.height)
            (tabBar as? ChatTabBar)?.tabBarState = .Typing(keyboardSize.height)
            self.view.layoutSubviews()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        (tabBar as? ChatTabBar)?.tabBarState = .Default
        self.view.layoutSubviews()
    }
    
    @objc private func sendMessageButtonWasPressed() {
        guard let chatVC = ChatVC, let messageContent = textField.text, messageContent != "" else { return }
        
        textField.text = ""
        
        let message = Message(content: messageContent, userID: chatVC.user?.id, chatID: chatVC.chat?.id)
        ResourceRequest<Message>(resourcePath: "message").save(message) { result in
            switch result {
            case .failure(let error):
                print(error)
                let errorMessage = "There was a problem saving the message"
                print(errorMessage)
            case .success(let message):
                print("Message: \(message.content) was successfuly created")
                DispatchQueue.main.async { [weak self] in
                    self?.ChatVC?.messageDidSend(message)
                }
            }
        }
    }
    
    func makeUI() {
        tabBar.addSubview(sendButton)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: sendButton, attribute: .top, relatedBy: .equal, toItem: tabBar, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: sendButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: sendButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -8)
        ])
        
        tabBar.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: tabBar, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 32),
            NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: sendButton, attribute: .leading, multiplier: 1, constant: -16)
        ])
        
        sendButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
}

extension ChatTabBarController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.sendButton.transform = CGAffineTransform.identity
            self.sendButton.alpha = 1
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.sendButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.sendButton.alpha = 0
        }, completion: nil)
    }
}
