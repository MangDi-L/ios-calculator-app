//
//  ExpressionParser.swift
//  Calculator
//
//  Created by 허건 on 2022/05/19.
//
import Foundation

enum ExpressionParser {
    
    static func parse(from input: String) -> Formula {
        let splitElements = componentsByOperators(from: input)
        var operandQueue = CalculatorItemQueue<Double>()
        var operatorQueue = CalculatorItemQueue<Operator>()
        
        splitElements.compactMap {Double($0)}
            .forEach {
                operandQueue.enqueue($0)
            }

        splitElements.compactMap {Character($0)}
            .forEach {
            if let operatorElements = Operator(rawValue: $0) {
                operatorQueue.enqueue(operatorElements)
            }
        }
        
        return Formula(operands: operandQueue, operators: operatorQueue)
    }

    static func componentsByOperators(from input: String) -> [String] {
        return input.split(with: " ")
    }
}
