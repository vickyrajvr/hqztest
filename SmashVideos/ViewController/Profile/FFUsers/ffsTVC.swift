//
//  ffsTVC.swift
//  Infotex
//
//  Created by Mac on 31/05/2021.
//


import UIKit
import UIView_Shimmer
class ffsTVC: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnBell: UIButton!
    
    @IBOutlet weak var closeStackView: UIStackView!
    
    @IBOutlet weak var bellStackView: UIStackView!
    
    
    @IBOutlet weak var dotStackView: UIStackView!
    @IBOutlet weak var followingStackView: UIStackView!
    
    
    @IBOutlet weak var followersStackView: UIStackView!
    
    
    
    
    var shimmeringAnimatedItems: [UIView] {
            [
                imgIcon,
                lblTitle,
                lblDescription,
                btnFollow,
                btnBell
                
            ]
        }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgIcon.layer.cornerRadius = self.imgIcon.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
