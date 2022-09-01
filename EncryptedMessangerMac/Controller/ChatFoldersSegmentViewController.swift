//
//  ChatFoldersSegmentViewController.swift
//  EncryptedMessangerMac
//
//  Created by Hlib Sobolevskyi on 02.09.2022.
//

import Cocoa

class ChatFoldersSegmentViewController: NSViewController {
    
    @IBOutlet weak var foldersSegmentControl: NSSegmentedControl!
    
    private var folders: [ChatFolder] = UserDefaultsManager.chatFolders

    override func viewDidLoad() {
        super.viewDidLoad()
        
        foldersSegmentControl.segmentCount = folders.count + 1
        
        foldersSegmentControl.setLabel("All", forSegment: 0)
        for i in 0..<folders.count {
            foldersSegmentControl.setLabel(folders[i+1].name, forSegment: i)
        }
    }
    
    @objc func switchDisplayedFolder() {
        
    }
    
}
