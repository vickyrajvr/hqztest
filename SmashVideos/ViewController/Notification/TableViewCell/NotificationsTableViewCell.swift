//
//  NotificationsTableViewCell.swift
//  WOOW
//
//  Created by Mac on 29/06/2022.
//

import UIKit
import UIView_Shimmer
class NotificationsTableViewCell: UITableViewCell,ShimmeringViewProtocol {

    @IBOutlet weak var shimmerView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblDescr: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    var shimmeringAnimatedItems: [UIView] {
            [
                imgProfile,
                lblDescr,
                lblName
            ]
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        imgProfile.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
