//
//  blockUserTableViewCell.swift
//  WOOW
//
//  Created by Mac on 18/07/2022.
//

import UIKit

class blockUserTableViewCell: UITableViewCell {
    
    //MARK:- OUTLET
    
    
    @IBOutlet weak var lblImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnUnblock: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        lblImage.layer.cornerRadius = lblImage.frame.height / 2.0
        lblImage.layer.masksToBounds = true
        
//        btnUnblock.layer.cornerRadius = btnUnblock.frame.height / 2.0
//        btnUnblock.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
