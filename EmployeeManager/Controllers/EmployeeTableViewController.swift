//
//  EmployeeTableViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/19/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import Firebase

class EmployeeTableViewController: UIViewController {

    @IBOutlet weak var employeeTable: UITableView!
    
    let employeeManager = EmployeeManager()
    var isAdmin: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Employees"
        employeeTable.dataSource = self
        employeeTable.delegate = self
        employeeTable.register(UINib(nibName: K.employeeCellName, bundle: nil), forCellReuseIdentifier: K.employeeCell)
        readData()
    }
    
    private func readData() {
        let db = Firestore.firestore()
        db.collection("employees").order(by: "firstName").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let firstName = document.data()["firstName"] as! String
                    let lastName = document.data()["lastName"] as! String
                    let id = document.data()["id"] as! String
                    let middleName = document.data()["middleName"] as! String?
                    let payRate = document.data()["payRate"] as! Float
                    let address = Address(street: document.data()["street"] as! String,
                                          street1: document.data()["optionalStreet"] as! String?,
                                          city: document.data()["city"] as! String,
                                          state: document.data()["state"] as! String,
                                          zip: document.data()["zip"] as! String)
                    let employee = Employee(firstName: firstName, middleName: middleName, lastName: lastName, id: id, payRate: payRate, address: address)
                    self.employeeManager.employees.append(employee)
                }
                // finished getting all employee data so reload the table
                DispatchQueue.main.async {
                    self.employeeTable.reloadData()
                }
            }
        }
    }
}

// MARK: - Table View data source section
extension EmployeeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeManager.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.employeeCell, for: indexPath) as! EmployeeTableViewCell
        cell.nameLabel.text = employeeManager.employees[indexPath.row].fullName
        cell.idLabel.text = employeeManager.employees[indexPath.row].id
        return cell
    }
}

// MARK: - Table View delegate section
extension EmployeeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: K.Segues.tableToEmployeeDetail, sender: employeeManager.employees[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.tableToEmployeeDetail {
            let vc = segue.destination as! EmployeeDetailViewController
            vc.employee = sender as? Employee
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete data from Firebase
            let db = Firestore.firestore()
            // get employee document ID
            let docId = employeeManager.employees[indexPath.row].docId
            db.collection("employees").document(docId).delete() { err in
                if let err = err {
                    let alert = UIAlertController(title: "Problem occured while deleting employee!", message: "Error: \(err)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true) {
                        return
                    }
                }
            }
            employeeManager.employees.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // only allow cell deletion if the signed in user is a admin
        return isAdmin
    }
}
