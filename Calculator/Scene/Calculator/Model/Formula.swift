//
//  Formula.swift
//  Calculator
//
//  Created by 이은찬 on 2022/05/19.
//
struct Formula {
    var operands = Queue<Double>()
    var operators = Queue<Operator>()
    
    func result() -> Double {
        var lhs: Double = 0.0
        while operands.isEmpty == false {
            if lhs == 0.0 {
                lhs = operands.dequeue() ?? 0.0
            }
            let rhs = operands.dequeue() ?? 0.0
            let `operator` = operators.dequeue()
            lhs = (`operator`?.calculate(lhs: lhs, rhs: rhs)) ?? 0.0
        }
        return lhs
    }
}
