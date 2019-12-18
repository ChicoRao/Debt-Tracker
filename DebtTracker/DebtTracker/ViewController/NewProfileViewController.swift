//
//  NewProfileViewController.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-12.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var amountField: AmountField!
    
    @IBOutlet weak var occasionTextField: UITextField!

    @IBOutlet weak var whoOwesWhoButton: UIButton!
    
    var nameEntered: String = ""
    var amountEntered: String = ""
    var occasionEntered: String = ""
    var isPositive: Bool = true
    
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
        
        //Setting default button text (Default: others owe you)
        whoOwesWhoButton.setTitle("+", for: .normal)
        
        //For light mode
        overrideUserInterfaceStyle = .light
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
    
    @IBAction func nameEditingChanged(_ sender: Any) {
        nameEntered = nameTextField.text!
    }

    @IBAction func amountEditingChanged(_ sender: AmountField) {
        amountEntered = amountField.text!
    }
    

    @IBAction func occasionEditingChanged(_ sender: Any) {
        //occasionEntered = occasionTextField.text!
    }
    
    
    @IBAction func whoOwesWhoButtonAction(_ sender: UIButton) {
        
        if whoOwesWhoButton.currentTitle! == "+" {
            whoOwesWhoButton.setTitle("-", for: .normal)
            isPositive = false
        }else if whoOwesWhoButton.currentTitle! == "-" {
            whoOwesWhoButton.setTitle("+", for: .normal)
            isPositive = true
        }
    }
    
    @IBAction func addProfile(_ sender: UIButton) {
        
        //check if any of the field is empty, if empty, show red and tell user to enter something
        if nameTextField.text! == "" || amountField.text! == "$0.00" {
            print("please write something")
            return
        }
        
        print(nameEntered)
        print(amountEntered)
        //print(occasionEntered)
        
        //Saves data to Core Data
        save(name: nameEntered, amount: amountEntered)
    
        nameTextField.text = ""
        amountField.text = "$0.00"
        //occasionTextField.text = ""
    }
    
    func save(name: String, amount: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedContext)!
        
        let profile = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //3
        profile.setValue(name, forKeyPath: "name")
        profile.setValue(amount, forKeyPath: "totalAmount")
        profile.setValue(isPositive, forKeyPath: "isPositive")
        
        //4
        do {
            try managedContext.save()
            print("Saving to core data")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
