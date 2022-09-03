//
//  MessageCellProtocol.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 04.08.2022.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
    typealias TableViewCell = UITableViewCell
#elseif os(macOS)
    import AppKit
    typealias TableViewCell = NSTableCellView
#endif

protocol MessageCell: TableViewCell {
    func setup(with message: Message)
    func apply(_ theme: Theme)
    func setupGradient(with colors: [Color]?)
}
