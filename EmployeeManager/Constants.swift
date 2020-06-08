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
    static let states = ["AK", "AL", "AR", "AZ", "CA", "CO", "CT",
                         "DE", "FL", "GA", "HI", "IA", "ID", "IL",
                         "IN", "KS", "KY", "LA", "MA", "MD", "ME",
                         "MI", "MN", "MO", "MS", "MT", "NC", "ND",
                         "NE", "NH", "NJ", "NM", "NV", "NY", "OH",
                         "OK", "OR", "PA", "RI", "SC", "SD", "TN",
                         "TX", "UT", "VA", "VT", "WA", "WI", "WV",
                         "WY"]
    struct Segues {
        static let welcomeToSignup = "welcomeToSignup"
        static let welcomeToLogin = "welcomeToLogin"
        static let signupToMain = "signupToMain"
        static let loginToMain = "loginToMain"
        static let mainToTable = "mainToTable"
        static let tableToEmployeeDetail = "tableToEmployeeDetail"
        static let mainToAddEmployee = "mainToAddEmployee"
        static let detailToAddress = "detailToAddress"
    }
    
    static var APP_VERSION: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    static var BUILD_NUMBER: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
}
