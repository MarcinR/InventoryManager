//
//  SignUpViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 08/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var confirmPasswordTextField: UITextField!
    @IBOutlet private var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func signUpAction() {
        guard let email = emailTextField.text, email.isValidEmail() else {
            showMessage(message: "Invalid email address.")
            return
        }
        guard let password = passwordTextField.text, password.isValidPassword() else {
            showMessage(message: "Password should be longer than 5 characters.")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword == password else {
            showMessage(message: "Passwords do not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    self?.showMessage(message: error.localizedDescription)
                    return
                }
              print(authResult)
        }

    }
    
    @IBAction func endEditing() {
        view.endEditing(true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        textField.text = text
//
//
//        return false
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.text)
        signUpButton.isEnabled = emailTextField.text.isNotEmpty() && passwordTextField.text.isNotEmpty() && confirmPasswordTextField.text.isNotEmpty()
    }
    
}
