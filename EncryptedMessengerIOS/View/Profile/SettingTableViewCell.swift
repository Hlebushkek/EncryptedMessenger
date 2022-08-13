//
//  SettingTableViewCell.swift
//  EncryptedMessengerIOS
//
//  Created by Gleb Sobolevsky on 13.08.2022.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingImageView.backgroundColor = .systemYellow
        settingImageView.layer.cornerRadius = 8
    }
    
    public func setup(with setting: String /*Setting*/) {
        settingImageView.image = UIImage(systemName: "person")
        settingNameLabel.text = setting
    }
    
}
