//
//  CalculatorItemQueue.swift
//  Calculator
//
//  Created by 김태현 on 2022/03/14.
//

struct Oprator {
    static let addition = "+"
    static let subtraction = "-"
    static let devision = "/"
    static let multiplication = "*"
}

enum CalculatorItem {
    case numbers(Double)
    case `operator`(Oprator)
}

struct CalculatorItemQueue {
    var queue: [CalculatorItem]
    var front: Int
    var rear: Int
    
    init(queue: [CalculatorItem] = [], front: Int = -1, rear: Int = -1) {
        self.queue = queue
        self.front = front
        self.rear = rear
    }
}
