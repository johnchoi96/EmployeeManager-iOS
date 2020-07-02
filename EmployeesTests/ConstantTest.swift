//
//  ConstantTest.swift
//  EmployeesTests
//
//  Created by John Choi on 7/2/20.
//  Copyright © 2020 John Choi. All rights reserved.
//

import XCTest

@testable import Employees

class ConstantTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStateListCount() throws {
        XCTAssertEqual(K.states.count, 50)
    }
    
    func testStateDictionaryCount() throws {
        XCTAssertEqual(K.statesDictionary.count, 50)
    }
    
    func testVerifyStateListValueInDictionary() throws {
        for stateName in K.states {
            XCTAssertNotNil(K.statesDictionary[stateName])
        }
    }
}
