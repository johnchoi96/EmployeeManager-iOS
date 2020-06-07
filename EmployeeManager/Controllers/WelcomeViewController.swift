//
//  WelcomeViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/18/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        applyLocalization()
        
        navigationController?.isNavigationBarHidden = true
        signupButton.layer.cornerRadius = 25
        loginButton.layer.cornerRadius = 25
    }

    private func applyLocalization() {
        signupButton.setTitle(NSLocalizedString("sign up button label", comment: "Sign up button label"), for: .normal)
        loginButton.setTitle(NSLocalizedString("log in button label", comment: "Log in button label"), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func signupPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.welcomeToSignup, sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.welcomeToLogin, sender: self)
    }
}

