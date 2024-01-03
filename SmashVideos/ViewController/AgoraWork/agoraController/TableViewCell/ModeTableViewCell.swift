//
//  ModeTableViewCell.swift
//  WOOW
//
//  Created by Mac on 26/07/2022.
//

import UIKit

class ModeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var imgMode: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
