//
//  LoginViewController.swift
//  EncryptedMessenger
//
//  Created by Gleb Sobolevsky on 05.08.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginInButtonWasPressed(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        UserRequest().findUser(email: email, password: password) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let user):
                UserDefaultsManager.user = user
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func signUpButtonWasPressed(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        let user = User(name: "UserName", imageBase64: nil, email: email, password: password)
        ResourceRequest<User>(resourcePath: "user").save(user) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let user):
                print("Successfuly saved user \(user.email)")
                UserDefaultsManager.user = user
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
}
