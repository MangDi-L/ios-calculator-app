//
//  Formula.swift
//  Calculator
//
//  Created by 유한석 on 2022/05/19.
//
struct Formula {
    var operands: CalculatorItemQueue
    var operators: CalculatorItemQueue
    
    mutating func result() -> Double {
        guard var lhs = operands.deQueue()?.value as? Double else {
            return 0.0
        }
        while operators.count > 0, operands.count > 0 {
            guard let calcOperator = operators.deQueue()?.value as? Operator else {
                return lhs
            }
            guard let rhs = operands.deQueue()?.value as? Double else {
                return lhs
            }
            do {
                try lhs = calcOperator.calculate(lhs: lhs, rhs: rhs)
            } catch CalculatorError.divideByZero {
                debugPrint("CalculatorError.divideByZero")
            } catch {
                debugPrint("Unknown Error")
            }
        }
        return lhs
    }
}




