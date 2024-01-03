//
//  searchSoundTableViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 07/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import UIView_Shimmer
class searchSoundTableViewCell: UITableViewCell,ShimmeringViewProtocol {
    
    @IBOutlet weak var soundImg: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnPlay: UIImageView!
    
    
    var shimmeringAnimatedItems: [UIView] {
            [
                soundImg,
                titleLbl,
                descLbl,
                durationLbl,
                selectBtn,
                btnPlay
            ]
        }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadIndicator.color = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



}
