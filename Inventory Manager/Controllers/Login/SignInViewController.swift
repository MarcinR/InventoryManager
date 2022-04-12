//
//  SignInViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 08/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    @IBAction func loginAction() {
        guard let email = emailTextField.text, email.isValidEmail() else {
            showMessage(message: "Invalid email address.")
            return
        }
        guard let password = passwordTextField.text, password.isValidPassword() else {
            showMessage(message: "Password should be longer than 5 characters.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showMessage(message: error.localizedDescription)
                return
            }
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        loginButton.isEnabled = emailTextField.text.isNotEmpty() && passwordTextField.text.isNotEmpty()
//        return true
//    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        loginButton.isEnabled = emailTextField.text.isNotEmpty() && passwordTextField.text.isNotEmpty()
    }
}
