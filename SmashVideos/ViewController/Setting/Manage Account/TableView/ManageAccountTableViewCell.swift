//
//  ManageAccountTableViewCell.swift
//  Infotex
//
//  Created by Wasiq Tayyab on 29/09/2021.
//

import UIKit

class ManageAccountTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblData: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
