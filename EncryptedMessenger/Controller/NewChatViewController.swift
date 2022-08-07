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
        
        ChatRequest().findChat(name: chatName) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let findedChat):
                guard let findedChatID = findedChat.id else {
                    print("Finded Chat has no id")
                    return
                }
                
                let keyOriginImage = Utilities.convertBase64StringToImage(imageBase64String: findedChat.keyBase64)
                let compareRate = KeyAnalizerWrapper().compareKey(keyDrawedImage, origin: keyOriginImage)
                
                print(compareRate)
                if (compareRate > 0.75) {
                    print("Verification Success")
                    UserRequest(userID: UserDefaultsManager.user?.id).attachChat(chatID: findedChatID) { result in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(_):
                            print("Successfuly attach chat to user")
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        //print(KeyAnalizerWrapper().compareKey(getSavedImagePath(named: "DrawedImage.png")!, originPath: getSavedImagePath(named: "fileName.png")!))
    }
    
    @IBAction func createButtonWasPressed(_ sender: Any) {
        guard let chatName = chatNameTextField.text, let keyImage = keyImageView.image,
              let keyBase64 = Utilities.convertImageToBase64String(img: keyImage),
              let userID = UserDefaultsManager.user?.id else {
            return
        }
        
        let chat = Chat(name: chatName, imageBase64: nil, keyBase64: keyBase64)
        ResourceRequest<Chat>(resourcePath: "chat").save(chat) { result in
            switch result {
            case .failure(let error):
                print(error)
                let message = "There was a problem saving the chat"
                print(message)
            case .success(let chat):
                print("Chat: \(chat.name) was successfuly created")
                UserRequest(userID: userID).attachChat(chatID: chat.id!) { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(_):
                        print("Successfuly attach chat to user")
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
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
