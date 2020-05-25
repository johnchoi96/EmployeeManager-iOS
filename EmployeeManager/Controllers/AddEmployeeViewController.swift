//
//  AddEmployeeViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/23/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import Firebase

class AddEmployeeViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var middleNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var payRateField: UITextField!
    
    let db = Firestore.firestore()
    var edited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBar.topItem?.title = "Add Employee"
        isModalInPresentation = true
        firstNameField.delegate = self
        middleNameField.delegate = self
        lastNameField.delegate = self
        payRateField.delegate = self
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        // make sure every necessary text fields are filled.
        if !meetsRequirement() {
            return
        }
        // Add a new document with a generated id.
        var employeeData: [String: Any] = [
            "firstName": firstNameField.text!,
            "lastName": lastNameField.text!,
            "id": generateID(),
            "payRate": (payRateField.text! as NSString).floatValue
        ]
        if middleNameField.text != "" {
            employeeData["middleName"] = middleNameField.text
        }
        db.collection("employees").addDocument(data: employeeData) { err in
            if let err = err {
                print("Error adding document: \(err)")
                let alert = UIAlertController(title: "Error", message: "Problem occured while saving. Please try again later", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                // display success message and dismiss the view
                let alert = UIAlertController(title: "Success", message: "New employee, \(self.firstNameField.text!) successfully added", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        if edited {
            let alert = UIAlertController(title: "Data unsaved", message: "Are you sure you want to cancel?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let gobackAction = UIAlertAction(title: "Go Back", style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(gobackAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Generates the unique ID for the new employee.
     - Parameter documentId: ID assigned by Firebase
     - Returns: generated ID for the new employee
     */
    private func generateID() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomID = String((0..<10).map { _ in
            letters.randomElement()!
        })
        return "E-\(randomID)"
    }
    
    /**
     Checks to see if all text fields necessary are filled in order to add a new employee to the database.
     If any of the checks fail, UIAlert is shown.
     
     The checks performed in this method are:
     - First and last name fields must not be empty.
     - Pay rate must not be empty.
     - Any of the name fields must not contain a space.
     - Any of the name fields must not contain a number.
     - Pay rate is guaranteed to be valid because of number pad keyboard for the text field.
     - Returns: true if all the checks pass, false if any of the checks fail and will show an alert
     */
    private func meetsRequirement() -> Bool {
        // check to see if every name text field except for middle name is filled.
        if firstNameField.text == "" || lastNameField.text == "" {
            let alert = UIAlertController(title: "Name required!", message: "First and last names must be provided.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // check to see if the pay rate is provided
        if payRateField.text == "" {
            let alert = UIAlertController(title: "Pay rate must be provided!", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // check to see if name contains spaces
        if firstNameField.text!.containsWhiteSpace() || middleNameField.text!.containsWhiteSpace() || lastNameField.text!.containsWhiteSpace() {
            let alert = UIAlertController(title: "Name fields may not contain spaces.", message: "Please retype the name.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // check to see if name contains number
        if firstNameField.text!.containsNumbers() || middleNameField.text!.containsNumbers() || lastNameField.text!.containsNumbers() {
            let alert = UIAlertController(title: "Name may not contain numbers.", message: "Please retype the name.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

// MARK: - UITextField delegate section
extension AddEmployeeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            middleNameField.becomeFirstResponder()
        case 1:
            lastNameField.becomeFirstResponder()
        case 2:
            payRateField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        edited = true
    }
}

// MARK: - String extension section. Used to check if names contain only the valid characters.
extension String {
    
    /**
     Checks if the string contains a digit.
     - Returns: true if string contains digit
     */
    func containsNumbers() -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            return true
        }
        return false
    }
    
    /**
     Checks if the string contains a whitespace.
     - Returns: true if string contains whitespace
     */
    func containsWhiteSpace() -> Bool {
        let spaceCharacters = CharacterSet.whitespaces
        let spaceRange = self.rangeOfCharacter(from: spaceCharacters)
        if spaceRange != nil {
            return true
        }
        return false
    }
}
