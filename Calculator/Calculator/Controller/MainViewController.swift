//
//  MainViewController.swift
//  Calculator
//
//  Created by mmim.

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var expressionRecordStackView: UIStackView!
    private var expressionRecord: [String?] = []
    private var totalOperand: String = ""
    private var operationCount: Int = 0
    private var isPlus: Bool = true
    private var isZeroNone: Bool = true
    private var isFirstTime: Bool = true
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var doubleZeroButton: UIButton!
    @IBOutlet weak var dotButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var operandLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialState()
    }
    
    func setInitialState() {
        self.expressionRecordStackView.subviews.forEach{ $0.removeFromSuperview() }
        self.expressionRecord = []
        self.totalOperand = ""
        self.operationCount = 0
        self.operatorLabel.text = nil
        self.operandLabel.text = "0"
        self.isPlus = true
        self.isZeroNone = true
        self.isFirstTime = true
    }
    
    @IBAction func ACButtonClicked(_ sender: UIButton) {
        setInitialState()
    }
    
    @IBAction func CEButtonClicked(_ sender: UIButton) {
        self.isZeroNone = true
        self.operandLabel.text = "0"
        self.totalOperand = ""
    }
    
    @IBAction func signButtonClicked(_ sender: UIButton) {
        if isZeroNone == true && operandLabel.text == "0" {
            return
        } else if var numberScreen = operandLabel.text, isPlus == true {
            numberScreen.insert("-", at: numberScreen.startIndex)
            operandLabel.text = numberScreen
            isPlus = false
        } else {
            operandLabel.text?.removeFirst()
            isPlus = true
        }
    }
    
    @IBAction func dotButtonClicked(_ sender: UIButton) {
        guard let selectedOperand = sender.titleLabel?.text else { return }
        guard totalOperand.count < 21 else { return }
        
        if isZeroNone == true && operandLabel.text == "0" {
            return
        } else if isZeroNone == false && operandLabel.text == "0" {
            return
        } else if totalOperand.contains(".") == true {
            return
        }
        totalOperand += selectedOperand
        operandLabel.text = totalOperand
    }
    
    @IBAction func operandButtonsClicked(_ sender: UIButton) {
        guard let selectedOperand = sender.titleLabel?.text else { return }
        guard totalOperand.count < 21 else { return }
        
        if selectedOperand == "0" && isZeroNone == false && operandLabel.text == "0" {
            return
        } else {
            totalOperand += selectedOperand
            operandLabel.text = changeToNumberFormatter(with: totalOperand)
            isZeroNone = false
        }
    }
    
    @IBAction func operatorButtonsClicked(_ sender: UIButton) {
        addInCalculationLog(selectedOperatorLabel, selectedOperandLabel)
        selectedOperatorLabel.text = sender.titleLabel?.text
        selectedOperandLabel.text = ""
    }
    
    @IBAction func equalSignButtonClicked(_ sender: UIButton) {
        addInCalculationLog(selectedOperatorLabel, selectedOperandLabel)
        selectedOperatorLabel.text = ""
        let expressionString = calculationLog.compactMap{ $0 }.joined(separator: " ")
        var expressionForm = ExpressionParser.parse(from: expressionString)
        let result = expressionForm.result()
        selectedOperandLabel.text = result.description
        calculationLog.removeAll()
        calculationLog.append(selectedOperandLabel.text)
    }
    
    func insert(_ selectedOperator: UILabel, _ selectedOperand: UILabel) -> UIStackView {
        let subStackView = UIStackView()
        let operatorInLog = UILabel()
        let operandInLog = UILabel()
        
        operatorInLog.textColor = .white
        operandInLog.textColor = .white
        operatorInLog.text = selectedOperatorLabel.text
        operandInLog.text = selectedOperandLabel.text
        
        subStackView.addArrangedSubview(operatorInLog)
        subStackView.addArrangedSubview(operandInLog)
        
        calculationLog.append(operandInLog.text)
        calculationLog.append(operatorInLog.text)
        return subStackView
    }
    
    func addInCalculationLog(_ selectedOperator: UILabel, _ selectedOperand: UILabel) {
        calculationLogStackView.addArrangedSubview(insert(selectedOperator, selectedOperand))
    }
}

