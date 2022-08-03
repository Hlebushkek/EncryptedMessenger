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
    
    func setupCell(chat: Chat) {
        chatImage.layer.cornerRadius = chatImage.bounds.width / 2
        chatImage.image = UIImage(systemName: "pencil.circle.fill")
        
        chatName.text = chat.name
        chatLastMessage.text = "Last chat message"
    }
}
