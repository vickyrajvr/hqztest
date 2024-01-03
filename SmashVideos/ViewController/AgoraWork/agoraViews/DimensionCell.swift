//
//  ProfileCell.swift
//  OpenVideoCall
//
//  Created by GongYuhua on 6/26/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit

class DimensionCell: UICollectionViewCell {
    
    @IBOutlet weak var dimensionLabel: UILabel!
    
    func update(with dimension: CGSize, isSelected: Bool) {
        dimensionLabel.text = "\(Int(dimension.width))x\(Int(dimension.height))"
        dimensionLabel.textColor = isSelected ? UIColor.white : UIColor.gray
        dimensionLabel.backgroundColor = isSelected ? UIColor(named: "theme")! : UIColor.white
        dimensionLabel.layer.borderColor = isSelected ? UIColor(named: "theme")?.cgColor : UIColor.gray.cgColor
    }
}
