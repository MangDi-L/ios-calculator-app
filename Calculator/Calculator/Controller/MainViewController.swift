//
//  MainViewController.swift
//  Calculator
//
//  Created by mmim.

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var expressionRecordScrollView: UIScrollView!
    @IBOutlet weak var expressionRecordStackView: UIStackView!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var operandLabel: UILabel!
    
    private var expressionRecord: [String?] = []
    private var sumOfOperands: String = ""
    private var isFirstTime: Bool = true
    private var isDotUsed: Bool = false
    private var isNone: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialState()
    }
    
    private func setInitialState() {
        self.expressionRecordStackView.subviews.forEach{ $0.removeFromSuperview() }
        self.expressionRecord = []
        self.sumOfOperands = ""
        self.operatorLabel.text = nil
        self.operandLabel.text = "0"
        self.isFirstTime = true
        self.isDotUsed = false
        self.isNone = true
    }
    
    @IBAction func ACButtonTapped(_ sender: UIButton) {
        setInitialState()
    }
    
    @IBAction func CEButtonTapped(_ sender: UIButton) {
        operandLabel.text = "0"
        sumOfOperands = ""
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        if operandLabel.text == "0" {
            return
        } else if var recentOperandLabel = operandLabel.text, recentOperandLabel.first != "-" {
            recentOperandLabel.insert("-", at: recentOperandLabel.startIndex)
            sumOfOperands = recentOperandLabel
            operandLabel.text = sumOfOperands
        } else {
            operandLabel.text?.removeFirst()
        }
    }
    
    @IBAction func dotButtonTapped(_ sender: UIButton) {
        guard let selectedOperand = sender.titleLabel?.text else {
            return
        }
        guard sumOfOperands.count < 16 else {
            return
        }
        guard sumOfOperands.contains(".") == false else {
            return
        }
        
        sumOfOperands += selectedOperand
        operandLabel.text = changeToNumberFormatter(with: sumOfOperands) + "."
        self.isDotUsed = true
    }
    
    private func recombineByDot(with selectedOperand: String) {
        guard let integer = sumOfOperands.split(with: ".").first else {
            return
        }
        guard let numberAfterDot = sumOfOperands.split(with: ".").last else {
            return
        }
        operandLabel.text = changeToNumberFormatter(with: integer) + "." + numberAfterDot
    }
    
    private func workByCase(of selectedOperand: String) {
        if isFirstTime == false && operatorLabel.text == nil {
            return
        } else if selectedOperand.last == "0" && sumOfOperands.first == "0" && isDotUsed == false {
            return
        } else if selectedOperand.last == "0" && sumOfOperands.last == "." {
            sumOfOperands += selectedOperand
            recombineByDot(with: selectedOperand)
        } else if selectedOperand.last == "0" && sumOfOperands.last == "0" && isDotUsed == true {
            sumOfOperands += selectedOperand
            recombineByDot(with: selectedOperand)
        } else if operandLabel.text == "NaN" {
            setInitialState()
            sumOfOperands += selectedOperand
            operandLabel.text = changeToNumberFormatter(with: sumOfOperands)
        } else {
            sumOfOperands += selectedOperand
            operandLabel.text = changeToNumberFormatter(with: sumOfOperands)
        }
    }
    
    @IBAction func operandButtonsTapped(_ sender: UIButton) {
        guard let selectedOperand = sender.titleLabel?.text else {
            return
        }
        guard sumOfOperands.count < 16 else {
            return
        }
        
        workByCase(of: selectedOperand)
        
        isNone = false
    }

    @IBAction func operatorButtonsTapped(_ sender: UIButton) {
        operandLabel.text = changeToNumberFormatter(with: sumOfOperands)
        if isFirstTime == true && operandLabel.text == "0" {
            return
        } else if isFirstTime == true && operandLabel.text == "NaN" {
            return
        } else if isFirstTime == false && operandLabel.text == "0" && isNone == true {
            operatorLabel.text = sender.titleLabel?.text
        } else {
            addToExpressionRecord(operatorLabel, operandLabel)
            operatorLabel.text = sender.titleLabel?.text
            operandLabel.text = "0"
            sumOfOperands = ""
            isFirstTime = false
            isDotUsed = false
            isNone = true
        }
    }
    
    private func prepareBeforeResult() {
        operandLabel.text = changeToNumberFormatter(with: sumOfOperands)
        addToExpressionRecord(operatorLabel, operandLabel)
        operatorLabel.text = nil
    }
    
    private func calculate() -> String {
        let expressionString: String = expressionRecord
                                        .compactMap{ $0 }
                                        .joined(separator: " ")
                                        .replacingOccurrences(of: ",", with: "")
        var expressionForm = ExpressionParser.parse(from: expressionString)
        return changeToNumberFormatter(with: expressionForm.result().description)
    }
    
    private func setExpressionAfter(_ result: String) {
        if result == "-0" {
            operandLabel.text = "0"
        } else {
            operandLabel.text = result
        }
        sumOfOperands = operandLabel.text ?? ""
        expressionRecord.removeAll()
        isDotUsed = false
    }
    
    @IBAction func equalSignButtonTapped(_ sender: UIButton) {
        guard operatorLabel.text != nil else {
            return
        }
        
        prepareBeforeResult()
        
        let result = calculate()
        
        setExpressionAfter(result)
    }
    
    private func insert(_ selectedOperator: UILabel, _ selectedOperand: UILabel) -> UIStackView {
        let subStackView = UIStackView()
        let operatorInLog = UILabel()
        let operandInLog = UILabel()
        
        subStackView.spacing = 10
        operatorInLog.textColor = .white
        operandInLog.textColor = .white
        operatorInLog.text = operatorLabel.text
        operandInLog.text = operandLabel.text
        
        subStackView.addArrangedSubview(operatorInLog)
        subStackView.addArrangedSubview(operandInLog)
        expressionRecord.append(operatorInLog.text)
        expressionRecord.append(operandInLog.text)
        
        return subStackView
    }
    
    private func addToExpressionRecord(_ selectedOperator: UILabel, _ selectedOperand: UILabel) {
        expressionRecordStackView.addArrangedSubview(insert(selectedOperator, selectedOperand))
        expressionRecordScrollView.scrollToBottom()
    }
    
    private func changeToNumberFormatter(with sumOfOperands: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.maximumFractionDigits = 20
        let operandExpressionForm = numberFormatter.string(from: NSNumber(value: Double(sumOfOperands) ?? 0)) ?? ""
        return operandExpressionForm
    }
}
