//
//  MainSplitViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 20.08.2022.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func updateChat(chat: Chat?) {
        guard let chatVC = (self.splitViewItems[1].viewController as? ChatTabViewController)?.tabViewItems.first?.viewController as? ChatViewController else { return }
        chatVC.chat = chat
    }
    
}
