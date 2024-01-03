//
//  CreatorToolsTableViewCell.swift
//  SmashVideos
//
//  Created by Mac on 12/03/2023.
//

import UIKit

class CreatorToolsTableViewCell: UITableViewCell {
    
    //MARK: - VARS
    
    @IBOutlet weak var imgCreatorTools: UIImageView!
    @IBOutlet weak var lblCreatorTools: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
