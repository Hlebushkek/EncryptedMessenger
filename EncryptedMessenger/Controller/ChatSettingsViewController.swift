//
//  ChatSettingsViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 06.08.2022.
//

import UIKit

class ChatSettingsViewController: UIViewController {

    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension ChatSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.row == 0 ? "addUserCell" : "userCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else { return UITableViewCell() }
        
        return cell
    }
    
}
