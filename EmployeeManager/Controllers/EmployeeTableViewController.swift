//
//  EmployeeTableViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/19/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UIViewController {

    @IBOutlet weak var employeeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Employees"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
