//
//  PromotionCollectionViewCell.swift
//  DubiDabi
//
//  Created by Mac on 13/05/2023.
//

import UIKit

class PromotionCollectionViewCell: UICollectionViewCell {
    
    //MARK: - OUTLET
    
    @IBOutlet weak var lblMainHeading: UILabel!
    
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
