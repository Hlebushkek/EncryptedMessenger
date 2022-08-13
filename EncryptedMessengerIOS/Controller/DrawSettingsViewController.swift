//
//  DrawSettingsViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 19.04.2022.
//

import UIKit

protocol DrawSettingsViewControllerDelegate: AnyObject {
    func drawSettingsViewControllerFinished(_ drawSettingsViewController: DrawSettingsViewController)
    func invertKey()
}

class DrawSettingsViewController: UIViewController {
    
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var brushLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    weak var delegate: DrawSettingsViewControllerDelegate?
    
    var brush: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        brushSlider.value = Float(brush)
        brushLabel.text = String(format: "%.1f", brush)
        drawPreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.drawSettingsViewControllerFinished(self)
    }
    
    @IBAction func brushChanged(_ sender: UISlider) {
        brush = CGFloat(sender.value)
        brushLabel.text = String(format: "%.1f", brush)
        drawPreview()
    }
    
    @IBAction func invertButtonWasPressed(_ sender: Any) {
        delegate?.invertKey()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(previewImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let imgSize = previewImageView.frame.width
        
        context.setLineCap(.round)
        context.setLineWidth(brush)
        context.setStrokeColor((UIColor.black).cgColor)
        context.move(to: CGPoint(x: imgSize / 2, y: imgSize / 2))
        context.addLine(to: CGPoint(x: imgSize / 2, y: imgSize / 2))
        context.strokePath()
        
        previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
}
