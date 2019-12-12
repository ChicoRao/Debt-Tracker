//
//  ViewController.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-11.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import UIKit

class ProfileList: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var profiles: [Profile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profiles = createArray()
    }

    func createArray() -> [Profile] {
        
        var tempProfiles: [Profile] = []
        
        let profile1 = Profile(name: "Angus", totalAmt: 2)
        let profile2 = Profile(name: "Yoel", totalAmt: 12)
        
        tempProfiles.append(profile1)
        tempProfiles.append(profile2)
        
        return tempProfiles
    }

}

extension ProfileList: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profiles[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        
        cell.setProfile(profile: profile)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            profiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert {
            //new instance in array and insert it into tableView (new row)
        }
    }
    
}
