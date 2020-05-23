//
//  LogInViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/18/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Welcome Back!"
        // delegate setup
        emailField.delegate = self
        passwordField.delegate = self
//        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        if checkEmail() && checkPassword() {
            // try logging in
            // if successful, call performSegue()
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                // issue signing in the user
                if error != nil {
                    let alert = UIAlertController(title: "Sign in failed!", message: "There was a problem signing in", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    strongSelf.present(alert, animated: true, completion: {
                        return
                    })
                }
                strongSelf.performSegue(withIdentifier: K.Segues.loginToMain, sender: self)
            }
            
        }
    }

    /**
     Returns true if the email in the email text field is a valid email.
     - Returns: true if the email entry is a valid email
     */
    private func checkEmail() -> Bool {
        if let email = emailField.text {
            if !email.isValidEmail() {
                let alert = UIAlertController(title: "Invalid email!", message: "Please enter valid email", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    /**
     Returns true if the password in the password text field is not empty.
     - Returns: true if the password text field is not empty
     */
    private func checkPassword() -> Bool {
        if let password = passwordField.text {
            if password.count == 0 {
                let alert = UIAlertController(title: "Please enter password", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            if !checkEmail() {
                return false
            }
            passwordField.becomeFirstResponder()
        } else {
            if !checkPassword() {
                return false
            }
            textField.resignFirstResponder()
        }
        return true
    }
}
