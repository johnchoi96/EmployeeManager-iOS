//
//  Constants.swift
//  EmployeeManager
//
//  Created by John Choi on 5/18/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import Foundation

struct K {
    
    static let employeeCell = "employeeCell"
    static let employeeCellName = "EmployeeTableViewCell"
    
    struct Segues {
        static let welcomeToSignup = "welcomeToSignup"
        static let welcomeToLogin = "welcomeToLogin"
        static let signupToMain = "signupToMain"
        static let loginToMain = "loginToMain"
        static let mainToTable = "mainToTable"
        static let tableToEmployeeDetail = "tableToEmployeeDetail"
        static let mainToAddEmployee = "mainToAddEmployee"
    }
}
