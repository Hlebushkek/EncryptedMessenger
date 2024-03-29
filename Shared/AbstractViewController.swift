//
//  AbstractViewController.swift
//  EncryptedMessenger
//
//  Created by Hlib Sobolevskyi on 02.09.2022.
//

import Foundation

protocol AbstractViewController: ViewController {
    var theme: Theme { get }
    
    func setupUI()
    func applyTheme()
}
