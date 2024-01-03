//
//  RaiseHandUserTblCell.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 29/05/2023.
//

import UIKit

class RaiseHandUserTblCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var addMicBtn: UIButton!
    @IBOutlet weak var profileimg: CustomImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
