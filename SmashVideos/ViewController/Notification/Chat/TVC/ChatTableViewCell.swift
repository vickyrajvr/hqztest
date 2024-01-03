//
//  chat1TableViewCell.swift
//  WOOW
//
//  Created by Mac on 25/08/2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    //left side
    
    @IBOutlet weak var leftView: BubbleView!
    @IBOutlet weak var lblLeft: UILabel!
    
    @IBOutlet weak var btnLeftPlay: UIButton!
    @IBOutlet weak var lblLeftRecordingTime: UILabel!
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var leftChatSlider: CustomSlider!
    
    
    //right side
    
    @IBOutlet weak var rightChatView: BubbleView!
    @IBOutlet weak var lblRightChat: UILabel!
    
    @IBOutlet weak var imgRightChat: UIImageView!
    @IBOutlet weak var lblRightSeenTime: UILabel!
    
    @IBOutlet weak var lblRightSliderTime: UILabel!
    @IBOutlet weak var rightChatSlider: CustomSlider!
    @IBOutlet weak var btnRightPlay: UIButton!
    
    // Center Delete Cell chatDeleteCell
    @IBOutlet weak var lblDelete: UILabel!
    var chatMessage : ChatMessage! {
        didSet {
            print(chatMessage.text)
            if chatMessage.isIncoming {
                self.lblLeft.text = chatMessage.text
            }else {
               // lblLeft.text = chatMessage.text
            }
            
        }
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
