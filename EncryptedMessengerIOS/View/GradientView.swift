//
//  GradientView.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    typealias View = UIView
    typealias Color = UIColor
#elseif os(macOS)
    import AppKit
    typealias View = NSView
    typealias Color = NSColor
#endif

final class GradientView: View {
    
#if os(iOS) || os(watchOS) || os(tvOS)
    override class var layerClass: AnyClass { return CAGradientLayer.self }
#elseif os(macOS)
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.layer = CAGradientLayer()
    }
#endif
    
    var colors: [Color]? {
        didSet { updateGradientLayer() }
    }
    
    var startPoint: CGPoint = CGPoint.zero {
        didSet {
            (self.layer as? CAGradientLayer)?.startPoint = startPoint
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            (self.layer as? CAGradientLayer)?.endPoint = endPoint
        }
    }

    private func updateGradientLayer() {
        let layer = self.layer as? CAGradientLayer
        layer?.colors = colors?.map({ $0.cgColor })
    }
}
