//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by 본프, 수꿍 on 2022/05/16.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    var sutOperand: Queue<Double>!
    var sutOperator: Queue<Operator>!
    var formula: Formula!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sutOperand = Queue<Double>()
        sutOperator = Queue<Operator>()
        formula = Formula(operand: [], operator: [])
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sutOperand = nil
        sutOperator = nil
        formula = nil
    }
    
    func test_enqueue를안했을때_isEmpty가_참인지확인() {
        let result = sutOperand.isEmpty
        XCTAssertTrue(result)
    }
    
    func test_enqueue했을때_isEmpty가_거짓인지확인() {
        sutOperand.enqueue(1)
        let result = sutOperand.isEmpty
        XCTAssertFalse(result)
    }

    func test_Enqueue를여러번했을때_count값이_같은지확인() {
        sutOperand.enqueue(1)
        sutOperand.enqueue(2)
        sutOperand.enqueue(5)
        let result = sutOperand.count
        XCTAssertEqual(result, 3)
    }

    func test_enqueue를여러번했을때_dequeue를하면_count가맞는지확인() {
        sutOperand.enqueue(1)
        sutOperand.enqueue(2)
        sutOperand.enqueue(3)
        _ = sutOperand.dequeue()
        let result = sutOperand.count
        XCTAssertEqual(result, 2)
    }

    func test_enqueue를여러번했을때_dequeue를하면_반환값이같은지확인() {
        sutOperand.enqueue(1)
        sutOperand.enqueue(2)
        sutOperand.enqueue(3)
        let result = sutOperand.dequeue()
        XCTAssertEqual(result, 1)
    }

    func test_enqueue를하지않았을때_dequeue를하면_nil이나오는지확인() {
        let a = sutOperand.dequeue()
        XCTAssertEqual(nil, a)
    }

    func test_값이들어있을때_removeAll을하면_count가0인지확인() {
        sutOperand.enqueue(1)
        sutOperand.enqueue(2)
        sutOperand.enqueue(3)
        sutOperand.clear()
        let result = sutOperand.count
        XCTAssertEqual(result, 0)
    }

    func test_값이들어있을때_removeAll을하면_isEmpty가참인지확인() {
        sutOperand.enqueue(1)
        sutOperand.enqueue(2)
        sutOperand.enqueue(3)
        sutOperand.clear()
        let result = sutOperand.isEmpty
        XCTAssertTrue(result)
    }

    func test_값이들어있을때_dequeue로queue를비웠을때_count값과nil값이나오는지확인() {
        sutOperand.enqueue(1)
        sutOperand.enqueue(2)
        let result = sutOperand.peek
        XCTAssertEqual(result, 1)
        _ = sutOperand.dequeue()
        let result1 = sutOperand.peek
        XCTAssertEqual(result1, 2)
        _ = sutOperand.dequeue()
        let result2 = sutOperand.peek
        XCTAssertEqual(result2, nil)
        sutOperand.enqueue(5)
        let result3 = sutOperand.peek
        XCTAssertEqual(result3, 5)
        _ = sutOperand.dequeue()
        let result4 = sutOperand.peek
        XCTAssertEqual(result4, nil)
        let result5 = sutOperand.count
        XCTAssertEqual(result5, 0)
    }

    func test_피연산수가하나일때_오류로_던져지는지_확인() {
        //given
        //when
        var result = ExpressionParser.parse(from: "123")
        //then
        XCTAssertThrowsError(try result.result())
    }

    func test_입력이들어왔을때_함수를실행하면_연산자와더블로잘나뉘는지확인() {
        //given
        let input = "123 + 321 ÷ 12"
        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertEqual(try result.result(), 37.0)
    }

    func test_연산할때_음수가있을경우_계산이잘되는지확인() {
        //given
        let input = "-123 + -321 + 0"
        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertEqual(try result.result(), -444.0)
    }

    func test_나누기할때_나누는값이0일경우_오류처리가되는지확인() {
        //given
        let input = "123 + 321 ÷ 0"

        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertThrowsError(try result.result())
    }

    func test_나누기할때_음수0으로나눌경우경우_계산이잘되는지확인() {
        //given
        let input = "-123 + -321 ÷ -0"
        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertThrowsError(try result.result())
    }

    func test_연산할때_연산자와숫자가안맞을경우_오류처리가되는지확인() {
        //given
        let input = "-123 + + -321 ÷ -0"
        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertThrowsError(try result.result())
    }

    func test_연산할때_operand가0이많은경우_값이잘나오는지() {
        //given
        let input = "-0 + 0 × 0 − -0 + 10"
        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertEqual(try result.result(), 10.0)
    }

    func test_계산할때_결과값의소수점이많이나올경우_어떻게하나1() {
        let input = "-20 ÷ 19"
        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertEqual(try result.result(), -1.05263157894736836262)
    }

    func test_계산할때_결과값의소수점이많이나올경우_어떻게하나2() {
        let input = "-1 ÷ 3"
        //when
        var result = ExpressionParser.parse(from: input)
        //then
        XCTAssertEqual(try result.result(), -0.33333333333333333332)
    }

    func test_enqueue_양의_실수가_순서대로_들어가는지_테스트() throws {
        // given
        let input1: Double = 1
        let input2: Double = 9999
        sutOperand.enqueue(input1)
        sutOperand.enqueue(input2)
        
        // when
        let result1 = sutOperand.dequeue()
        let result2 = sutOperand.dequeue()
        
        // then
        XCTAssertEqual(result1, input1)
        XCTAssertEqual(result2, input2)
    }


    func test_enqueue_0과_음의실수가_순서대로_들어가는지_테스트() throws {
        // given
        let input1: Double = 0
        let input2: Double = -9999
        sutOperand.enqueue(input1)
        sutOperand.enqueue(input2)

        // when
        let result1 = sutOperand.dequeue()
        let result2 = sutOperand.dequeue()

        // then
        XCTAssertEqual(result1, input1)
        XCTAssertEqual(result2, input2)
    }

    func test_enqueue_중복된_실수가_제대로_들어가는지_테스트() throws {
        // given
        let input1 = 1.0
        let input2 = 2.0
        let input3 = 2.0
        sutOperand.enqueue(input1)
        sutOperand.enqueue(input2)
        sutOperand.enqueue(input3)

        // when
        let result1 = sutOperand.dequeue()
        let result2 = sutOperand.dequeue()
        let result3 = sutOperand.dequeue()

        // then
        XCTAssertEqual(result1, input1)
        XCTAssertEqual(result2, input2)
        XCTAssertEqual(result3, input3)
    }

    func test_enqueue_1000개의_실수가_순서대로_들어가는지_테스트() throws {
        // given
        var expectation: [Double] = []

        for input in 0...999 {
            expectation.append(Double(input))
            sutOperand.enqueue(Double(input))
        }

        // when
        var result: Double?

        // then
        for i in 0...999 {
            result = sutOperand.dequeue()
            XCTAssertEqual(result, expectation[i])
        }
    }

    func test_isEmpty_빈_큐임을_정상적으로_인지하는지_테스트() throws {
        // given
        sutOperand.clear()

        // when
        let result = sutOperand.isEmpty

        // then
        XCTAssertTrue(result)
    }

    func test_isEmpty_enqueue_메서드가_호출될때_비어있지_않은_배열로_인지하는지_테스트() throws {
        // given
        sutOperand.enqueue(1.0)

        // when
        let result = sutOperand.isEmpty

        // then
        XCTAssertFalse(result)
    }

    func test_dequeue_실수가_순서대로_제거되는지_테스트() throws {
        // given
        sutOperand.enqueue(1.0)
        sutOperand.enqueue(2.0)
        let expectation1 = 1.0
        let expectation2 = 2.0

        // when
        let result1 = sutOperand.dequeue()
        let result2 = sutOperand.dequeue()

        // then
        XCTAssertEqual(result1, expectation1)
        XCTAssertEqual(result2, expectation2)
    }

    func test_peek_peek를_정상적으로_반환하는지_테스트() throws {
        // given
        sutOperand.enqueue(1.0)
        sutOperand.enqueue(2.0)
        let expectaion = 1.0

        // when
        let result = sutOperand.peek

        // then
        XCTAssertEqual(result, expectaion)
    }


    func test_peek_dequeue_메서드_호출시_peek를_정상적으로_반환하는지_테스트() throws {
        // given
        sutOperand.enqueue(1.0)
        sutOperand.enqueue(2.0)
        _ = sutOperand.dequeue()
        let expectaion = 2.0

        // when
        let result = sutOperand.peek

        // then
        XCTAssertEqual(result, expectaion)
    }
}
