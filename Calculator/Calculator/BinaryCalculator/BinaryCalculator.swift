//
//  BinaryCalculator.swift
//  Calculator
//
//  Created by Yeon on 2020/12/07.
//

import Foundation

class BinaryCalculator {
    var postfixStack: Stack = Stack<String>()
    var calculateStack: Stack = Stack<String>()
    let scale: Int = 2
    let binaryOperator = BinaryOperatorType.allCases
    lazy var binaryOperators = binaryOperator.map({ (`operator`: BinaryOperatorType) -> String in
        return `operator`.rawValue
    })
    init() {}
    
    private func precedence(_ binaryOperator: BinaryOperatorType) -> Int {
        let highPrecedence: BinaryOperatorPrecedence = .high
        let midPrecedence: BinaryOperatorPrecedence = .mid
        let lowPrecedence: BinaryOperatorPrecedence = .low
        
        switch binaryOperator {
        case .NOT, .RightShift, .LeftShift:
            return highPrecedence.rawValue
        case .AND, .NAND:
            return midPrecedence.rawValue
        case .XOR, .NOR, .OR, .minus, .plus:
            return lowPrecedence.rawValue
        }
    }
    
    private func transformToPostfix(_ infix: [String]) throws -> [String] {
        var postfix = [String]()
        for element in infix {
            if binaryOperators.contains(element) {
                guard !postfixStack.isEmpty else {
                    postfixStack.push(element)
                    continue
                }
                guard let top = postfixStack.peek() else {
                    throw CalculatorError.stackIsEmpty
                }
                var stackTopOperatorType = try getOperatorType(of: top)
                let currentOperatorType = try getOperatorType(of: element)
                while(!postfixStack.isEmpty && precedence(stackTopOperatorType) >= precedence(currentOperatorType)) {
                    guard let top = postfixStack.pop() else {
                        throw CalculatorError.stackIsEmpty
                    }
                    postfix.append(top)
                    if let topAfterPop = postfixStack.peek() {
                        stackTopOperatorType = try getOperatorType(of: topAfterPop)
                    }
                }
                postfixStack.push(element)
            } else {
                postfix.append(element)
            }
        }
        while !postfixStack.isEmpty {
            if let top = postfixStack.pop() {
                postfix.append(top)
            }
        }
        
        return postfix
    }
    
    func calculate(_ infix: [String]) throws -> String {
        let formula: [String] = try transformToPostfix(infix)
        for element in formula {
            if binaryOperators.contains(element) {
                let currentOperatorType = try getOperatorType(of: element)
                if element == BinaryOperatorType.NOT.rawValue {
                    if let firstNum = calculateStack.pop() {
                        calculateStack.push(try not(first: firstNum))
                    }
                } else if element == BinaryOperatorType.RightShift.rawValue {
                    if let firstNum = calculateStack.pop() {
                        calculateStack.push(try rightShift(first: firstNum))
                    }
                } else if element == BinaryOperatorType.LeftShift.rawValue {
                    if let firstNum = calculateStack.pop() {
                        calculateStack.push(try leftShift(first: firstNum))
                    }
                } else {
                    if let secondNum = calculateStack.pop(),
                       let firstNum = calculateStack.pop() {
                        switch currentOperatorType {
                        case .plus:
                            calculateStack.push(try add(first: firstNum, second: secondNum))
                        case .minus:
                            calculateStack.push(try subtract(first: firstNum, second: secondNum))
                        case .AND:
                            calculateStack.push(try and(first: firstNum, second: secondNum))
                        case .OR:
                            calculateStack.push(try or(first: firstNum, second: secondNum))
                        case .XOR:
                            calculateStack.push(try xor(first: firstNum, second: secondNum))
                        case .NOR:
                            calculateStack.push(try nor(first: firstNum, second: secondNum))
                        case .NAND:
                            calculateStack.push(try nand(first: firstNum, second: secondNum))
                        case .LeftShift:
                            throw CalculatorError.unknown
                        case .RightShift:
                            throw CalculatorError.unknown
                        case .NOT:
                            throw CalculatorError.unknown
                        }
                    }
                }
            }
            else {
                calculateStack.push(element)
            }
        }
        guard let result = calculateStack.pop() else {
            throw CalculatorError.unknown
        }
        
        return result
    }
    
    private func getOperatorType(of binaryOperator: String) throws -> BinaryOperatorType {
        guard let operatorType = BinaryOperatorType(rawValue: binaryOperator) else {
            throw CalculatorError.notDefinedOperator
        }
        return operatorType
    }
    
    private func stringNumberToIntNumber(_ stringNumber: String) throws -> Int {
        guard let intNumber = Int(stringNumber, radix: scale) else {
            throw CalculatorError.unknown
        }
        return intNumber
    }
}

extension BinaryCalculator: BasicCalculable {
    func add(first: String, second: String) throws -> String {
        var result: Int
        result = try stringNumberToIntNumber(first) + stringNumberToIntNumber(second)
        return String(result, radix: scale)
    }
    
    func subtract(first: String, second: String) throws -> String {
        var result: Int
        result = try stringNumberToIntNumber(first) - stringNumberToIntNumber(second)
        return String(result, radix: scale)
    }
    
    func clear() {
        postfixStack.removeAll()
        calculateStack.removeAll()
    }
}

extension BinaryCalculator: BinaryCalculable {
    func and(first: String, second: String) throws -> String {
        var result: Int
        result = try stringNumberToIntNumber(first) & stringNumberToIntNumber(second)
        return String(result, radix: scale)
    }
    
    func or(first: String, second: String) throws -> String {
        var result: Int
        result = try stringNumberToIntNumber(first) | stringNumberToIntNumber(second)
        return String(result, radix: scale)
    }
    
    func xor(first: String, second: String) throws -> String {
        var result: Int
        result = try stringNumberToIntNumber(first) ^ stringNumberToIntNumber(second)
        return String(result, radix: scale)
    }
    
    func nor(first: String, second: String) throws -> String {
        var result: Int
        result = try ~(stringNumberToIntNumber(first) | stringNumberToIntNumber(second))
        return String(result, radix: scale)
    }
    
    func not(first: String) throws -> String {
        var result: Int
        result = try ~stringNumberToIntNumber(first)
        return String(result, radix: scale)
    }
    
    func nand(first: String, second: String) throws -> String {
        var result: Int
        result = try ~(stringNumberToIntNumber(first) & stringNumberToIntNumber(second))
        return String(result, radix: scale)
    }
    
    func rightShift(first: String) throws -> String {
        var result: Int
        result = try stringNumberToIntNumber(first) >> 1
        return String(result, radix: scale)
    }
    
    func leftShift(first: String) throws -> String {
        var result: Int
        result = try stringNumberToIntNumber(first) << 1
        return String(result, radix: scale)
    }
}
