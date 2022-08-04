//
//  MessageCellProtocol.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

import Foundation

protocol MessageCell: UITableViewCell {
    func setupCell(with message: Message)
}
