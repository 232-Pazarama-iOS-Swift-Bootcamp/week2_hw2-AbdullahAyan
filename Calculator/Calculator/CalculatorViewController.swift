//
//  ViewController.swift
//  Calculator
//
//  Created by Abdullah Ayan on 1.10.2022.
//

import UIKit


class OperationModel {
    static var sharedText = "0"
    static var sharedPre = "0"
    var output: Double = 0 {
        didSet {
            OperationModel.sharedText = String(output)
        }
    }
}

class OperationViewModel {
    var model = OperationModel()
    var operationElemets = [Double]()
    var previousOutput = "0"
    var prepreviousOutput = "0" {
        didSet {
            OperationModel.sharedPre = prepreviousOutput
        }
    }
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
        }else {
            print(operationElemets)
        }
        operationElemets.append(Double(onWriting) ?? 0)
        onWriting = "0"
        
        if operationElemets.count == 2 {
            switch previousSymbol {
            case "+":
                model.output = (operationElemets.removeLast() + operationElemets.removeLast())
                operationElemets.append(model.output)
                setPres()
                previousSymbol = nextSembol
            case "×":
                model.output = (operationElemets.removeLast() * operationElemets.removeLast())
                operationElemets.append(model.output)
                setPres()
                previousSymbol = nextSembol
            case "-":
                let second = operationElemets.removeLast()
                let first = operationElemets.removeFirst()
                model.output = first - second
                operationElemets.append(model.output)
                setPres()
                previousSymbol = nextSembol
            case "÷":
                let second = operationElemets.removeLast()
                let first = operationElemets.removeFirst()
                model.output = first / second
                operationElemets.append(model.output)
                setPres()
                previousSymbol = nextSembol
            case "=":
                break
            default:
                model.output = 0
                setPres()
            }
        }else {
            previousSymbol = symbol
        }
        
        if let int = Int(exactly: operationElemets[0] ) {
            return String(int)
        }else {
            return String(operationElemets[0])
        }
    }
    
    func setPres() {
        prepreviousOutput = previousOutput
        previousOutput = String(model.output)
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
            onWriting = String((Double(onWriting) ?? 0) / 100)
        case "π":
            onWriting = String(Double.pi)
        case "log2":
            onWriting = String(log2((Double(onWriting) ?? 0)))
        case "√x":
            onWriting = String(sqrt(Double(onWriting) ?? 0))
        case "x²":
            onWriting = String(pow((Double(onWriting) ?? 0),2))
        case "x!":
            let donWriting = Double(onWriting) ?? 0
            var output = 1
            
            if (donWriting > 1) {
                for j in 1...Int(donWriting){
                    output *= j
                }
            }
            onWriting = "0"
            return String(output)
            
        default:
            onWriting = "0"
        }
        
        if let int = Int(exactly: Double(onWriting)! ) {
            return String(int)
        }else {
            return String(Double(onWriting)!)
        }
    }
    
    func initalText() -> String {
        return OperationModel.sharedText
    }
    
    func initialPre() -> String {
        return OperationModel.sharedPre
    }
    
    func previousCalculation() -> String{
        return OperationModel.sharedText
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
        previousOperationLabel.text = viewModel?.initialPre()
        displayLabel.text = viewModel?.initalText()
    }
    
    @IBAction func numberButtonClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.write(number: (sender.titleLabel?.text)!)
    }
    
    @IBAction func operationButtonClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.operatorClicked(symbol: (sender.titleLabel?.text)!)
        previousOperationLabel.text = viewModel?.prepreviousOutput
    }
    
    
    @IBAction func changerClicked(_ sender: UIButton) {
        displayLabel.text = viewModel?.changerClicked(symbol: (sender.titleLabel?.text)!)
    }
    
    
}

