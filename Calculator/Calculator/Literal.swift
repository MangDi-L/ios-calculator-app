//
//  Literal.swift
//  Calculator
//
//  Created by Mangdi on 2022/09/28.
//

import Foundation

enum Literal {
    case numberOne
    case numberZero
    case numberDoubleZero
    case numberPoint
    case ac
    case ce
    case nan
    case numberInvertion
    case division
    case add
    case multiplication
    case subtraction
    case result
    case invertSign
    case invertSymbol
    case infinity
    case comma
    case point
    case realDivision
    case realMultiplication
    
    var value: String {
        switch self {
        case .numberOne:
            return "1"
        case .numberZero:
            return "0"
        case .numberDoubleZero:
            return "00"
        case .numberPoint:
            return "."
        case .ac:
            return "AC"
        case .ce:
            return "CE"
        case .numberInvertion:
            return "0"
        case .division:
            return "÷"
        case .multiplication:
            return "ⅹ"
        case .subtraction:
            return "-"
        case .add:
            return "+"
        case .result:
            return "="
        case .nan:
            return "NaN"
        case .infinity:
            return "+∞"
        case .invertSign:
            return "-"
        case .comma:
            return ","
        case .point:
            return "."
        case .realDivision:
            return "/"
        case .realMultiplication:
            return "*"
        case .invertSymbol:
            return "⁺⁄₋"
        }
    }
}
