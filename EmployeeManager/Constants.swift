//
//  Constants.swift
//  EmployeeManager
//
//  Created by John Choi on 5/18/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import UIKit
import Foundation

struct K {
    
    static let employeeCell = "employeeCell"
    static let employeeCellName = "EmployeeTableViewCell"
    
    static let states = ["North Carolina", "Alaska", "Alabama", "Arkansas", "Arizona", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana"
        , "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Dakota",
          "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina"
        , "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
    
    static let statesDictionary = ["Louisiana": "LA", "Washington": "WA", "Iowa": "IA", "Nevada": "NV", "Oklahoma": "OK",
                                   "Rhode Island": "RI", "Maine": "ME", "New Jersey": "NJ", "New Mexico": "NM", "Arizona": "AZ",
                                   "Illinois": "IL", "Kansas": "KS", "Montana": "MT", "Michigan": "MI", "Vermont": "VT",
                                   "North Carolina": "NC", "Tennessee": "TN", "Colorado": "CO", "Indiana": "IN", "Maryland": "MD",
                                   "Utah": "UT", "Minnesota": "MN", "South Carolina": "SC", "Texas": "TX", "Alaska": "AK",
                                   "Missouri": "MO", "Nebraska": "NE", "Virginia": "VA", "Mississippi": "MS", "Hawaii": "HI",
                                   "Wyoming": "WY", "Florida": "FL", "South Dakota": "SD", "Georgia": "GA", "Arkansas": "AR",
                                   "Ohio": "OH", "Oregon": "OR", "California": "CA", "Pennsylvania": "PA", "West Virginia": "WV",
                                   "Idaho": "ID", "Kentucky": "KY", "Alabama": "AL", "Delaware": "DE", "Massachusetts": "MA",
                                   "North Dakota": "ND", "Wisconsin": "WI", "Connecticut": "CT", "New Hampshire": "NH", "New York": "NY"]
    
    struct Segues {
        static let welcomeToSignup = "welcomeToSignup"
        static let welcomeToLogin = "welcomeToLogin"
        static let signupToMain = "signupToMain"
        static let loginToMain = "loginToMain"
        static let mainToTable = "mainToTable"
        static let tableToEmployeeDetail = "tableToEmployeeDetail"
        static let mainToAddEmployee = "mainToAddEmployee"
        static let detailToAddress = "detailToAddress"
        static let mainToAbout = "mainToAbout"
    }
    
    static var APP_VERSION: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    static var BUILD_NUMBER: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    static var OS: String {
        var osLabel: String
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            osLabel = "iOS"
        case .pad:
            osLabel = "iPadOS"
        default:
            osLabel = "iOS"
        }
        osLabel += " \(Bundle.main.infoDictionary?["DTPlatformVersion"] as! String)"
        return osLabel
    }
}
