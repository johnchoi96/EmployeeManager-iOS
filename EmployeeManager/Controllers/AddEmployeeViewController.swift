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
    
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var optionalStreetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    var edited = false
    var requiredAddressFields = [UITextField]()
    var state: String!
    
    private let OK = NSLocalizedString("OK message", comment: "OK message used for alert action button label")
    private let CANCEL = NSLocalizedString("Cancel message", comment: "Cancel message used for alert action button label")
    private let GO_BACK = NSLocalizedString("go back message", comment: "Go Back message used for alert action button label")
    private let YES = NSLocalizedString("Yes message", comment: "Yes message used for alert action button label")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        applyLocalization()
        
        isModalInPresentation = true // disable swipe down to dismiss
        firstNameField.delegate = self
        middleNameField.delegate = self
        lastNameField.delegate = self
        payRateField.delegate = self
        statePicker.dataSource = self
        statePicker.delegate = self
        requiredAddressFields.append(streetField)
        requiredAddressFields.append(cityField)
        requiredAddressFields.append(zipField)
    }
    
    private func applyLocalization() {
        navigationBar.topItem?.title = NSLocalizedString("add employee bar title", comment: "Page title")
        cancelButton.title = NSLocalizedString("cancel button", comment: "Cancel button")
        saveButton.title = NSLocalizedString("save button", comment: "Save button")
        streetField.placeholder = NSLocalizedString("street tf ph", comment: "Street label")
        optionalStreetField.placeholder = NSLocalizedString("street 2 tf ph", comment: "Street 2 label")
        payRateField.placeholder = NSLocalizedString("pay rate tf ph", comment: "Pay rate label")
        cityField.placeholder = NSLocalizedString("city tf ph", comment: "City label")
        stateLabel.text = NSLocalizedString("state tf", comment: "State label")
        zipField.placeholder = NSLocalizedString("zip code tf ph", comment: "Zip code label")
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        // make sure every necessary text fields are filled.
        if !meetsRequirement() {
            return
        }
        // Add a new document with a generated id.
        let ref = db.collection("employees").document()
        var employeeData: [String: Any] = [
            "firstName": firstNameField.text!,
            "lastName": lastNameField.text!,
            "id": generateID(with: ref.documentID),
            "payRate": (payRateField.text! as NSString).floatValue,
            "street": streetField.text!,
            "city": cityField.text!,
            "state": state as Any,
            "zip": zipField.text!
        ]
        // if middle name is filled in, add the middle name to the data.
        if middleNameField.text != "" {
            employeeData["middleName"] = middleNameField.text
        }
        // if optional second street is filled in, add it to the data
        if optionalStreetField.text != "" {
            employeeData["optionalStreet"] = optionalStreetField.text!
        }
        ref.setData(employeeData) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
                let alert = UIAlertController(title: NSLocalizedString("Error message", comment: ""), message: NSLocalizedString("saving problem alert message", comment: ""), preferredStyle: .alert)
                let action = UIAlertAction(title: self.OK, style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                // display success message and dismiss the view
                let message = String.localizedStringWithFormat(NSLocalizedString("employee add confirmation message", comment: ""), self.firstNameField.text!, employeeData["id"] as! String)
                let alert = UIAlertController(title: NSLocalizedString("Success message", comment: ""), message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: self.OK, style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        if edited {
            let alert = UIAlertController(title: NSLocalizedString("cancel confirmation alert", comment: ""), message: NSLocalizedString("cancel confirmation alert message", comment: ""), preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: self.YES, style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let gobackAction = UIAlertAction(title: self.GO_BACK, style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(gobackAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Generates the unique ID for the new employee.
     Appends the unique document ID generated by Firestore after prefix E
     - Parameter reference: ID assigned by Firebase
     - Returns: generated ID for the new employee
     */
    private func generateID(with reference: String) -> String {
        return "E-\(reference)"
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
     - Every address fields except for the optional second street must be filled.
     - Returns: true if all the checks pass, false if any of the checks fail and will show an alert
     */
    private func meetsRequirement() -> Bool {
        // check to see if every name text field except for middle name is filled.
        if firstNameField.text == "" || lastNameField.text == "" {
            let alert = UIAlertController(title: NSLocalizedString("name required alert", comment: ""), message: NSLocalizedString("name required alert message", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: OK, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // check to see if the pay rate is provided
        if payRateField.text == "" {
            let alert = UIAlertController(title: NSLocalizedString("hourly rate required alert", comment: ""), message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: OK, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // check to see if name contains spaces
        if firstNameField.text!.containsWhiteSpace() || middleNameField.text!.containsWhiteSpace() || lastNameField.text!.containsWhiteSpace() {
            let alert = UIAlertController(title: NSLocalizedString("cannot contain space alert", comment: ""), message: NSLocalizedString("please retype name message", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: OK, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // check to see if name contains number
        if firstNameField.text!.containsNumbers() || middleNameField.text!.containsNumbers() || lastNameField.text!.containsNumbers() {
            let alert = UIAlertController(title: NSLocalizedString("cannot contain numbers alert", comment: ""), message: NSLocalizedString("please retype name message", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: OK, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        // check to see if every address fields are filled
        for textField in requiredAddressFields {
            if textField.text == "" {
                let alert = UIAlertController(title: NSLocalizedString("address incomplete alert", comment: ""), message: NSLocalizedString("address incomplete alert message", comment: ""), preferredStyle: .alert)
                let action = UIAlertAction(title: OK, style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return false
            }
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

// MARK: - UIPickerView data source and delegate section
extension AddEmployeeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.states[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        state = K.states[row]
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
