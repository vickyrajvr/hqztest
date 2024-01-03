//
//  RaiseHandViewController.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 29/05/2023.
//

import UIKit

class RaiseHandViewController: UIViewController {

    @IBOutlet weak var topBtn: UIButton!
    
    // local veriables
    var liveRoomArray = [[String : Any]]()
    var roomId = ""
    var roomDetailsM : ShowRoomDetailM?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func YesRaisHandRoom(roomID: String) {
        SpacesListeners.shared.UpdateRaisehandUserLiveRoom(roomID: self.roomId, userid : UserDefaultsManager.shared.user_id, raishand : "1") { (isSuccess) in
            if isSuccess == true
            {
                
            }
        }
    }
    

    @IBAction func raiseHandAction(_ sender: Any) {
        YesRaisHandRoom(roomID: self.roomId)
    }
    
    @IBAction func neverMindAction(_ sender: Any) {
    }
    
    
    @IBAction func dropBtnAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
