//
//  giftNewTableViewCell.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 04/08/2023.
//

import UIKit

class giftNewTableViewCell: UITableViewCell {

    @IBOutlet weak var giftImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
