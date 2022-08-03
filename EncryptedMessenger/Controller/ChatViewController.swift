//
//  ChatViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 03.08.2022.
//

import UIKit

class ChatViewController: UIViewController {
    
    var chat: Chat?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    public func set(_ chat: Chat) {
        self.chat = chat
    }
    
}
