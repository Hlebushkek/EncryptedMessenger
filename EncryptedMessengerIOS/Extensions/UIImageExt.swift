//
//  UIImageExt.swift
//  EncryptedMessengerIOS
//
//  Created by Gleb Sobolevsky on 13.08.2022.
//

import UIKit

extension UIImage {
    func scaleImage(targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: .default())
        print(self.size)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        print(scaledImage.size)
        return scaledImage
    }
}
