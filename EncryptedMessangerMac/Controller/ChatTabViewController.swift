//
//  ChatTabViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 14.08.2022.
//

import Cocoa

class ChatTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         
    }
    
    public func showSettings() {
        guard let first = self.tabViewItems.first?.viewController,
              let second = self.tabViewItems.last?.viewController else { return }
        
        self.transition(from: first, to: second, options: [.slideLeft], completionHandler: nil)
    }
    
}
