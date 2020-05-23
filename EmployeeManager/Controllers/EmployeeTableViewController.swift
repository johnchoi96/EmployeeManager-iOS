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
    
    var employees = [Employee]()
    
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
                    print("\(document.documentID) => \(document.data())")
                    let firstName = document.data()["firstName"] as! String
                    let lastName = document.data()["lastName"] as! String
                    let id = document.data()["id"] as! String
                    let middleName = document.data()["middleName"] as! String?
                    let employee = Employee(firstName: firstName, middleName: middleName, lastName: lastName, id: id)
                    self.employees.append(employee)
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
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.employeeCell, for: indexPath) as! EmployeeTableViewCell
        cell.nameLabel.text = employees[indexPath.row].fullName
        cell.idLabel.text = employees[indexPath.row].id
        return cell
    }
}

// MARK: - Table View delegate section
extension EmployeeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.tableToEmployeeDetail, sender: employees[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.tableToEmployeeDetail {
            let vc = segue.destination as! EmployeeDetailViewController
            vc.employee = sender as? Employee
        }
    }
}
