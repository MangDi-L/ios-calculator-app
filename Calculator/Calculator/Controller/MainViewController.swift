//
//  MainViewController.swift
//  Calculator
//
//  Created by mmim.

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var calculationLogStackView: UIStackView!
    private var calculationLog: [String?] = []
    
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
    
    @IBOutlet weak var selectedOperatorLabel: UILabel!
    @IBOutlet weak var selectedOperandLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedOperatorLabel.text = ""
        self.selectedOperandLabel.text = "0"
    }
    
    @IBAction func operandButtonsClicked(_ sender: UIButton) {
        selectedOperandLabel.text = sender.titleLabel?.text
    }
    
    @IBAction func signButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func operatorButtonsClicked(_ sender: UIButton) {
        addInCalculationLog(selectedOperatorLabel, selectedOperandLabel)
        selectedOperatorLabel.text = sender.titleLabel?.text
        selectedOperandLabel.text = ""
    }
    
    @IBAction func equalSignButtonClicked(_ sender: UIButton) {
        
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
        return subStackView
    }
    
    func addInCalculationLog(_ selectedOperator: UILabel, _ selectedOperand: UILabel) {
        calculationLogStackView.addArrangedSubview(insert(selectedOperator, selectedOperand))
    }
}

