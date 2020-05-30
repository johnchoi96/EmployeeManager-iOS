//
//  EmployeeTest.swift
//  EmployeesTests
//
//  Created by John Choi on 5/27/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import XCTest

class EmployeeTest: XCTestCase {

    var employee1: Employee!
    var employee2: Employee!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        employee1 = Employee(firstName: "John", middleName: nil, lastName: "Choi", id: "E-1234567890", payRate: 25.0)
        employee2 = Employee(firstName: "Shannon", middleName: "Kyle", lastName: "Meulink", id: "E-0987654321", payRate: 15.0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotEqual(employee1.firstName, employee2.firstName)
    }
    
    func testGenerateEmployeeFullName() throws {
        XCTAssertEqual("John Choi", employee1.fullName)
        XCTAssertEqual("Shannon Kyle Meulink", employee2.fullName)
    }
    
    func testExtractEmployeeDocId() throws {
        XCTAssertEqual("1234567890", employee1.docId)
        XCTAssertEqual("0987654321", employee2.docId)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = employee1.getPaycheck(hours: 1, minutes: 30)
        }
    }

}
