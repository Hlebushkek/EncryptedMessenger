//
//  ChatsViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 17.04.2022.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let data = [
        ("pencil.circle.fill", "Chat 1", "Chat last message 1"),
        ("pencil.circle.fill", "Chat 2", "Chat last message 2 Chat last message 2 Chat last message 2 Chat last message 2 Chat last message 2 Chat last message 2"),
        ("pencil.circle.fill", "Chat 3", "Chat last message 3"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.setLeftBarButton(UIBarButtonItem(systemItem: .edit), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(systemItem: .compose), animated: true)
        //navigationItem.titleView = createNavTitleView()
    }
    
    func createNavTitleView() -> UIView {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Chats"
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 17)
        ])
        
        let button1 = createButton(title: "All")
        let button2 = createButton(title: "Group1")
        
        let buttonsStackView = UIStackView(arrangedSubviews: [button1, button2])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 16
        
        let mainStackView = UIStackView(arrangedSubviews: [label, buttonsStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 8

        return mainStackView
    }
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .systemGray
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        return button
    }

}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatCellView else { return UITableViewCell()}
        
        cell.setupCell(info: data[indexPath.row])
        return cell
    }
    
}
