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
    
    @IBOutlet weak var sliderStack: UIStackView!
    
    var employee: Employee!
    
    @IBOutlet weak var hoursInputSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var hourSlider: UISlider!
    @IBOutlet weak var minuteSlider: UISlider!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    let selectionFeedback = UISelectionFeedbackGenerator()
    
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
        
        // set up slider view
        sliderStack.isHidden = true
        hourSlider.maximumValue = 200
        hourSlider.minimumValue = 0
        minuteSlider.maximumValue = 59
        minuteSlider.minimumValue = 0
        
        hourSlider.value = 1
        minuteSlider.value = 0
        
        hapticFeedback.prepare()
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
        
        hoursInputSegmentControl.setTitle("Time Picker", forSegmentAt: 0)
        hoursInputSegmentControl.setTitle("Time Slider", forSegmentAt: 1)
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
        present(alert, animated: true) {
            self.hapticFeedback.notificationOccurred(.success)
        }
    }
    
    @IBAction func hoursModeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            hoursWorked.isHidden = false
            sliderStack.isHidden = true
        } else {
            selectionFeedback.prepare()
            hoursWorked.isHidden = true
            sliderStack.isHidden = false
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        // if sender tag is 0, hour slider. if sender tag is 1, minute slider
        if sender.tag == 0 {
            hourLabel.text = String(value) + " " + (value == 1 ? "Hour" : "Hours")
        } else {
            minuteLabel.text = String(value) + " " + (value == 1 ? "Minute" : "Minutes")
        }
        let hour = Int(hourLabel.text!.split(separator: " ")[0])!
        let minute = Int(minuteLabel.text!.split(separator: " ")[0])!
        let paycheck = employee.getPaycheck(hours: hour, minutes: minute)
        payCheckLabel.text = String(format: "$%.2f", paycheck)
        
        // haptic feedback
        selectionFeedback.selectionChanged()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.detailToAddress {
            let vc = segue.destination as! AddressViewController
            vc.address = sender as? Address
            vc.employeeName = employee.fullName
        }
    }
}
