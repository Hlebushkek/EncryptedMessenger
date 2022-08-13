//
//  ProfileHeaderView.swift
//  EncryptedMessengerIOS
//
//  Created by Gleb Sobolevsky on 13.08.2022.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        guard let contentView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        contentView.frame = self.bounds
        addSubview(contentView)
   }
    
    public func fullUp(_ completion: (()->Void)? = nil) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
            self.userImageWidthConstraint.constant = 156
            self.userImageHeightConstraint.constant = 156
            self.layoutIfNeeded()
        }, completion: { _ in
            if let completion = completion {
                completion()
            }
        })
    }
    
    public func scaleToDefault(_ completion: (()->Void)? = nil) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
            self.userImageWidthConstraint.constant = 64
            self.userImageHeightConstraint.constant = 64
            self.layoutIfNeeded()
        }, completion: { _ in
            if let completion = completion {
                completion()
            }
        })
    }

}
