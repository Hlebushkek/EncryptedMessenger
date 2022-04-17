//
//  ChatCellView.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 17.04.2022.
//

import UIKit

class ChatCellView: UITableViewCell {

    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var chatLastMessage: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(info: (String, String, String)) {
        chatImage.layer.cornerRadius = chatImage.bounds.width / 2
        chatImage.image = UIImage(systemName: info.0)
        
        chatName.text = info.1
        chatLastMessage.text = info.2
    }
}
