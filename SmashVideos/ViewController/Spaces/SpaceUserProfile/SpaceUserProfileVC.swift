//
//  SpaceUserProfileVC.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 29/05/2023.
//

import UIKit

class SpaceUserProfileVC: UIViewController {
    var roomId = ""
    var UserObj =  [ String : Any ]()
    
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var invitegBtn: UIButton!
    @IBOutlet weak var moveToAudienceBtn: UIButton!
    @IBOutlet weak var viewProfileBtn: UIButton!
    @IBOutlet weak var makeAModeratorBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let Userid = UserObj["key"] as? String ?? ""
        let userValues = UserObj["value"] as? NSDictionary
        let user = userValues?["userModel"] as? NSDictionary
        let userRoleType = userValues?["userRoleType"] as? String
        if userRoleType == "1" {
            self.invitegBtn.isHidden = true
            self.makeAModeratorBtn.isHidden = true
            
            if Userid == UserDefaultsManager.shared.user_id {
                self.moveToAudienceBtn.isHidden = true
                self.invitegBtn.isHidden = true
            }
            
        }else if userRoleType == "2" {
            self.makeAModeratorBtn.isHidden = false
            self.invitegBtn.isHidden = true
        }else {
            self.moveToAudienceBtn.isHidden = true
            self.makeAModeratorBtn.isHidden = true
        }
        
        
    }

    @IBAction func msgBtbAction(_ sender: Any) {
    }
    
    @IBAction func makeAmoderatorBtnAction(_ sender: Any) {
    }
    
    @IBAction func InviteToSpeakBtnAction(_ sender: Any) {
        AcceptRaisHandRoom()
    }
    
    @IBAction func moveAudBtnAction(_ sender: Any) {
        UpdateLiveRoom(roomID: self.roomId, userRoleType: "0", mic: "0")
    }
    
    
    @IBAction func viewProfileAction(_ sender: Any) {
    }
    
    func AcceptRaisHandRoom() {
        var userModel = [String : Any]()
        let Userid = UserObj["key"] as? String ?? ""
        let userValues = UserObj["value"] as? NSDictionary
        let user = userValues?["userModel"] as? NSDictionary
        let username = user?["username"] as? String
//        let user = self.addRoomM?.msg?.roomMember?[0].user
        userModel = [
            "invite"        : "1",
            "userId"        : Userid,
            "userName"      : username ?? ""
        ]
        print(userModel)
        print(roomId)
        SpacesListeners.shared.RoomInvitation(roomID: roomId, userid: Userid, userModel: userModel) { (isSuccess) in
            if isSuccess == true
            {
                
            }
        }
    }
    
    
    func UpdateLiveRoom(roomID: String,userRoleType: String,mic: String) {
        let Userid = UserObj["key"] as? String ?? ""
//        var parameters = [String : Any]()
        var userModel = [String : Any]()
        
        let userValues = UserObj["value"] as? NSDictionary
        let user = userValues?["userModel"] as? NSDictionary
        
        userModel = user as! [String : Any]
        
//        var user: Users?
//        let RoomMembers = self.roomDetailsM?.msg?.roomMember
//        for i in 0..<(RoomMembers?.count ?? 0) {
//            let user1 = RoomMembers?[i].user
//            if UserDefaultsManager.shared.user_id == user1?.id {
//                user = user1
//            }
//        }
//
//        userModel = [
//            "active"        : user?.active ?? "1",
//            "applyVerification"        : "",
//            "authToken"        : user?.authToken ?? "",
//            "bio"      : user?.bio ?? "",
//            "block"      : 0,
//
//            "blockByUser"        : UserDefaultsManager.shared.user_id,
//            "button"        : "",
//            "city"        : user?.city ?? "",
//            "cityId"      : "",
//            "country"      : user?.country ?? "",
//
//            "countryId"        : user?.countryId ?? "",
//            "created"        : user?.created ?? "",
//            "device"        : "ios",
//            "deviceToken"      : UserDefaultsManager.shared.device_token ,
//            "dob"      : user?.dob ?? "",
//            "email"        : user?.email ?? "",
//            "fbId"        : "",
//            "firstName"        : user?.firstName ?? "",
//            "followersCount"      : "0",
//            "followingCount"      : "0",
//
//            "gender"        : user?.gender ?? "",
//            "id"        : "\(UserDefaultsManager.shared.user_id)",
//            "ip"        : user?.ip ?? "",
//            "lastName"      : user?.lastName ?? "",
//            "lat"      : Double("\(user?.lat ?? "0.0")") ?? 0.0,
//            "likesCount"        : "0",
//            "lng"        : Double("\(user?.longField ?? "0.0")") ?? 0.0 ,
//            "notification"        : "1",
//            "online"      : user?.online ?? "",
//            "password"      : user?.password ?? "",
//
//            "paypal"        : user?.paypal ?? "",
//            "phone"        : user?.phone ?? "",
//            "profileGif"        : user?.profileGif ?? "",
//            "profilePic"      : user?.profilePic ?? "",
//            "profileView"      : user?.profileView ?? "",
//            "resetWalletDatetime"        : user?.resetWalletDatetime ?? "",
//            "role"        : "", //user?.role ?? "",
//            "selected"        : false,
//            "socialType"      : user?.social ?? "",
//            "social_id"      : user?.socialId ?? "",
//
//            "stateId"        : user?.state ?? "",
//            "token"        : "",
//            "username"        : user?.username ?? "",
//            "verified"      : "0",
//            "version"      : "1.0",
//            "videoCount"        : "0",
//            "visitorCount"        : NumberFormatter().number(from: "\(user?.website ?? "0")") ?? 0 , //  NSNumber(value: "0"),// Int("\(user?.website ?? "0")") ?? 0, //user?.website ?? "",
//            "wallet"        : NumberFormatter().number(from: "\(user?.wallet ?? "0")") ?? 0 , // Int("\(user?.wallet ?? "0")") ?? 0,// user?.wallet ?? "",
//            "website"      : user?.website ?? ""
//
//        ]
        var Users = [String : Any]()
        Users = [
            "mice"        : mic,
            "online"        : "1",
            "riseHand"        : "0",
            "userRoleType"      : userRoleType,
            "userModel"      : userModel
        ]
        // {"user_id":"5","room_id":"25","moderator":"0"}
//        parameters = [
////            "clubId"        : "0",
//            "adminId"        : UserDefaultsManager.shared.user_id,
//            "created"        : user?.created ?? "",
//            "id"      : roomID,
//            "privacyType"      : self.addRoomM?.msg?.room?.privacy ?? "0",
//            "riseHandCount"      : "0",
//            "riseHandRule"      : "1",
//            "roomType"      : "room",
//            "title"      : self.addRoomM?.msg?.room?.title ?? ""
//        ]
        
        print(userModel)
        SpacesListeners.shared.JoinUserLiveRoom(roomID: roomID, user_id: Userid, Users: Users , userModel: userModel) { (isSuccess) in
            if isSuccess == true
            {
                print("succefully add join user in room ")
                self.dismiss(animated: true)
            }
        }
       
        
    }

}
