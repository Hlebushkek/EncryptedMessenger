//
//  MessageTableViewCell.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell, MessageCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageContentView: GradientView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private weak var message: Message?
    
    public func setup(with message: Message) {
        self.message = message

        userImageView.image = UIImage(systemName: "person.circle")
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2

        messageLabel.text = message.content
        
        setupContetnView()
    }
    
    private func setupContetnView() {
        messageContentView.colors = [UIColor.systemGray6, UIColor.systemGray6]
        messageContentView.startPoint = CGPoint(x: 1, y: 1)
        messageContentView.endPoint = CGPoint(x: 0, y: 0)
        messageContentView.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
