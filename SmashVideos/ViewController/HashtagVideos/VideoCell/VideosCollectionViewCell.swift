//
//  VideosCollectionViewCell.swift
//  WOOW
//
//  Created by Zubair Ahmed on 23/06/2022.
//

import UIKit
import SDWebImage

class VideosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var likeCountLbl: UILabel!
    
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var vidImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var lblHeartCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guard userImg != nil else{return}
        userImg.layer.masksToBounds = false
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
    }
}
