//
//  Employee.swift
//  EmployeeManager
//
//  Created by John Choi on 5/23/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import Foundation

/**
 Defines the employee and its attributes.
 Every attribute must exist except for middle name.
 */
struct Employee {
    let firstName: String
    let middleName: String?
    let lastName: String
    let id: String
    
    var fullName: String {
        if let middleName = middleName {
            return "\(firstName) \(middleName) \(lastName)"
        } else {
            return "\(firstName) \(lastName)"
        }
    }
}
