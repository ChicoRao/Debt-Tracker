//
//  ProfileCell.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-12.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import UIKit


class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var totalAmtLabel: UILabel!
    
    func setProfile(profile: Profile) {
        nameLabel.text = profile.getName()
        totalAmtLabel.text = "$" + String(profile.getTotalAmt())
    }
    
}
