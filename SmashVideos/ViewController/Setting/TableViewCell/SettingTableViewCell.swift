//
//  SettingTableViewCell.swift
//  SmashVideos
//
//  Created by Mac on 26/10/2022.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblCache: UILabel!
    @IBOutlet weak var imgSetting: UIImageView!
    @IBOutlet weak var lblSetting: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
