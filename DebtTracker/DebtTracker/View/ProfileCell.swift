//
//  ProfileCell.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-12.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate {
    func didTapDetail(name: String)
}

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalAmtLabel: UILabel!
    
    var delegate: ProfileCellDelegate?
    
    @IBAction func detailsTapped(_ sender: UIButton) {
        print("Pressed detail button, starting the function delegate stuff")
        delegate?.didTapDetail(name: nameLabel.text ?? "Unknown")
    }
    
}
