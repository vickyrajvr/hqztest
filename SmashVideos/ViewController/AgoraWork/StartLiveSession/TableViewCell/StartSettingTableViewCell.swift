//
//  StartSettingTableViewCell.swift
//  SmashVideos
//
//  Created by Mac on 11/07/2023.
//

import UIKit

class StartSettingTableViewCell: UITableViewCell {
    
    
    @IBOutlet var lblSetting: UILabel!
    @IBOutlet var settingImage: UIImageView!
    
    
    @IBOutlet var nextButton: UIImageView!
    
    @IBOutlet var settingSwitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
