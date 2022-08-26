//
//  ChatSettingsBigButton.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 23.08.2022.
//

import Cocoa

class ChatSettingsBigButton: NSButton {

    override func mouseDown(with event: NSEvent) {
        (cell as? ChatSettingsBigButtonCell)?.setClicked(true)
        super.mouseDown(with: event)
        (cell as? ChatSettingsBigButtonCell)?.setClicked(false)
    }
    
    override func mouseEntered(with event: NSEvent) {
        (cell as? ChatSettingsBigButtonCell)?.setHovered(true)
        needsDisplay = true
    }
    override func mouseExited(with event: NSEvent) {
        (cell as? ChatSettingsBigButtonCell)?.setHovered(false)
        needsDisplay = true
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        for trackingArea in self.trackingAreas {
            self.removeTrackingArea(trackingArea)
        }
        
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
}
