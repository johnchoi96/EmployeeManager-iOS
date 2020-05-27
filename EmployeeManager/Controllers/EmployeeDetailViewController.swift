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
    
    var employee: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = employee.fullName
        firstNameLabel.text = employee.firstName
        if let middleName = employee.middleName {
            middleNameLabel.text = middleName
        } else {
            middleNameLabel.text = ""
        }
        lastNameLabel.text = employee.lastName
        idLabel.text = "\(employee.id)    " // 4 spaces at the end for label rotation
        payRateLabel.text = String(format: "$%.2f", employee.payRate)
        payCheckLabel.text = String(format: "$%.2f", employee.getPaycheck(hours: 1, minutes: 0))
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        let components = sender.calendar.dateComponents([.hour, .minute], from: sender.date)
        let hour = components.hour!
        let minute = components.minute!
        let paycheck = employee.getPaycheck(hours: hour, minutes: minute)
        payCheckLabel.text = String(format: "$%.2f", paycheck)
    }
}
