//
//  ExpressionParserTests.swift
//  CalculatorTests
//
//  Created by Ari on 2021/11/11.
//

import XCTest


enum ExpressionParser {
    static func parse(from input: String) -> Formula {
        let operands = componentsByOperators(from: input)
                        .compactMap{ Double($0) }
        let operators = input.map{ $0 }
                        .compactMap{ Operator(rawValue: $0) }
        return Formula(operands: CalculatorItemQueue(operands),
                       operators: CalculatorItemQueue(operators))
    }
    
    private static func componentsByOperators(from input: String) -> [String] {
        let sliceInputValue = input.split()
        let operands = sliceInputValue.filter { Double($0.description) != nil }
        return operands
    }
}

class ExpressionParserTests: XCTestCase {

    func test_연산자와숫자가_한개씩() {
        let input = ExpressionParser.parse(from: "12 + !@#")

        XCTAssertTrue(input.operands.count == 1)
        XCTAssertTrue(input.operators.count == 1)
    }
    
    func test_연산자와숫자가_두개씩() {
        let input = ExpressionParser.parse(from: "12 + 12 + !@#$")

        XCTAssertTrue(input.operators.count == 2)
        XCTAssertTrue(input.operators.count == 2)
    }
    
    func test_연산자와숫자가_세개씩() {
        let input = ExpressionParser.parse(from: "12.123 + 12 + 12 + ")
        
        XCTAssertTrue(input.operands.count == 3)
        XCTAssertTrue(input.operators.count == 3)
    }
    
    func test_연산자와숫자가_두개세개() {
        let input = ExpressionParser.parse(from: "12 + 12.123 + 12")
        
        XCTAssertTrue(input.operands.count == 3)
        XCTAssertTrue(input.operators.count == 2)
    }
    
    func test_연산자와숫자가_네개다섯개() {
        let input = ExpressionParser.parse(from: "12 + 12 + 12 + 12.123123123 + 12")
        
        XCTAssertTrue(input.operands.count == 5)
        XCTAssertTrue(input.operators.count == 4)
    }
}
