//
//  EmployeeDetailViewController.swift
//  EmployeeManager
//
//  Created by John Choi on 5/23/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController {

    var employee: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(employee.fullName)
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
