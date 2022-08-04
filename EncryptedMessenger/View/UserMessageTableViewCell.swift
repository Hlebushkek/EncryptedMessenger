//
//  UserMessageTableViewCell.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

import UIKit

class UserMessageTableViewCell: UITableViewCell, MessageCell {

    @IBOutlet weak var messageContentView: GradientView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private weak var message: Message?
    
    public func setupCell(with message: Message) {
        self.message = message

        messageLabel.text = message.content
        
        setupGradient()
    }
    
    private func setupGradient() {
        messageContentView.colors = [UIColor(named: "UserMessageFirst")!, UIColor(named: "UserMessageSecond")!]
        messageContentView.startPoint = CGPoint(x: 1, y: 1)
        messageContentView.endPoint = CGPoint(x: 0, y: 0)
        messageContentView.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
