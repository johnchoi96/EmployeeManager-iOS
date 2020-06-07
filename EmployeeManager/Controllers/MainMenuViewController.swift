//
//  MainMenuViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/18/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var adminImage: UIButton!
    @IBOutlet weak var viewEmployeesButton: UIButton!
    @IBOutlet weak var addEmployeeButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var handle: AuthStateDidChangeListenerHandle!
    var userEmail: String!
    var db = Firestore.firestore()
    var userIsAdmin = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userEmail = user!.email
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        applyLocalization()
        
        // button view corner radius setup
        viewEmployeesButton.layer.cornerRadius = 25
        addEmployeeButton.layer.cornerRadius = 25
        aboutButton.layer.cornerRadius = 25
        githubButton.layer.cornerRadius = 25
        
        navigationItem.hidesBackButton = true
        adminImage.isHidden = true
        checkIfAdmin()
    }
    
    private func applyLocalization() {
        title = NSLocalizedString("main menu title", comment: "Main menu title")
        viewEmployeesButton.setTitle(NSLocalizedString("view employees button label", comment: "View employees button label"), for: .normal)
        addEmployeeButton.setTitle((NSLocalizedString("add employee button label", comment: "Add employee button label")), for: .normal)
        aboutButton.setTitle(NSLocalizedString("about button label", comment: "About button label"), for: .normal)
        githubButton.setTitle(NSLocalizedString("github button label", comment: "Github button label"), for: .normal)
        logoutButton.title = NSLocalizedString("logout button label", comment: "Log out button label")
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func viewEmployeesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.mainToTable, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.mainToTable {
            let vc = segue.destination as! EmployeeTableViewController
            vc.isAdmin = userIsAdmin
        }
    }
    
    /**
     Handles button behavior for the last row of buttons.
     "About" button has tag 0, "GitHub" button has tag 1.
     - Parameter sender: either About or GitHub button
     */
    @IBAction func aboutOrGithubPressed(_ sender: UIButton) {
        var address = ""
        if sender.tag == 0 {
            address = "https://johnchoi96.github.io/"
        } else { // button has tag = 1
            address = "https://johnchoi96.github.io/EmployeeManager-iOS/"
        }
        guard let url = URL(string: address) else {
            let alert = UIAlertController(title: "Cannot load page", message: "Error occured while loading page", preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .pageSheet // present modally
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addEmployeePressed(_ sender: UIButton) {
        if !userIsAdmin {
            let alertTitle = "You do not have permission to add employee."
            let alertMessage = ""
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: K.Segues.mainToAddEmployee, sender: self)
        }
    }
    
    @IBAction func adminIndicatorPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "You are an admin", message: "You may add or remove employee.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Goes through the list of admin users in the Cloud Firestore and returns true if the current logged in user's
     email exists in the database.
     If the current user is determined to be an admin, the icon is shown to indicate this.
     After checking, updates the UI to show the admin indicator.
     */
    private func checkIfAdmin() {
        var isAdmin = false
        db.collection("admins").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let adminEmail = document.data()["email"] as? String, let safeUserEmail = self.userEmail {
                        if adminEmail == safeUserEmail {
                            isAdmin = true
                        }
                    }
                }
                // done checking so decide to show the icon or not
                DispatchQueue.main.async {
                    self.userIsAdmin = isAdmin
                    if isAdmin {
                        self.adminImage.layer.cornerRadius = 5
                        self.adminImage.clipsToBounds = true
                        self.adminImage.isHidden = false
                    }
                }
            }
        }
    }
    
}
