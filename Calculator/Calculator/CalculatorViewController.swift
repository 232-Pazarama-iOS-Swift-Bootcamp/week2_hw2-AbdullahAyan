//
//  ViewController.swift
//  Calculator
//
//  Created by Abdullah Ayan on 1.10.2022.
//

import UIKit


class OperationModel {
    static var sharedText = "0"
    var output: Double = 0 {
        didSet {
            OperationModel.sharedText = String(output)
        }
    }
}

class OperationViewModel {
    var model = OperationModel()
    var operationElemets = [Double]()
    var previousSymbol = ""
    var nextSembol = ""
    var onWriting = "" {
        didSet {
            OperationModel.sharedText = onWriting
        }
    }
    
    func write(number : String) -> String {
        if onWriting == "0" {
            onWriting = number
        }else if number == ","{
            onWriting += "."
        }else {
            onWriting += number
        }
        return onWriting
    }
    
    func operatorClicked(symbol: String) -> String {
        if symbol != "=" {
            nextSembol = symbol
        }
        operationElemets.append(Double(onWriting)!)
        onWriting = "0"
        
        if operationElemets.count == 2 {
            switch previousSymbol {
            case "+":
                model.output = (operationElemets.removeLast() + operationElemets.removeLast())
                operationElemets.append(model.output)

                previousSymbol = nextSembol
            case "×":
                model.output = (operationElemets.removeLast() * operationElemets.removeLast())
                operationElemets.append(model.output)

                previousSymbol = nextSembol
            case "-":
                let second = operationElemets.removeLast()
                let first = operationElemets.removeFirst()
                model.output = first - second
                operationElemets.append(model.output)

                previousSymbol = nextSembol
            case "÷":
                let second = operationElemets.removeLast()
                let first = operationElemets.removeFirst()
                model.output = first / second
                operationElemets.append(model.output)

                previousSymbol = nextSembol
            case "=":
                print(11)
            default:
                model.output = 0
            }
        }else {
            previousSymbol = symbol
        }
        

        
        print(operationElemets)
        
        if let int = Int(exactly: operationElemets[0] ) {
    
            return String(int)
        }else {

            return String(operationElemets[0])
        }
    }
    
    func changerClicked(symbol: String) -> String {
        switch symbol {
        case "AC":
            onWriting = "0"
            operationElemets = [Double]()
        case "+/-":
            if onWriting.contains("-") {
                onWriting.removeFirst(1)
            } else {
                onWriting = "-" + onWriting
            }
        case "%":
            onWriting = String(Double(onWriting)! / 100)
        default:
            onWriting = "0"
        }
        
        return onWriting
    }
    
}

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var previousOperationLabel: UILabel!
    
    var viewModel: OperationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        viewModel = OperationViewModel()
    }
    
    @IBAction func numberButtonClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.write(number: (sender.titleLabel?.text)!)
    }
    
    @IBAction func operationButtonClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.operatorClicked(symbol: (sender.titleLabel?.text)!)
    }
    
    
    @IBAction func changerClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.changerClicked(symbol: (sender.titleLabel?.text)!)
    }
    
    
}

