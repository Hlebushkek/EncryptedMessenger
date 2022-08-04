//
//  MessageTableViewCell.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageContentView: GradientView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private weak var message: Message?
    
    public func setupCell(with message: Message) {
        self.message = message

        userImageView.image = UIImage(systemName: "person.circle")
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2

        messageLabel.text = message.content
        
        setupGradient()
    }
    
    private func setupGradient() {
        let isUser = Bool.random()
        messageContentView.colors = isUser ? [UIColor.systemBlue, #colorLiteral(red: 0.01960784314, green: 0.5921568627, blue: 1, alpha: 1)] : [UIColor.systemGray6, UIColor.systemGray6]
        messageContentView.startPoint = CGPoint(x: 1, y: 1)
        messageContentView.endPoint = CGPoint(x: 0, y: 0)
        messageContentView.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
