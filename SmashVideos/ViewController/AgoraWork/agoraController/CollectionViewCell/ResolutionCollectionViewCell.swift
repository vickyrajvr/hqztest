//
//  ResolutionCollectionViewCell.swift
//  WOOW
//
//  Created by Mac on 26/07/2022.
//

import UIKit

class ResolutionCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblResolution: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 25.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(named: "barColor")?.cgColor
        self.layer.masksToBounds = true
    
    }
    func update(with dimension: CGSize, isSelected: Bool) {
        lblResolution.text = "\(Int(dimension.width))x\(Int(dimension.height))"
        lblResolution.textColor = isSelected ? UIColor.white : UIColor.gray
        lblResolution.backgroundColor = isSelected ? UIColor(named: "theme") : UIColor.white
        lblResolution.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.gray.cgColor
    }
    
}
