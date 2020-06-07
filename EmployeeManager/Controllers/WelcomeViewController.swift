//
//  WelcomeViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/18/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signupView: UIButton!
    @IBOutlet weak var loginView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        signupView.layer.cornerRadius = 25
        loginView.layer.cornerRadius = 25
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

