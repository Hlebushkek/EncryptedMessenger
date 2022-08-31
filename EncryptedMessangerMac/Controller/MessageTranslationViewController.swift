//
//  MessageTranslationViewController.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 31.08.2022.
//

import Cocoa

class MessageTranslationViewController: NSViewController {
    
    @IBOutlet weak var originalLabel: NSTextField!
    @IBOutlet weak var translatedLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func translate(message: Message) {
        DispatchQueue.main.async { [weak self] in
            self?.originalLabel.stringValue = message.content
        }
        
        TranslationRequest().translate(from: .EN, to: .RU, text: message.content, completion: { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let translation):
                DispatchQueue.main.async { [weak self] in
                    self?.translatedLabel.stringValue = translation.data.translations.first?.translatedText ?? "[Undefined]"
                }
            }
        })

    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        self.dismiss(self)
    }
}
