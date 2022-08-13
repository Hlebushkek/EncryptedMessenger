//
//  GradientView.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

import UIKit

final class GradientView: UIView {
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }

    var colors: [UIColor]? {
        didSet { updateLayer() }
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

    private func updateLayer() {
        let layer = self.layer as? CAGradientLayer
        layer?.colors = colors?.map({ $0.cgColor })
    }
}
