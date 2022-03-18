//
//  LinkedListQueue.swift
//  Calculator
//
//  Created by 김동욱 on 2022/03/17.
//

import Foundation

class Node<Element: CalculateItem> {
    var value: Element?
    var next: Node<Element>?
    
    init(value: Element?, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

struct LinkedQueue<Element: CalculateItem> {
    private var head: Node<Element>?
    private var tail: Node<Element>?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    var first: Node<Element>? {
        return head
    }
    
    var last: Node<Element>? {
        return tail
    }
    
    mutating func append(newNode: Element?) {
        if head == nil {
            head = Node(value: newNode)
            tail = head
            return
        }
        
        tail?.next = Node(value: newNode)
        tail = tail?.next
    }
    
    mutating func removeFirst() -> Node<Element>? {
        if head == nil {
            return nil
        }
        
        defer {
            let nextHead = head?.next
            head = nil
            head = nextHead
        }
        return head
    }
    
    mutating func removeAll() {
        head = nil
        tail = nil
    }
}
