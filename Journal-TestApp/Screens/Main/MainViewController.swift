//
//  MainViewController.swift
//  Journal-TestApp
//
//  Created by Andras Hollo on 2018. 10. 10..
//  Copyright © 2018. Andras Hollo. All rights reserved.
//

import UIKit
import Journal

class MainViewController: UIViewController {
    
    @IBOutlet weak var logLevelSegmentedControl: UISegmentedControl!
    @IBOutlet weak var logTextTextField: UITextField!
    @IBOutlet weak var contextNameTextField: UITextField!
    @IBOutlet weak var contextValueTextField: UITextField!
    
    private var loggingContext = TestAppLoggingContext()
    
    // MARK: - Action methods
    
    @IBAction func sendLogTouched(_ sender: Any) {
        switch logLevelSegmentedControl.selectedSegmentIndex {
        case 0:
            verbose(logTextTextField.text ?? "")
        case 1:
            debug(logTextTextField.text ?? "")
        case 2:
            info(logTextTextField.text ?? "")
        case 3:
            warning(logTextTextField.text ?? "")
        case 4:
            error(logTextTextField.text ?? "", NSError(domain: "Example", code: 1, userInfo: nil))
        default: ()
        }
    }
    
    @IBAction func setContextTouched(_ sender: Any) {
        loggingContext.identifier = contextNameTextField.text ?? ""
        JournalProvider.shared.journal.setContext(loggingContext, toValue: contextValueTextField.text ?? "")
    }
    
}
