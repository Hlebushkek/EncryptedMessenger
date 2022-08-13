//
//  MessagesViewController.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 11.08.2022.
//

import Cocoa

class MessagesViewController: NSViewController {
    
    var secondVC: NSViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        secondVC = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "secondVC") as? NSViewController
    }
    
    
    @IBAction func buttonWasPressed(_ sender: Any) {
        transition(from: self, to: secondVC!, options: [.slideLeft], completionHandler: {
            print("done")
        })
    }
    
}
