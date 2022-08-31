//
//  EditableProfileImageView.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 24.08.2022.
//

import Cocoa

class EditableProfileImageView: ProfileImageView {
    
    weak var delegate: EditableProfileImageViewDelegate?
    
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:NSImage.imageTypes]
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        registerForDraggedTypes([.URL])
        self.isEditable = true
    }
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        let pasteBoard = draggingInfo.draggingPasteboard
        
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            return isEditable
        }
        return false
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        if let url = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: filteringOptions)?.first as? URL {
            delegate?.newImageDidSet(sender: self, imgPath: url)
        }
    }
}

protocol EditableProfileImageViewDelegate: AnyObject {
    func newImageDidSet(sender: EditableProfileImageView, imgPath: URL)
}
