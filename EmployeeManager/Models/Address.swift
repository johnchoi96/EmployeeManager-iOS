//
//  Address.swift
//  EmployeeManager
//
//  Created by John Choi on 5/30/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import Foundation

struct Address {
    
    let street: String
    let street1: String?
    let city: String
    let state: String
    let zip: String
    
    var fullAddress: String {
        if let street1 = street1 {
            return "\(street), \(street1), \(city), \(state) \(zip)"
        } else {
            return "\(street), \(city), \(state) \(zip)"
        }
    }
}
