//
//  CommentRowTableViewCell.swift
//  Infotex
//
//  Created by Mac on 08/09/2021.
//

import UIKit

class CommentRowTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblTotalLike: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var userImage: CustomImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    //MARK:- awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
