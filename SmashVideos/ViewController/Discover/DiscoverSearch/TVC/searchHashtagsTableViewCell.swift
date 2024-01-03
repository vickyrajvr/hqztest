//
//  searchHashtagsTableViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 07/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import UIView_Shimmer
class searchHashtagsTableViewCell: UITableViewCell,ShimmeringViewProtocol {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    @IBOutlet weak var btnFav: UIButton!
    
    var shimmeringAnimatedItems: [UIView] {
            [
                titleLbl,
                countLbl
            ]
        }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
