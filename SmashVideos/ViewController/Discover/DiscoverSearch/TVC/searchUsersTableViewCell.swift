//
//  searchUsersTableViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 07/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import UIView_Shimmer
class searchUsersTableViewCell: UITableViewCell,ShimmeringViewProtocol {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var userDetails: UILabel!
    
    @IBOutlet weak var userImg: UIImageView!
    
    
    @IBOutlet weak var lblPrivate: UILabel!
    @IBOutlet weak var privateStackView: UIStackView!
    @IBOutlet weak var verifiedStackView: UIStackView!
    
    var shimmeringAnimatedItems: [UIView] {
            [
                userName,
                desc,
                userDetails,
                userImg
            ]
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImg.layer.masksToBounds = false
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
        userImg.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
