import Foundation

protocol CalculateItem {
    
}

class Node<T> {
    let value: T
    var pointer: Node?
    
    init(value: T, pointer: Node? = nil) {
        self.value = value
        self.pointer = pointer
    }
}
    
class LinkedListManager<T> {
    var head: Node<T>?
    
    init(head: Node<T>?) {
        self.head = head
    }
    
    func addNewNode(value: T) {
        if head == nil {
            head = Node(value: value)
            return
        }
        var finderToLastNode: Node<T>? = head
        while finderToLastNode?.pointer != nil {
            finderToLastNode = finderToLastNode?.pointer
            
        }
        finderToLastNode?.pointer = Node(value: value)
    }
    
    func deleteFirstNode() {
        head = head?.pointer
    }
}

class CalculatorItemQueue<T>: LinkedListManager<T>, CalculateItem {
    func putToQueue(_ value: T) {
        addNewNode(value: value)
    }
    
    func getFromQueue() {
        guard self.head?.value != nil else { return }
        deleteFirstNode()
    }
}

