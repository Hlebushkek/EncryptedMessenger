//
//  TranslationContainerView.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 31.08.2022.
//

import Cocoa

class TranslationContainerView: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.wantsLayer = true
        self.shadow = NSShadow()
        self.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        self.layer?.cornerRadius = 8
        self.layer?.shadowOpacity = 0.4
        self.layer?.shadowColor = NSColor.black.cgColor
        self.layer?.shadowOffset = CGSize(width: 0, height: 0)
        self.layer?.shadowRadius = 8
    }
}
