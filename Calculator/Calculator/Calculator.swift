import Foundation


protocol CalculateItem {
    
}

class CalculatorItemQueue<Element>: LinkedListManager<Element>, CalculateItem {
    func insertToQueue(_ insertValue: Element) {
        super.addNewNode(insertValue)
    }
    
    func deleteFromQueue() {
        guard self.head?.nodeValue != nil else { return }
        super.deleteFirstNode()
    }
}

class Node<Element> {
    let nodeValue: Element
    var pointer: Node?
    
    init(_ nodeValue: Element, pointer: Node? = nil) {
        self.nodeValue = nodeValue
        self.pointer = pointer
    }
}
    
class LinkedListManager<Element> {
    var head: Node<Element>?
    
    init(head: Node<Element>?) {
        self.head = head
    }
    
    func addNewNode(_ nodeValue: Element) {
        if head == nil {
            head = Node(nodeValue)
            return
        }
        var finderToLastNode: Node<Element>? = head
        while finderToLastNode?.pointer != nil {
            finderToLastNode = finderToLastNode?.pointer
        }
        finderToLastNode?.pointer = Node(nodeValue)
    }
    
    func deleteFirstNode() {
        head = head?.pointer
    }
}
