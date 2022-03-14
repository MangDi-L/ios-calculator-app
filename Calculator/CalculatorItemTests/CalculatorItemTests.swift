//
//  CalculatorItemTests.swift
//  CalculatorItemTests
//
//  Created by 김태현 on 2022/03/14.
//

import XCTest
@testable import Calculator

class CalculatorItemTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_다른케이스끼리비교했을때_false나오는지() {
        let integer = CalculatorItem.integer(10)
        let double = CalculatorItem.double(10.0)
        let `operator` = CalculatorItem.operator(.addition)
        
        XCTAssertFalse(integer == double)
        XCTAssertFalse(integer == `operator`)
        XCTAssertFalse(double == `operator`)
    }

}
