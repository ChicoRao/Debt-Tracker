//
//  ViewController.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-11.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import UIKit
import CoreData

class ProfileList: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For light mode
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Profile")

        //3
        do {
            profileList = try managedContext.fetch(fetchRequest)    //fetching data from core data
            tableView.reloadData()  //reload table to updated data will be added as rows

        } catch let error as NSError {
            print("Cout not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

extension ProfileList: ProfileCellDelegate {
    func didTapDetail(name: String) {
        let nameChosen = name
        
        UserDefaults.standard.set(nameChosen, forKey: "nameChosenForDetails")
    }
    
}

extension ProfileList: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profileList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        
        cell.nameLabel?.text = profile.value(forKeyPath: "name") as? String
        let amount = profile.value(forKeyPath: "totalAmount") as? String
        
        let isPositive: Bool = profile.value(forKeyPath: "isPositive") as? Bool ?? true
        
        if isPositive {
            cell.totalAmtLabel?.textColor = UIColor(red: 0.251, green: 0.6275, blue: 0, alpha: 1)  //show green for what others owe you
            cell.totalAmtLabel?.text = "+" + (amount ?? "$0.00")
        }else {
            cell.totalAmtLabel?.textColor = UIColor.red //show red for what you owe others
            cell.totalAmtLabel?.text = "-" + (amount ?? "$0.00")
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let profile = profileList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)  //swipe delete
            guard let moc = profile.managedObjectContext else {return}
            moc.delete(profile)
            moc.processPendingChanges() //saves deleted changes to core data

        }else if editingStyle == .insert {
            //new instance in array and insert it into tableView (new row)
        }
    }
    
}
