//
//  MainViewController.swift
//  Calculator
//
//  Created by Abdullah Ayan on 1.10.2022.
//

import UIKit

class NavigationViewController: UIViewController {

    static var testNumber = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyDeviceOrientation()
    }
    
    func determineMyDeviceOrientation(){
        if UIDevice.current.orientation.isLandscape {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Landscape") as? CalculatorViewController {
                navigationController?.pushViewController(vc, animated: false)
            }
        }
        if UIDevice.current.orientation.isPortrait {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Portrait") as? CalculatorViewController {
                navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
   
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        determineMyDeviceOrientation()
    }

}