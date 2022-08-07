//
//  MainTabBarController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 05.08.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaultsManager.user == nil, let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
            self.present(loginVC, animated:true)
        }
    }

}
