//
//  ChatCellView.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 17.04.2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var chatLastMessage: UILabel!
    
    func setupCell(chat: Chat) {
        chatImage.layer.cornerRadius = chatImage.bounds.width / 2
        
        let config = UIImage.SymbolConfiguration(paletteColors: [.black, .red])
        chatImage.image = UIImage(systemName: "pencil.circle.fill")?.withConfiguration(config)
        
        chatName.text = chat.name
        chatLastMessage.text = "Last chat message"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
