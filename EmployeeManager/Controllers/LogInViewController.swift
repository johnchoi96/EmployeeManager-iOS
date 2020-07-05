//
//  LogInViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/18/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var loginView: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyLocalization()
        
        // delegate setup
        emailField.delegate = self
        passwordField.delegate = self
//        self.navigationItem.largeTitleDisplayMode = .never
        
        spinnerView.isHidden = true
        spinnerView.layer.cornerRadius = 10
        spinnerView.alpha = 0.7
        if let email = defaults.string(forKey: "email") {
            emailField.text = email
        }
        emailField.becomeFirstResponder()
        logInButton.isEnabled = true
        
        loginView.layer.cornerRadius = 25
    }
    
    private func applyLocalization() {
        title = NSLocalizedString("log in title", comment: "Title for log in screen")
        emailField.placeholder = NSLocalizedString("email ph", comment: "Email field placeholder")
        passwordField.placeholder = NSLocalizedString("password ph", comment: "Password field placeholder")
        logInButton.setTitle(NSLocalizedString("log in button label", comment: "Log in button label"), for: .normal)
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        logIn()
    }
    
    private func logIn() {
        spinnerView.isHidden = false
        spinner.startAnimating()
        
        if checkEmail() && checkPassword() {
            // try logging in
            // if successful, call performSegue()
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                // issue signing in the user
                if error != nil {
                    strongSelf.spinner.stopAnimating()
                    strongSelf.spinnerView.isHidden = true
                    strongSelf.logInButton.isEnabled = true
                    let alert = UIAlertController(title: NSLocalizedString("sign in failed alert", comment: ""), message: NSLocalizedString("sign in failed alert message", comment: ""), preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OK message", comment: ""), style: .default, handler: nil)
                    alert.addAction(action)
                    strongSelf.present(alert, animated: true, completion: {
                        return
                    })
                }
                strongSelf.spinner.stopAnimating()
                strongSelf.spinnerView.isHidden = true
                // login should be successful so save the email to UserDefaults
                strongSelf.defaults.set(strongSelf.emailField.text!, forKey: "email")
                strongSelf.performSegue(withIdentifier: K.Segues.loginToMain, sender: self)
            }
            
        } else {
            spinner.stopAnimating()
            spinnerView.isHidden = true
        }
    }

    @IBAction func faceIDLoginPressed(_ sender: UIButton) {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your password"
        
        // check if biometric is available
        var authorizationError: NSError?
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
            print("Biometrics is supported")
            switch localAuthenticationContext.biometryType {
            case .faceID:
                fallthrough
            case .touchID:
                localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Authentication is required") { (success, error) in
                    if success {
                        print("Success")
                    } else {
                        print("Error \(String(describing: error))")
                    }
                }
            default:
                print("Biometric not available")
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
                let alert = UIAlertController(title: NSLocalizedString("invalid email alert", comment: ""), message: NSLocalizedString("invalid email alert message", comment: ""), preferredStyle: .alert)
                let action = UIAlertAction(title: NSLocalizedString("OK message", comment: ""), style: .default, handler: nil)
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
                let alert = UIAlertController(title: NSLocalizedString("invalid password no input alert message", comment: ""), message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: NSLocalizedString("OK message", comment: ""), style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}

// MARK: - UITextField delegate section
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
            logInButton.isEnabled = false
            textField.resignFirstResponder()
            logIn()
        }
        return true
    }
}
