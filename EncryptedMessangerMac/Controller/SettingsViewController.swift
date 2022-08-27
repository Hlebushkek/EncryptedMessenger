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
