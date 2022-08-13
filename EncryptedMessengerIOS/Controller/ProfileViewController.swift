//
//  ProfileViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 02.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var headerView: ProfileHeaderView!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var headerState: ProfileHeaderState = .Default
    
    @IBOutlet weak var tableView: UITableView!
    
    let user = UserDefaultsManager.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.headerView.userName.text = user?.name
        self.navigationItem.title = user?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.alpha = 0
    }
    
    @IBAction func logoutButtonWasPressed(_ sender: Any) {
        print("User = nil")
        UserDefaultsManager.user = nil
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.setup(with: "Settting\(indexPath.section)\(indexPath.row)")
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        let imgHeight = headerView!.userImage.frame.height + 16 //imgHeight + safeAreaHeight
        
        if y <= -80 {
            self.headerState = .Full
            self.headerView.fullUp()
        } else if (y <= -40 && headerState == .Folded) || (y > 0 && headerState == .Full) {
            self.headerState = .Default
            
            self.headerView.scaleToDefault()
            
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.alpha = 0
                self.headerView?.userImage.alpha = 1.0
            }
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
                self.headerViewTopConstraint?.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else if y > 0 && headerState == .Default {
            self.headerState = .Folded
            
            UIView.animate(withDuration: 0.3) {
                self.headerView?.userImage.alpha = 0.0
            }
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
                self.headerViewTopConstraint?.constant = -imgHeight
                self.navigationController?.navigationBar.alpha = 1
//                self.headerView.userName.font = UIFont.boldSystemFont(ofSize: 18)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}

fileprivate enum ProfileHeaderState {
    case Full
    case Default
    case Folded
}
