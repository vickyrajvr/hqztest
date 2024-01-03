//
//  VisitorLiveTableViewCell.swift
//  SmashVideos
//
//  Created by Mac on 14/07/2023.
//

import UIKit

class VisitorLiveTableViewCell: UITableViewCell {
    
    
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgProfile: CustomImageView!
    @IBOutlet var lblVisitor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
