//
//  DetailList.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-12.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var profileList: [NSManagedObject] = []
    var detailList: [Detail] = []
    var detailCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For light mode
        overrideUserInterfaceStyle = .light
        
        detailCount = 0

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
            
            let nameChosen = UserDefaults.standard.string(forKey: "nameChosenForDetails")
            
            for data in profileList {
                let mName = data.value(forKey: "name") as! String
                if nameChosen == mName {
                    let mDetailList = data.value(forKeyPath: "detailList") as! DetailList
        
                    for element in mDetailList.detailList {
                        detailList.append(element)
                    }
                }
            }

            tableView.reloadData()  //reload table to updated data will be added as rows
            
            print("table view done reloading data")

        } catch let error as NSError {
            print("Cout not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = detailList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
        
        cell.detailAmountLabel?.text = detail.amount
        
        cell.detailOccasionLabel?.text = detail.occasion

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//
//            let detail = detailList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)  //swipe delete
            
//
//
//            guard let moc = profile.managedObjectContext else {return}
//            moc.delete(profile)
//            moc.processPendingChanges() //saves deleted changes to core data

        }
    }
    
}
