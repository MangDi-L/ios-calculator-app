//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var inputNumberLabel: UILabel!
    @IBOutlet weak private var inputOperatorLabel: UILabel!
    @IBOutlet weak private var historyInputOperatorLabel: UILabel!
    @IBOutlet weak private var historyInputNumberLabel: UILabel!
    @IBOutlet weak private var historyInputStackView: UIStackView!
    @IBOutlet weak private var historyInputScrollView: UIScrollView!
    
    let numberFormatter = NumberFormatter()
    
    private var formula = Formula(operands: CalculatorItemQueue<Double>(), operators: CalculatorItemQueue<Operator>())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumSignificantDigits = 20
    }
    
    private func autoSlideScrollView() {
        let bottomOffset = CGPoint(x: 0, y: historyInputScrollView.contentSize.height - self.historyInputScrollView.bounds.height)
        historyInputScrollView.layoutIfNeeded()
        historyInputScrollView.setContentOffset(bottomOffset, animated: false)
    }
    
    private func addZero(inputText: String, zero: String) {
        if inputText == Literal.numberZero.value {
            return
        } else {
            let numberWithOutComma = inputText.replacingOccurrences(of: ",", with: "")
            if let number: Double = Double(numberWithOutComma + zero) {
                inputNumberLabel.text = numberFormatter.string(for: number)
            }
        }
    }
    
    private func addPoint(inputText: String, point: Character) {
        if inputText.filter({ $0 == point }).count >= 1 {
            return
        } else {
            inputNumberLabel.text = inputText + String(point)
        }
    }
    
    private func addNumber(inputText: String, number: String) {
        if inputText == Literal.numberZero.value {
            inputNumberLabel.text = "\(number)"
        } else {
            let numberWithOutComma = inputText.replacingOccurrences(of: ",", with: "")
            if let number: Double = Double(numberWithOutComma + number) {
                inputNumberLabel.text = numberFormatter.string(for: number)
            }
        }
    }
    
    private func makeHistoryInputLabel(inputText: String) -> UILabel {
        var inputLabel: UILabel {
            let inputLabel = UILabel()
            
            inputLabel.text = inputText
            inputLabel.textColor = UIColor.white
            inputLabel.translatesAutoresizingMaskIntoConstraints = false
            return inputLabel
        }
        
        return inputLabel
    }
    
    private func makeHistoryStactView(operatorLabel: UILabel, operandLabel: UILabel) -> UIStackView {
        var stackView: UIStackView {
            let stackView = UIStackView()
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 8
            stackView.addArrangedSubview(operatorLabel)
            stackView.addArrangedSubview(operandLabel)
            return stackView
        }
        
        return stackView
    }
    
    private func insertIntoQueue(operatorValue: String, inputText: String) {
        let someOperator: Operator
        
        switch operatorValue {
        case "+":
            someOperator = .add
        case "-":
            someOperator = .subtract
        case "ⅹ":
            someOperator = .multiply
        case "÷":
            someOperator = .divide
        default:
            return
        }
        
        if let doubleValue = Double(inputText) {
            formula.operands?.enqueue(doubleValue)
            formula.operators?.enqueue(someOperator)
        }
    }
    
    private func insertIntoOperatorQueue(operatorValue: String) -> Operator? {
        let someOperator: Operator?
        
        switch operatorValue {
        case "+":
            someOperator = .add
        case "-":
            someOperator = .subtract
        case "ⅹ":
            someOperator = .multiply
        case "÷":
            someOperator = .divide
        default:
            return nil
        }
        
        return someOperator
    }
    
    private func addStackView(operatorText: String, inputText: String) {
        let operatorLabel = makeHistoryInputLabel(inputText: operatorText)
        let operandLabel = makeHistoryInputLabel(inputText: inputText)
        let stackView = makeHistoryStactView(operatorLabel: operatorLabel, operandLabel: operandLabel)
        historyInputStackView.addArrangedSubview(stackView)
        autoSlideScrollView()
    }
    
    private func addOperator(inputText: String, operatorValue: String) {
        let numberWithOutComma = inputText.replacingOccurrences(of: ",", with: "")
        
        if numberWithOutComma == Literal.numberZero.value && inputOperatorLabel.text == "" {
            return
        } else if numberWithOutComma == Literal.numberZero.value && operatorValue != "" {
            inputOperatorLabel.text = operatorValue
            
            guard let operatorText = inputOperatorLabel.text,
                  let getOperator = insertIntoOperatorQueue(operatorValue: operatorText) else {
                return
            }
            
            _ = formula.operators?.dequeue()
            formula.operators?.enqueue(getOperator)
            return
        } else {
            guard let operatorText = inputOperatorLabel.text else {
                return
            }
            
            addStackView(operatorText: operatorText, inputText: inputText)
            insertIntoQueue(operatorValue: operatorValue, inputText: numberWithOutComma)
            
            inputNumberLabel.text = Literal.numberZero.value
            inputOperatorLabel.text = operatorValue
        }
    }
    
    private func showResult(inputText: String) {
        if ((formula.operators?.isEmpty()) == true) {
            return
        }
        
        let numberWithOutComma = inputText.replacingOccurrences(of: ",", with: "")
        
        if let operandValue = Double(numberWithOutComma),
           let operatorText = inputOperatorLabel.text {
            formula.operands?.enqueue(operandValue)
            addStackView(operatorText: operatorText, inputText: inputText)
        }
        
        if let result = numberFormatter.string(for: formula.result()) {
            inputNumberLabel.text = String(result)
            inputOperatorLabel.text = ""
        }
    }
    
    private func invertNumber(inputText: String) {
        if inputText == Literal.numberZero.value { return }
        
        if inputText.prefix(1) != Literal.subtraction.value {
            inputNumberLabel.text = Literal.subtraction.value + inputText
        } else {
            inputNumberLabel.text = inputText.replacingOccurrences(of: "-", with: "")
        }
    }
    
    private func deleteAllHistory() {
        formula.operands?.allDelete()
        formula.operators?.allDelete()
        inputOperatorLabel.text = ""
        inputNumberLabel.text = Literal.numberZero.value
        
        for view in historyInputStackView.subviews {
            view.removeFromSuperview()
        }
    }
    
    @IBAction private func touchUpCalculatorButton(sender: UIButton) {
        guard let id = sender.restorationIdentifier,
              let inputText = inputNumberLabel.text else {
            return
        }
        
        switch id {
        case Literal.AC.buttonID:
            deleteAllHistory()
        case Literal.CE.buttonID:
            inputNumberLabel.text = Literal.numberZero.value
        case Literal.numberInvertion.buttonID:
            invertNumber(inputText: inputText)
        case Literal.division.buttonID:
            addOperator(inputText: inputText, operatorValue: Literal.division.value)
        case Literal.multiplication.buttonID:
            addOperator(inputText: inputText, operatorValue: Literal.multiplication.value)
        case Literal.subtraction.buttonID:
            addOperator(inputText: inputText, operatorValue: Literal.subtraction.value)
        case Literal.addition.buttonID:
            addOperator(inputText: inputText, operatorValue: Literal.addition.value)
        case Literal.result.buttonID:
            showResult(inputText: inputText)
        default:
            return
        }
    }
    
    @IBAction private func touchUpNumberButton(sender: UIButton) {
        guard let id = sender.restorationIdentifier,
              let inputText = inputNumberLabel.text else {
            return
        }
        
        switch id {
        case Literal.numberDoubleZero.buttonID:
            addZero(inputText: inputText , zero: Literal.numberDoubleZero.value)
        case Literal.numberZero.buttonID:
            addZero(inputText: inputText, zero: Literal.numberZero.value)
        case Literal.numberPoint.buttonID:
            addPoint(inputText: inputText, point: Character(Literal.numberPoint.value))
        case Literal.numberOne.buttonID:
            addNumber(inputText: inputText, number: Literal.numberOne.value)
        case Literal.numberTwo.buttonID:
            addNumber(inputText: inputText, number: Literal.numberTwo.value)
        case Literal.numberThree.buttonID:
            addNumber(inputText: inputText, number: Literal.numberThree.value)
        case Literal.numberFour.buttonID:
            addNumber(inputText: inputText, number: Literal.numberFour.value)
        case Literal.numberFive.buttonID:
            addNumber(inputText: inputText, number: Literal.numberFive.value)
        case Literal.numberSix.buttonID:
            addNumber(inputText: inputText, number: Literal.numberSix.value)
        case Literal.numberSeven.buttonID:
            addNumber(inputText: inputText, number: Literal.numberSeven.value)
        case Literal.numberEight.buttonID:
            addNumber(inputText: inputText, number: Literal.numberEight.value)
        case Literal.numberNine.buttonID:
            addNumber(inputText: inputText, number: Literal.numberNine.value)
        default:
            return
        }
    }
}
