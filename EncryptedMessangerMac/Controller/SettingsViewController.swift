//
//  SettingsViewController.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 26.08.2022.
//

import Cocoa

class SettingsViewController: NSViewController {

    @IBOutlet weak var userImageView: EditableProfileImageView!
    
    @IBOutlet weak var userNameLabel: NSTextField!
    @IBOutlet weak var userTagLabel: NSTextField!
    
    private var user = UserDefaultsManager.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.delegate = self
        updateProfile()
    }
    
    private func updateProfile() {
        guard let user = user else { return }

        if let imgStr = user.imageBase64 {
            userImageView.image = Utilities.image(from: imgStr)
        }
        
        userNameLabel.stringValue = user.name
        userTagLabel.stringValue = user.email
    }
    
}

extension SettingsViewController: EditableProfileImageViewDelegate {
    func newImageDidSet(sender: EditableProfileImageView, imgPath: URL) {
        print("IMG did change")
        if sender === userImageView, let user = user, let newImg = NSImage(contentsOf: imgPath) {
            let updatedUser = User(name: user.name, imageBase64: Utilities.base64String(from: newImg), email: user.email, password: user.password)
            
            UserRequest(userID: user.id).update(with: updatedUser, completion: { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let fetchedUser):
                    print("Success")
                    DispatchQueue.main.async {
                        UserDefaultsManager.user = fetchedUser
                    }
                }
            })
        }
    }
}
