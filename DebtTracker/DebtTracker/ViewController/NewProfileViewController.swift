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
        whoOwesWhoButton.setTitleColor(UIColor(red: 0.251, green: 0.6275, blue: 0, alpha: 1), for: .normal)
        
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
        occasionEntered = occasionTextField.text!
    }
    
    
    @IBAction func whoOwesWhoButtonAction(_ sender: UIButton) {
        
        if whoOwesWhoButton.currentTitle! == "+" {
            whoOwesWhoButton.setTitle("-", for: .normal)
            whoOwesWhoButton.setTitleColor(UIColor.red, for: .normal)
            isPositive = false
        }else if whoOwesWhoButton.currentTitle! == "-" {
            whoOwesWhoButton.setTitle("+", for: .normal)
            whoOwesWhoButton.setTitleColor(UIColor(red: 0.251, green: 0.6275, blue: 0, alpha: 1), for: .normal)
            isPositive = true
        }
    }
    
    @IBAction func addProfile(_ sender: UIButton) {
        
        //check if any of the field is empty, if empty, show red and tell user to enter something
        if nameTextField.text! == "" || amountField.text! == "$0.00" {
            print("please write something")
            return
        }
        
        if occasionEntered == "" {
            occasionEntered = "Occasion unknown"
        }
        
        print(nameEntered)
        print(amountEntered)
        print(occasionEntered)
        
        //Saves data to Core Data
        save(name: nameEntered, amount: amountEntered, occasion: occasionEntered)
    
        nameTextField.text = ""
        amountField.text = "$0.00"
        occasionTextField.text = ""
    }
    
    func save(name: String, amount: String, occasion: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Profile")

        var result: [NSManagedObject] = []
        
        do {
            result = try managedContext.fetch(fetchRequest)    //fetching data from core data

        } catch let error as NSError {
            print("Cout not fetch. \(error), \(error.userInfo)")
        }
        
        for data in result {
            let mName = data.value(forKey: "name") as! String
            if nameEntered == mName {
                //Existing profile
                
                //Adding new detail
                var tempResultArr = data.value(forKey: "detailList") as! DetailList
                var tempDetailArr: [Detail] = []
                
                for element in tempResultArr.detailList {
                    tempDetailArr.append(element)
                }
                
                let newDetail = Detail(amount: amount, occasion: occasion)
                tempDetailArr.append(newDetail)
                
                let newDetailList = DetailList(detailList: tempDetailArr)
                data.setValue(newDetailList, forKeyPath: "detailList")
                
                //Updating total amount
                //Removing "$" sign
                var oldStringAmount = data.value(forKey: "totalAmount") as! String
                oldStringAmount = oldStringAmount.replacingOccurrences(of: "$", with: "")
                let newStringAmount = amountEntered.replacingOccurrences(of: "$", with: "")
                
                //New and old isPositive values
                let oldIsPositive = data.value(forKey: "isPositive") as! Bool
                let newIsPositive = isPositive
                
                //Converting from string to double
                let oldDoubleAmount: Double = Double(oldStringAmount)!
                let newDoubleAmount: Double = Double(newStringAmount)!

                //Calculating total, should handle negative number cases too
                var newTotalDoubleAmount: Double = 0
                
                if oldIsPositive == true && newIsPositive == true {
                    newTotalDoubleAmount = oldDoubleAmount + newDoubleAmount
                }else if oldIsPositive == true && newIsPositive == false {
                    newTotalDoubleAmount = oldDoubleAmount - newDoubleAmount
                }else if oldIsPositive == false && newIsPositive == false {
                    newTotalDoubleAmount = (oldDoubleAmount + newDoubleAmount)*(-1.00)
                }else if oldIsPositive == false && newIsPositive == true {
                    newTotalDoubleAmount = newDoubleAmount - oldDoubleAmount
                }
                
                //Convert back to string and store value (might need two isPositive value, one for detail, one for main profile list
                if newTotalDoubleAmount >= 0 {
                    isPositive = true
                    let newTotalStringAmount = "$" + String(format: "%.02f", newTotalDoubleAmount)
                    data.setValue(isPositive, forKeyPath: "isPositive")
                    data.setValue(newTotalStringAmount, forKeyPath: "totalAmount")
                }else {
                    isPositive = false
                    var newTotalStringAmount = String(format: "%.02f", newTotalDoubleAmount)
                    newTotalStringAmount = "$" + newTotalStringAmount.replacingOccurrences(of: "-", with: "")
                    data.setValue(isPositive, forKeyPath: "isPositive")
                    data.setValue(newTotalStringAmount, forKeyPath: "totalAmount")
                }
                
                do {
                        try managedContext.save()
                        print("Saving updated data to core data")

                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
            }
            return
        }
        
        //New Profile
        
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedContext)!
        let profile = NSManagedObject(entity: entity, insertInto: managedContext)
        
        profile.setValue(name, forKeyPath: "name")
        profile.setValue(amount, forKeyPath: "totalAmount")
        profile.setValue(isPositive, forKeyPath: "isPositive")
        
        var tempDetailArr: [Detail] = []
        let newDetail = Detail(amount: amount, occasion: occasion)
        tempDetailArr.append(newDetail)
        let newDetailList = DetailList(detailList: tempDetailArr)
        profile.setValue(newDetailList, forKeyPath: "detailList")
        
        do {
            try managedContext.save()
            print("Saving new profile data to core data")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    
    }
    
}
