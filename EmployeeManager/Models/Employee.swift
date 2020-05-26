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
    var payRate: Float
    
    /**
     Returns the full name for this employee.
     If middle name is nil, only first and last names are returned.
     */
    var fullName: String {
        if let middleName = middleName {
            return "\(firstName) \(middleName) \(lastName)"
        } else {
            return "\(firstName) \(lastName)"
        }
    }
    
    /**
     Omits the "E-" prefix at the start of the employee id.
     */
    var docId: String {
        let start = id.index(id.startIndex, offsetBy: 2)
        let end = id.endIndex
        let range = start..<end
        let docId = id[range]
        return String(docId)
    }
    
    /**
     Returns the pay check based on this employee's pay rate and the worked time information
     passed in.
     - Parameter hours: number of hours worked
     - Parameter minutes: number of minutes worked
     - Returns: the total paycheck for this employee
     */
    func getPaycheck(hours: Int, minutes: Int) -> Float {
        let totalTime = Float(hours) + Float(minutes) / 60.0
        return payRate * totalTime
    }
}
