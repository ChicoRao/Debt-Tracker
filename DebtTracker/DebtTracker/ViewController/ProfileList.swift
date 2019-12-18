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
        
        tableView.reloadData()
        
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
            profileList = try managedContext.fetch(fetchRequest)

        } catch let error as NSError {
            print("Cout not fetch. \(error), \(error.userInfo)")
        }
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
        cell.totalAmtLabel?.text = profile.value(forKeyPath: "totalAmount") as? String
        
        let isPositive: Bool = profile.value(forKeyPath: "isPositive") as? Bool ?? true
        
        if isPositive {
            cell.totalAmtLabel?.textColor = UIColor.green
        }else {
            cell.totalAmtLabel?.textColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

           
//            profileList.remove(at: indexPath.row)
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let profile = profileList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            guard let moc = profile.managedObjectContext else {return}
            moc.delete(profile)
            moc.processPendingChanges()
            
            
//            let commit = profileList[indexPath.row]
//            container.viewContext.delete(commit)
//            profileList.remove(at: indexPath.row)
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//            managedContext.save()
            


        }else if editingStyle == .insert {
            //new instance in array and insert it into tableView (new row)
        }
    }
    
}
