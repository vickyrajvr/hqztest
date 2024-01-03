//
//  ProfileViewsTableViewCell.swift
//  SmashVideos
//
//  Created by Mac on 25/01/2023.
//

import UIKit

class ProfileViewsTableViewCell: UITableViewCell {
    
    //MARK: - OUTLET
    
    @IBOutlet weak var lblProfileUsername: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
