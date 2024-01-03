//
//  OrderCollectionViewCell.swift
//  DubiDabi
//
//  Created by Mac on 13/05/2023.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var lblDurationDay: UILabel!
    
    @IBOutlet weak var lblVideoViews: UILabel!
    @IBOutlet weak var lblCoin: UILabel!
    
    @IBOutlet weak var lblLinkClicks: UILabel!
    
    
    @IBOutlet weak var completedStackView: UIStackView!
    
    @IBOutlet weak var btnPromote: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
