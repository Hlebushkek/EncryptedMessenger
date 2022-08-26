//
//  ChatTabViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 14.08.2022.
//

import Cocoa

class ChatTabViewController: NSViewController {
    
    let chatVC: ChatViewController? = NSStoryboard.main?.instantiateController(identifier: "chatVC")
    let chatSettingsVC: ChatSettingsViewController? = NSStoryboard.main?.instantiateController(identifier: "chatSettingsVC")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let chatVC = chatVC {
            addChild(chatVC)
        }
        if let chatSettingsVC = chatSettingsVC {
            addChild(chatSettingsVC)
        }
    }
    
    public func present(with chat: Chat?) {
        if let chatVC = chatVC {
            view.addSubview(chatVC.view)
            chatVC.chat = chat
            chatVC.view.autoresizingMask = [.width, .height]
            chatVC.view.frame = self.view.bounds
            
            //  chatVC.view.translatesAutoresizingMaskIntoConstraints = false
            //        NSLayoutConstraint.activate([
            //            chatVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            //            chatVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //            chatVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //            chatVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            //        ])
        }
        
        if let chatSettingsVC = chatSettingsVC {
            chatSettingsVC.chat = chat
        }
    }
    
    func transitToSettings() {
        guard let chatVC = chatVC,
              let chatSettingsVC = chatSettingsVC else { return }

        chatSettingsVC.view.autoresizingMask = [.width, .height]
        chatSettingsVC.view.frame = self.view.bounds
        
        self.transition(from: chatVC, to: chatSettingsVC, options: [.slideLeft], completionHandler: nil)
    }
    
    func transitToChat() {
        guard let chatVC = chatVC,
              let chatSettingsVC = chatSettingsVC else { return }

        chatVC.view.autoresizingMask = [.width, .height]
        chatVC.view.frame = self.view.bounds
        
        self.transition(from: chatSettingsVC, to: chatVC, options: [.slideRight], completionHandler: nil)
    }
    
}
