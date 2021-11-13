//
//  ExpressionParserTest.swift
//  CalculatorTests
//
//  Created by Seul Mac on 2021/11/12.
//

import XCTest

class ExpressionParserTest: XCTestCase {
    
    func test_정수_2개_add연산자_1개인_배열_2개_숫자분리() {
        let testAry = ["2+3", "12+466"]
        let result = componentsByOneOperator(input: testAry, sign: Operator.add.rawValue)
        XCTAssertEqual(result, ["2", "3", "12", "466"])
    }
    
    func test_정수_2개_subtract연산자_1개인_배열_2개_숫자분리() {
        let testAry = ["2_3", "12_466"]
        let result = componentsByOneOperator(input: testAry, sign: Operator.subtract.rawValue)
        XCTAssertEqual(result, ["2", "3", "12", "466"])
    }

    func test_정수_2개_divide연산자_1개인_배열_2개_숫자분리() {
        let testAry = ["2/3", "12/466"]
        let result = componentsByOneOperator(input: testAry, sign: Operator.divide.rawValue)
        XCTAssertEqual(result, ["2", "3", "12", "466"])
    }
    
    func test_정수_2개_multiply연산자_1개인_배열_2개_숫자분리() {
        let testAry = ["2×3", "12×466"]
        let result = componentsByOneOperator(input: testAry, sign: Operator.multiply.rawValue)
        XCTAssertEqual(result, ["2", "3", "12", "466"])
    }
    
}
