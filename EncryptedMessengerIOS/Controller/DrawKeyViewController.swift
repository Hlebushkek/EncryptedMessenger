//
//  DrawKeyViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 18.04.2022.
//

import UIKit

class DrawKeyViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    public weak var delegate: DrawKeyViewControllerDelegate?
    
    let color = UIColor.black
    let opacity: CGFloat = 1.0
    
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var swiped = false

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        swiped = false
        lastPoint = touch.location(in: mainImageView)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        swiped = true
        let currentPoint = touch.location(in: mainImageView)
        drawLine(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
        doneButton.isEnabled = true
    }

    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempImageView.image?.draw(in: mainImageView.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
      
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
      
        context.strokePath()

        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }

    @IBAction func resetImageButtonPressed(_ sender: Any) {
        mainImageView.image = nil
        doneButton.isEnabled = false
    }
    
    @IBAction func doneButtonWasPressed(_ sender: Any) {
        guard let drawedImage = mainImageView.image else {
            return
        }
        let scaledImg = drawedImage.scaleImage(targetSize: CGSize(width: 90, height: 150))
        delegate?.didEndDrawingKey(image: scaledImg)
        self.navigationController?.popViewController(animated: true)
    }
}

extension DrawKeyViewController: DrawSettingsViewControllerDelegate {
    
    func drawSettingsViewControllerFinished(_ drawSettingsViewController: DrawSettingsViewController) {
        brushWidth = drawSettingsViewController.brush
    }
    
    func invertKey() {
        mainImageView.image = KeyAnalizerWrapper.invertKey(mainImageView.image)
    }
}

extension DrawKeyViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? DrawSettingsViewController else { return }
        
        settingsVC.delegate = self
        settingsVC.brush = brushWidth
    }
}

extension DrawKeyViewController {
    func saveImage(image: UIImage, name: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(name + ".png")!)
            print("SAVE")
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let path = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
            print("Path: \(path)")
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
    
    func getSavedImagePath(named: String) -> String? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let path = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path
            print("Path: \(path)")
            return path
        }
        return nil
    }
}

protocol DrawKeyViewControllerDelegate: AnyObject {
    func didEndDrawingKey(image: UIImage)
}
