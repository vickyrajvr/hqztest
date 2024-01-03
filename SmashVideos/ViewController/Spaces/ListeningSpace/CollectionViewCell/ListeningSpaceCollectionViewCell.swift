//
//  ListeningSpaceCollectionViewCell.swift
//  SmashVideos
//
//  Created by Mac on 10/04/2023.
//

import UIKit

class ListeningSpaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: CustomImageView!
    
    @IBOutlet weak var micImage: CustomImageView!
    @IBOutlet weak var handImage: CustomImageView!
    @IBOutlet weak var lblHost: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
