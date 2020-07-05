//
//  EmployeeDetailViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/23/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var middleNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var payRateLabel: UILabel!
    @IBOutlet weak var hoursWorked: UIDatePicker!
    @IBOutlet weak var payCheckLabel: UILabel!
    
    @IBOutlet weak var viewAddressButton: UIButton!
    @IBOutlet weak var payrateLabel: UILabel!
    @IBOutlet weak var hoursWorkedLabel: UILabel!
    @IBOutlet weak var paycheckLabel: UILabel!
    
    @IBOutlet weak var middleNameStackView: UIStackView!
    
    var employee: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applyLocalization()
        
        title = employee.fullName
        firstNameLabel.text = employee.firstName
        if let middleName = employee.middleName {
            middleNameLabel.text = middleName
        } else {
            middleNameStackView.isHidden = true
        }
        lastNameLabel.text = employee.lastName
        idLabel.text = "\(employee.id)    " // 4 spaces at the end for label rotation
        payRateLabel.text = String(format: "$%.2f", employee.payRate)
        payCheckLabel.text = String(format: "$%.2f", employee.getPaycheck(hours: 1, minutes: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // fixes the UIDatePicker not triggering the value changed method for the first try
        let countDownDuration = hoursWorked.countDownDuration
        hoursWorked.countDownDuration = countDownDuration
    }
    
    private func applyLocalization() {
        viewAddressButton.setTitle(NSLocalizedString("view address button label", comment: "View address button label"), for: .normal)
        payrateLabel.text = NSLocalizedString("pay rate label", comment: "Pay rate label")
        hoursWorkedLabel.text = NSLocalizedString("hours worked label", comment: "Hours worked label")
        paycheckLabel.text = NSLocalizedString("pay check label", comment: "Pay check label")
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        let components = sender.calendar.dateComponents([.hour, .minute], from: sender.date)
        let hour = components.hour!
        let minute = components.minute!
        let paycheck = employee.getPaycheck(hours: hour, minutes: minute)
        payCheckLabel.text = String(format: "$%.2f", paycheck)
    }
    
    @IBAction func viewAddressPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.detailToAddress, sender: employee.address)
    }
    
    @IBAction func tapped(_ sender: UILongPressGestureRecognizer) {
        UIPasteboard.general.string = employee.id
        let alert = UIAlertController(title: NSLocalizedString("copied confirmation alert", comment: ""), message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Close message", comment: ""), style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.detailToAddress {
            let vc = segue.destination as! AddressViewController
            vc.address = sender as? Address
            vc.employeeName = employee.fullName
        }
    }
}
