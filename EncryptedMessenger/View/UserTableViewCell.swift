//
//  UserTableViewCell.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 09.08.2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLastOnlineLabel: UILabel!
    
    @IBOutlet weak var userChatRoleLabel: UILabel!
    
    public func setupCell(for user: User) {
        
        if let str = user.imageBase64, let img = Utilities.image(from: str){
            userImageView.image = img
        } else { userImageView.image = UIImage(systemName: "person.circle") }
        
        userNameLabel.text = user.email
        userLastOnlineLabel.text = "online"
        
        userChatRoleLabel.text = "admin"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
