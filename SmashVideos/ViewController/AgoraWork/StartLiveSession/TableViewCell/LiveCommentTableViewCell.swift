//
//  LiveCommentTableViewCell.swift
//  SmashVideos
//
//  Created by Mac on 10/07/2023.
//

import UIKit

class LiveCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImg: CustomImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var comment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
