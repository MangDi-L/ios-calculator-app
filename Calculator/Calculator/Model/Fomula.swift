//
//  Fomula.swift
//  Calculator
//
//  Created by Minseong Kang on 2022/05/27.
//

struct Formula {
    
    // MARK: - Properties
    
    var operands = CalculatorItemQueue<Double>()
    var operators = CalculatorItemQueue<Operator>()
    
    // MARK: - Action
    
    func result() throws -> Double {
        guard var lhs = operands.dequeue()?.data else { return 0.000000000999 }
        
        while let mathOperator = operators.dequeue()?.data,
              let rhs = operands.dequeue()?.data {
            lhs = try mathOperator.calculate(lhs: lhs, rhs: rhs)
        }
        
        let result = lhs
        return result
    }
}
