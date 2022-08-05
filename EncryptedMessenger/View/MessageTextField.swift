//
//  MessageTextField.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 05.08.2022.
//

import UIKit

class MessageTextField: UITextField {

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
    }
}
