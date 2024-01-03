//
//  FilterVideoCollectionViewCell.swift
//
//  Infotex
//
//  Created by Mac on 01/09/2021.
//  Copyright © 2021 Mac. All rights reserved.

import UIKit

class FilterVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filteredImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureImageView()
    }
    
    func configureImageView() {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurredEffectView = UIVisualEffectView(effect: blur)
        blurredEffectView.alpha = 0.4
        blurredEffectView.frame = self.imageView.bounds
        self.imageView.addSubview(blurredEffectView)
    }

}
