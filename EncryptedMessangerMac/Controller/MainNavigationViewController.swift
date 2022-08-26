//
//  MainNavigationViewController.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 26.08.2022.
//

import Cocoa

class MainNavigationViewController: NSViewController {

    @IBOutlet weak var navigationBar: NSStackView!
    
    let profileVC: ProfileViewController? = NSStoryboard.main?.instantiateController(identifier: "profileVC")
    let chatsVC: ChatsViewController? = NSStoryboard.main?.instantiateController(identifier: "chatsVC")
    let settingsVC: SettingsViewController? = NSStoryboard.main?.instantiateController(identifier: "settingsVC")
    
    private var presentedChildViewController: NSViewController!
    
    private var user = UserDefaultsManager.user

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.wantsLayer = true
        navigationBar.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        if let profileVC = profileVC {
            addChild(profileVC)
        }
        if let chatsVC = chatsVC {
            addChild(chatsVC)
        }
        if let settingsVC = settingsVC {
            addChild(settingsVC)
        }
        
        present(with: user!)
    }
    
    func present(with user: User) {
        if let profileVC = profileVC {
            view.addSubview(profileVC.view)
            profileVC.view.autoresizingMask = [.width, .height]
            profileVC.view.frame = self.view.bounds
            presentedChildViewController = profileVC
        }
    }
    
    @IBAction func presentProfile(_ sender: Any) {
        guard let profileVC = profileVC else { return }

        profileVC.view.autoresizingMask = [.width, .height]
        profileVC.view.frame = self.view.bounds
        
        self.transition(from: presentedChildViewController, to: profileVC, options: [], completionHandler: { [weak self] in
            self?.presentedChildViewController = profileVC
        })
    }
    
    @IBAction func presentChatsList(_ sender: Any) {
        guard let chatsVC = chatsVC else { return }

        chatsVC.view.autoresizingMask = [.width, .height]
        chatsVC.view.frame = self.view.bounds
        
        self.transition(from: presentedChildViewController, to: chatsVC, options: [], completionHandler: { [weak self] in
            self?.presentedChildViewController = chatsVC
        })
    }
    
    @IBAction func presentSettings(_ sender: Any) {
        guard let settingsVC = settingsVC else { return }

        settingsVC.view.autoresizingMask = [.width, .height]
        settingsVC.view.frame = self.view.bounds
        
        self.transition(from: presentedChildViewController, to: settingsVC, options: [], completionHandler: { [weak self] in
            self?.presentedChildViewController = settingsVC
        })
    }
    
}
