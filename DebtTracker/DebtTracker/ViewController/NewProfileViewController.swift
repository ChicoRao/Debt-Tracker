//
//  NewProfileViewController.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-12.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import Foundation
import UIKit

class NewProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var amountField: AmountField!
    
    @IBOutlet weak var occasionTextField: UITextField!
    
    var nameEntered: String = ""
    var amountEntered: String = ""
    var occasionEntered: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //User can tap anywhere to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewProfileViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        //Amount field
        amountField.addTarget(self, action: #selector(amountFieldChanged), for: .editingChanged)
        amountField.locale = Locale(identifier: "en_CA")
        
        //Setting max length for amount field
        amountField.delegate = self
    }
    
    //  Function for dismissing keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func amountFieldChanged() {
        print(#function)
        print("amountField:",amountField.text!)
        print("decimal:", amountField.decimal)
        print("doubleValue:",(amountField.decimal as NSDecimalNumber).doubleValue, terminator: "\n\n")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 7
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func nameEditingDidEnd(_ sender: Any) {
        nameEntered = nameTextField.text!
    }
    
    @IBAction func amountEditingDidEnd(_ sender: Any) {
        amountEntered = amountField.text!
    }
    
    @IBAction func occasionEditingDidEnd(_ sender: Any) {
        occasionEntered = occasionTextField.text!
    }
    
    
    @IBAction func addProfile(_ sender: UIButton) {
        
        //check if any of the field is empty, if empty, show red and tell user to enter something
        
        print(nameEntered)
        print(amountEntered)
        print(occasionEntered)
        
    
    }
    
    
}
