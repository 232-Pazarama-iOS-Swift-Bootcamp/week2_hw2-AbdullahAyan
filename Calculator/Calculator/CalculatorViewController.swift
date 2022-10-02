//
//  ViewController.swift
//  Calculator
//
//  Created by Abdullah Ayan on 1.10.2022.
//

import UIKit


class OperationModel {
    static var sharedText = "0"
    
    var operationStack = [Double]()
    
    var currentText = OperationModel.sharedText {
        didSet {
            if currentText.contains(",") {
                currentText = currentText.replacingOccurrences(of: ",", with: ".")
            }
            OperationModel.sharedText = currentText
        }
    }
    
    
    var currentNumber: Double {
        get {
            if let number = Double(currentText) {
                return number
            }
            currentText = String(self.currentNumber)
            return 0.0
        }
        set {
            if let int = Int(exactly: newValue) {
                self.currentText = String(int)
            }else {
                self.currentText = String(newValue)
            }
        }
    }
    
    
}

class OperationViewModel {
    var model = OperationModel()
    var operationSymbol = ""
    
    
    func initialText() -> String {
        return model.currentText
    }
    
    func write(number: String) -> String {
        if model.currentText == "0" {
            model.currentText = number
            return number
        }
        model.currentText += number
        return model.currentText
    }
    
    func calculate(symbol: String) -> String {
        switch symbol {
        case "AC" :
            model.currentText = "0"
        case "+/-":
            if model.currentText.contains("-") {
                model.currentText.removeFirst(1)
            } else {
                model.currentText = "-" + model.currentText
            }
        case "%":
            model.currentNumber /= 100
        case "+":
            if model.operationStack.isEmpty {
                model.operationStack.append(model.currentNumber)
                model.currentNumber = 0
                operationSymbol = "+"
            } else {
                model.operationStack.append(model.currentNumber + model.operationStack.removeLast())
                model.currentText = String(model.operationStack.removeLast())
                operationSymbol = "+"
            }
        case "-":
            if model.operationStack.isEmpty {
                model.operationStack.append(model.currentNumber)
                model.currentNumber = 0
                operationSymbol = "-"
            } else {
                model.operationStack.append(model.operationStack.removeLast() - model.currentNumber)
                model.currentText = String(model.operationStack.removeLast())
                operationSymbol = "-"
            }
        case "=":
            if model.operationStack.isEmpty {
                model.currentNumber = 0
                print("girdi")
            } else {
                model.currentNumber = Double(calculate(symbol: operationSymbol))!
                operationSymbol = ""

            }
        default:
            return ""
        }
        print(model.operationStack)
        return model.currentText
    }
}

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var previousOperationLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    var viewModel: OperationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        viewModel = OperationViewModel()
        displayLabel.text = viewModel?.initialText()
    }
    
    @IBAction func numberButtonClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.write(number: (sender.titleLabel?.text)!)
    }
    
    @IBAction func operationButtonClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.calculate(symbol: (sender.titleLabel?.text)!)
    }
}

