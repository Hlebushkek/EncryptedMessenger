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
        guard let chatName = chatNameTextField.text, let keyImage = keyImageView.image,
              let keyBase64 = Utilities.convertImageToBase64String(img: keyImage) else {
            return
        }
        
        
        let compareRate = KeyAnalizerWrapper().compareKey(keyImage, origin: keyImage)
        print(compareRate)
        //print(KeyAnalizerWrapper().compareKey(getSavedImagePath(named: "DrawedImage.png")!, originPath: getSavedImagePath(named: "fileName.png")!))
        if (compareRate > 0.95) {
            print("Verification Success")
            //Add chat to user
        }
    }
    
    @IBAction func createButtonWasPressed(_ sender: Any) {
        guard let chatName = chatNameTextField.text, let keyImage = keyImageView.image,
              let keyBase64 = Utilities.convertImageToBase64String(img: keyImage) else {
            return
        }
        
        let chat = Chat(name: chatName, keyBase64: keyBase64, users: [])
        ResourceRequest<Chat>(resourcePath: "chat").save(chat) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                let message = "There was a problem saving the chat"
                print(message)
            case .success(let chat):
                print("Chat: \(chat.name) was successfuly created")
                
                let userID = "63DE2F33-86D0-4838-8111-A2783CC6E941"
                var urlRequest = URLRequest(url: URL(string: "http://192.168.3.2:8080/api/user/\(userID)/chat/\(chat.id!)")!)
                urlRequest.httpMethod = "POST"
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                        print("Error in connecting user to chat")
                        return
                    }
                    print("Successfuly connect user to chat")
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                dataTask.resume()
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
