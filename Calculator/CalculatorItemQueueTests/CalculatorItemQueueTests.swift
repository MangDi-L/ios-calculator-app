//
//  CalculatorItemQueueTests.swift
//  CalculatorItemQueueTests
//
//  Created by Minseong Kang on 2022/05/18.
//

import XCTest
@testable import Calculator

class CalculatorItemQueueTests: XCTestCase {
    // MARK: - Properties
    
    var sut: CalculatorItemQueue<Double>!
    
    // MARK: - Action
    
    override func setUpWithError() throws {
        sut = CalculatorItemQueue()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - enqueue(_:)
    
    func test_enqueue의아규먼트로_0을_넣었을때_queue가빈배열이면_False() {
        // given
        let number = 0.0
        
        // when
        sut.enqueue(number)
        let result = sut.queue.isEmpty()
        
        // then
        XCTAssertFalse(result)
    }
    
    func test_enqueue의아규먼트로_0을_넣었을때_queue에_0이있으면_True() {
        // given
        let number = 0.0
        
        // when
        sut.enqueue(number)
        let result = sut.queue.head
        
        // then
        XCTAssertEqual(result?.data, number)
    }
    
    // MARK: - dequeue()
        
    func test_queue가_빈배열일때_dequeue호출시_nil을_반환하는지() {
        // given
        // sut의 초기화시 queue는 빈 배열이 되므로 생략
        
        // when
        let result = sut.dequeue()
        
        // then
        XCTAssertNil(result)
    }
    
    func test_queue의_요소가_여러개일때_dequeue호출시_첫번째요소를_리턴하는지() {
        // given
        let firstNumber = 1.0
        sut.enqueue(firstNumber)
        sut.enqueue(2.0)
        sut.enqueue(3.0)
        
        // when
        let result = sut.dequeue()
        
        // then
        XCTAssertEqual(firstNumber, result?.data)
    }
}
