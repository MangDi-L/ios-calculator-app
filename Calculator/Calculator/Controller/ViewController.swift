//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var processScrollView: UIScrollView!
    @IBOutlet weak var processVerticalStackView: UIStackView!
    @IBOutlet weak var operandLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    
    var currentOperand: String = ""
    var currentOperator: String = ""
    var completeFormula: String = ""
    var isCalculationOver: Bool = false

    var isLastOperator: Bool = false
    var isLastDot: Bool = false
    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetCalculator()
    }
    
    func resetCalculator() {
        resetOperand()
        operatorLabel.text = ""
        currentOperator = ""
        completeFormula = ""
        isCalculationOver = false
        
        clearCalculationProcess()
    }
    
    func resetOperand() {
        operandLabel.text = "0"
        currentOperand = ""
    }
    
    func changeNumberFormat(of number: Double) -> String? {
        numberFormatter.maximumFractionDigits = 20
        numberFormatter.numberStyle = .decimal
        
        guard let resultInString = numberFormatter.string(from: NSNumber(value: number)) else { return nil }
        
        return resultInString
    }
    
    func refreshLabelsWithResult(of formula: String) {
        var formula: Formula = ExpressionParser.parse(from: formula)
        
        do {
            let calculationResult: Double = try formula.result()
            guard let resultInString = changeNumberFormat(of: calculationResult) else { return }
            
            operandLabel.text = "\(resultInString)"
            operatorLabel.text = ""
        } catch CalculatorError.dividedByZero {
            operandLabel.text = "\(CalculatorError.dividedByZero.description)"
            operatorLabel.text = ""
        } catch {
            print(error)
        }
    }
      
    func addCalculationProcessWithHorizontalStackView() {        
        let operatorProcessLabel = ProcessLabel(text: currentOperator)
        let operandProcessLabel = ProcessLabel(text: currentOperand)
        
        let horizontalStackView = ProcessHorizontalStackView(lhsLabel: operatorProcessLabel, rhsLebel: operandProcessLabel)
                
        processVerticalStackView.addArrangedSubview(horizontalStackView)
        scrollToBottom()
    }
    
    func scrollToBottom() {
        processScrollView.layoutIfNeeded()

        let bottomOffset = CGPoint(x: 0,
                                   y: processScrollView.contentSize.height - processScrollView.bounds.size.height + processScrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            processScrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
        
    func clearCalculationProcess() {
        processVerticalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    @IBAction func touchUpOperandBtn(_ sender: UIButton) {
        if isCalculationOver {
            resetCalculator()
        }
        
        guard let operand: String = sender.titleLabel?.text, Double(operand) != nil else { return }
        
        if isLastOperator == false {
            currentOperand += operand
            print("입력된 숫자 : \(currentOperand)")
        } else {
            completeFormula += "\(currentOperand)\(currentOperator)"
            print("현재 formula : \(completeFormula)")
            resetOperand()
            
            currentOperand = operand
        }
        
        operandLabel.text = currentOperand
        isLastOperator = false
    }
    
    @IBAction func touchUpOperatorBtn(_ sender: UIButton) {
//        guard currentOperand != "0", currentOperand != "00" else { return } // 숫자 입력이 없거나 "0"인 상태에서는 연산자가 작동하지 않음 (주의-계산기 앱에서는 0도 작동함)
        
        guard isCalculationOver == false else { return }
        
        addCalculationProcessWithHorizontalStackView()
        
        let operatorSymbols: [Character] = Operator.allCases.map { $0.rawValue }
        
        guard let operatorSymbol: String = sender.titleLabel?.text, // 버튼의 연산기호를 확인
        operatorSymbols.contains(Character(operatorSymbol)) else {
            return
        }
        
        currentOperator = operatorSymbol
        operatorLabel.text = currentOperator
        operandLabel.text = "0"

        isLastOperator = true
    }

    @IBAction func touchUpResultBtn(_ sender: UIButton) {
        guard isCalculationOver == false else {
            return
        }
        
        completeFormula += currentOperand // formula에 반영되지 못한 마지막 숫자를 추가 (개선 필요)
        addCalculationProcessWithHorizontalStackView() // StackView에 반영되지 못한 마지막 숫자/연산자를 추가 (개선 필요)
        
        refreshLabelsWithResult(of: completeFormula)
        isCalculationOver = true
    }
    
    @IBAction func touchUpAllClearBtn(_ sender: UIButton) {
        resetCalculator()
    }
    
    @IBAction func touchUpClearEntryBtn(_ sender: UIButton) {
        if isCalculationOver == true {
            resetCalculator()
            return
        }
        
        operandLabel.text = "0"
    }
    
    @IBAction func touchUpSignChangeBtn(_ sender: UIButton) {
        if isCalculationOver == true {
            resetCalculator()
        }
        
        guard let operandInNumber = Double(currentOperand), operandInNumber != 0 else {
            return
        }
        
        if currentOperand.first == "-" {
            currentOperand.removeFirst()
        } else {
            currentOperand = "-\(currentOperand)"
        }
        
        operandLabel.text = currentOperand
    }
    
    @IBAction func touchUpDotBtn(_ sender: UIButton) {
        if isCalculationOver == true {
            resetCalculator()
        }
        
        guard let operandLabelText = operandLabel.text else { return }
        
        if operandLabelText.contains(".") {
            return
        } else if operandLabelText == "0" {
            // 문제 발생 - 숫자1-연산자1-".3"을 입력하면 0.3 대신 3으로 인식하고, 연산 메서드 비정상 작동
            // 원인-전에 입력한 숫자1이 currentOperand에 들어있어서 생기는 오류 (개선 필요)
            print("I'm here")
            currentOperand = "0."
            operandLabel.text! = "0."
            isLastDot = true
        } else {
            currentOperand += "."
            operandLabel.text! += "." // 왜 다른 라인과 다르게 옵셔널이 되지? (개선 필요)
        }
    }
}

class ProcessLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text: String) {
        super.init(frame: CGRect.zero)
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.adjustsFontForContentSizeCategory = true
        self.adjustsFontSizeToFitWidth = true
        self.textColor = .white
        self.font = UIFont.preferredFont(forTextStyle: .title3)
        self.baselineAdjustment = .alignBaselines
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProcessHorizontalStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(lhsLabel: UILabel, rhsLebel: UILabel) {
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.spacing = 8
        self.distribution = .fill
        self.alignment = .fill
        
        self.addArrangedSubview(lhsLabel)
        self.addArrangedSubview(rhsLebel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
