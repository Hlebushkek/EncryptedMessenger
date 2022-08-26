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
            self.layer?.cornerRadius = self.frame.width / 2
            self.wantsLayer = true
            
            super.image = newValue
        }
        get {
            return super.image
        }
    }
    
}
