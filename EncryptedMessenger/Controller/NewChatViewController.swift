//
//  NewChatViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 02.08.2022.
//

import UIKit

class NewChatViewController: UIViewController {

    @IBOutlet weak var chatNameTextField: UITextField!
    @IBOutlet weak var keyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func joinChatButtonWasPressed(_ sender: Any) {
        guard let chatName = chatNameTextField.text, let keyDrawedImage = keyImageView.image else {
            return
        }
        
        ChatRequest().findChat(name: chatName) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                self?.showError(title: "Can't join to chat", message: "Can't find chat")
            case .success(let findedChat):
                guard let findedChatID = findedChat.id else {
                    print("Finded Chat has no id")
                    return
                }
                
                let keyOriginImage = Utilities.image(from: findedChat.keyBase64)
                let compareRate = KeyAnalizerWrapper.compareKey(keyDrawedImage, origin: keyOriginImage)
                
                print(compareRate)
                if (compareRate > 0.75) {
                    UserRequest(userID: UserDefaultsManager.user?.id).attachChat(chatID: findedChatID) { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                            self?.showError(title: "Can't join to chat", message: "Key was correct, but error occured when trying attach chat to user")
                        case .success(_):
                            print("Successfuly attach chat to user")
                            self?.addChatToList(chat: findedChat)
                        }
                    }
                } else {
                    self?.showError(title: "Can't join to chat", message: "Incorrect Key")
                }
            }
        }
    }
    
    @IBAction func createButtonWasPressed(_ sender: Any) {
        guard let chatName = chatNameTextField.text, let keyImage = keyImageView.image,
              let keyBase64 = Utilities.base64String(from: keyImage),
              let userID = UserDefaultsManager.user?.id else {
            return
        }
        
        let chat = Chat(name: chatName, imageBase64: nil, keyBase64: keyBase64)
        ResourceRequest<Chat>(resourcePath: "chat").save(chat) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                self?.showError(title: "Chat creation error", message: "Can't create chat")
            case .success(let createdChat):
                print("Chat: \(createdChat.name) was successfuly created")
                UserRequest(userID: userID).attachChat(chatID: createdChat.id!) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        self?.showError(title: "Chat creation error", message: "Can't attach user to chat")
                    case .success(_):
                        print("Successfuly attach chat to user")
                        self?.addChatToList(chat: createdChat)
                    }
                }
            }
        }
    }
    
    private func addChatToList(chat: Chat) {
        DispatchQueue.main.async { [weak self] in
            if let viewControllers = self?.navigationController?.viewControllers,  viewControllers.count > 1 {
                (viewControllers[viewControllers.count - 2] as? ChatsViewController)?.add(chat)
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DrawKeyViewController {
            vc.delegate = self
        }
    }
    
}

extension NewChatViewController: DrawKeyViewControllerDelegate {
    func didEndDrawingKey(image: UIImage) {
        keyImageView.image = image
    }
}
