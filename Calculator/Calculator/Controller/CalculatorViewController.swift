//
//  Calculator - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit


class CalculatorViewController: UIViewController {
    
    var calculatorModel = Calculator()
    
    @IBOutlet weak var formulaHistoryStackView: UIStackView!
    @IBOutlet weak var currentInputOperandLabel: UILabel!
    @IBOutlet weak var currentInputOperatorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeAllFormulaHistory()
        updateCurrentInputLabel()
    }
    
    @IBAction func touchUpAllClearButton(_ sender: UIButton) {
        calculatorModel.touchAllClearButton()
        updateCurrentInputLabel()
        removeAllFormulaHistory()
    }
    
    @IBAction func touchUpClearEntryButton(_ sender: UIButton) {
        calculatorModel.touchClearEntryButton()
        updateCurrentInputLabel()
    }
    
    @IBAction func touchUpChangeSignButton(_ sender: UIButton) {
        calculatorModel.touchSignChangeButton()
        updateCurrentInputLabel()
    }
    
    @IBAction func touchUpEqualButton(_ sender: UIButton) {
        addFormulaHistory()
        calculatorModel.touchEqualButton()
        updateCurrentInputLabel()
    }
    
    @IBAction func touchUpDotButton(_ sender: UIButton) {
        calculatorModel.touchPointButton()
        updateCurrentInputLabel()
    }
    
    @IBAction func touchUpOperatorsButton(_ sender: UIButton) {
        guard let operatorSymbol = sender.titleLabel?.text else { return }
        addFormulaHistory()
        calculatorModel.touchOperatorButton(operatorSymbol)
        updateCurrentInputLabel()
    }
    
    @IBAction func touchUpOperandsButton(_ sender: UIButton) {
        guard let operandSymbol = sender.titleLabel?.text else { return }
        calculatorModel.touchNumberButton(operandSymbol)
        updateCurrentInputLabel()
    }
    
    private func updateCurrentInputLabel() {
        currentInputOperandLabel.text = calculatorModel.currentInputOperand
        currentInputOperatorLabel.text = calculatorModel.currentInputOperator
    }
    
    private func addFormulaHistory() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        let operatorLabel = UILabel()
        operatorLabel.text = calculatorModel.currentInputOperator
        operatorLabel.textColor = .white
        
        let operandLabel = UILabel()
        operandLabel.text = calculatorModel.currentInputOperand
        operandLabel.textColor = .white
        
        stackView.addArrangedSubview(operatorLabel)
        stackView.addArrangedSubview(operandLabel)
        formulaHistoryStackView.addArrangedSubview(stackView)
    }
    
    private func removeAllFormulaHistory() {
        formulaHistoryStackView.arrangedSubviews.forEach { (view: UIView) -> () in
            view.removeFromSuperview()
        }
    }
}
