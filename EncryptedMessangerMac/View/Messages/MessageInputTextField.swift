//
//  MessageInputTextField.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 27.08.2022.
//

import Cocoa

class MessageInputTextField: NSTextField {
    
    weak var messageInputDelegate: MessageInputTextFieldDelegate? {
        get { return self.delegate as? MessageInputTextFieldDelegate }
        set { self.delegate = newValue }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        focusRingType = .none
    }
    
    override func becomeFirstResponder() -> Bool {
        let flag = super.becomeFirstResponder()

        if flag && stringValue.count > 0 {
            messageInputDelegate?.userDidStartTyping()
        }

        return flag
    }
    
    override func textDidBeginEditing(_ notification: Notification) {
        super.textDidBeginEditing(notification)
        
        messageInputDelegate?.userDidStartTyping()
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        
        messageInputDelegate?.userDidEndTyping()
    }

    override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        print(event.keyCode)
    }
    
    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        
        print(event.keyCode)
        if event.keyCode == 36 {
            messageInputDelegate?.userDidTrySendMessage()
        }
    }
    
}

protocol MessageInputTextFieldDelegate: NSTextFieldDelegate {
    func userDidStartTyping()
    func userDidEndTyping()
    func userDidTrySendMessage()
}
