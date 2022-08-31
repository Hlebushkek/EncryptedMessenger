//
//  ProfileImageView.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 24.08.2022.
//

import Cocoa

class ProfileImageView: NSImageView {

    override var image: NSImage? {
        set {
            self.layer = CALayer()
            self.layer?.contentsGravity = .resizeAspectFill
            self.layer?.contents = newValue
            self.layer?.cornerRadius = min(self.frame.width, self.frame.height) / 2
            
            super.image = newValue
        }
        get {
            return super.image
        }
    }
    
}
