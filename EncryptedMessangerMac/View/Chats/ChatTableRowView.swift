//
//  ChatTableRowView.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 03.09.2022.
//

import Cocoa

class ChatTableRowView: NSTableRowView {
    
    override func drawSelection(in dirtyRect: NSRect) {
        NSColor.systemBlue.withAlphaComponent(0.6).set()
        NSBezierPath(roundedRect: dirtyRect.insetBy(dx: 10, dy: 0), xRadius: 5, yRadius: 5).fill()
    }
    
}
