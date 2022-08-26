//
//  ChatSettingsBigButtonCell.swift
//  EncryptedMessangerMac
//
//  Created by Gleb Sobolevsky on 22.08.2022.
//

import Cocoa

class ChatSettingsBigButtonCell: NSButtonCell {
    
    private var lastFillState: ButtonFillState = .standart
    private var fillState: ButtonFillState = .standart {
        didSet {
            switch fillState {
            case .standart:
                imageColor = .systemBlue
                titleColor = .systemBlue
            case .hovered:
                imageColor = .systemBlue
                titleColor = .systemBlue
            case .clicked:
                imageColor = .systemBlue.withAlphaComponent(0.85)
                titleColor = .systemBlue.withAlphaComponent(0.85)
            }
        }
    }

    public var backgroundWidthMargin: CGFloat = 0
    public var backgroundHeightMargin: CGFloat = 0

    public var buttonColor: NSColor = .black.withAlphaComponent(0.25)
    public var hoverColor: NSColor = .black.withAlphaComponent(0.25)
    public var onClickColor: NSColor = .black.withAlphaComponent(0.3)
    
    public var imageColor: NSColor = .systemBlue
    public var titleColor: NSColor = .systemBlue
    
    public func setHovered(_ flag: Bool) {
        fillState = flag ? .hovered : .standart
    }
    public func setClicked(_ flag: Bool) {
        fillState = flag ? .clicked : .hovered
    }
    
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        let superRect = super.titleRect(forBounds: rect)
        return CGRect(origin: CGPoint(x: superRect.origin.x, y: rect.height / 2), size: superRect.size)
    }
    
    override func imageRect(forBounds rect: NSRect) -> NSRect {
        let superRect = super.imageRect(forBounds: rect)
        return CGRect(origin: CGPoint(x: superRect.origin.x, y: rect.height / 2 - superRect.height - 4), size: superRect.size)
    }
    
    override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
        switch fillState {
            case .standart:
                buttonColor.set()
            case .hovered:
                hoverColor.set()
            case .clicked:
                onClickColor.set()
        }
        
        let buttonBackgroundPath = NSBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: frame.size).insetBy(dx: backgroundWidthMargin, dy: backgroundHeightMargin), xRadius: frame.height * 0.175, yRadius: frame.height * 0.175)
        
        buttonBackgroundPath.fill()
    }
    
    override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        let attributedString = NSMutableAttributedString(attributedString: title)
        attributedString.addAttribute(.foregroundColor, value: titleColor, range: NSRange(location: 0,length: attributedString.string.count))
        let newFrame = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y), size: frame.size)
        return super.drawTitle(attributedString, withFrame: newFrame, in: controlView)
    }
        
    override func drawImage(_ image: NSImage, withFrame frame: NSRect, in controlView: NSView) {
        image.lockFocus()
        imageColor.set()
        let sourceImgFrame = NSRect(origin: .zero, size: image.size)
        __NSRectFillUsingOperation(sourceImgFrame, .sourceAtop)
        image.unlockFocus()
        
        let targetImgFrame = NSRect(origin: CGPoint(x: frame.midX - image.size.width / 2, y: frame.midY - image.size.height / 2), size: image.size)
        image.draw(in: targetImgFrame)
    }
    
}

enum ButtonFillState {
    case standart
    case hovered
    case clicked
}
