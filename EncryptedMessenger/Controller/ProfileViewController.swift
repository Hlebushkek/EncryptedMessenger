//
//  ProfileViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 02.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func logoutButtonWasPressed(_ sender: Any) {
        print("User = nil")
        UserDefaultsManager.user = nil
    }
}
