//
//  CommentHeaderTableView.swift
//  Infotex
//
//  Created by Mac on 08/09/2021.
//

import UIKit

class CommentHeaderTableView: UITableViewHeaderFooterView {
    
    //MARK:- Outlets
    @IBOutlet weak var userImage: CustomImageView!
    
    @IBOutlet weak var lblComments: UILabel!
    
    @IBOutlet weak var lblCommentTime: UILabel!
    
    @IBOutlet weak var btnReply: UIButton!
    
    @IBOutlet weak var btnViewAllReply: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var lblTotalLike: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
}
