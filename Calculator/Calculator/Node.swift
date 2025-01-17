//
//  NodeItem.swift
//  Calculator
//
//  Created by Mangdi on 2022/09/20.
//

import Foundation

class Node<T> {
    var data: T?
    var next: Node?
    
    init(data: T?, next: Node? = nil) {
        self.data = data
        self.next = next
    }
}
