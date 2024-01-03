//
//  ListeningSpaceViewController.swift
//  SmashVideos
//
//  Created by Mac on 10/04/2023.
//

import UIKit
import SDWebImage
import Firebase
import AgoraRtcKit

class ListeningSpaceViewController: UIViewController {
    
    //MARK: - VARS
    
    
    var agoraKit: AgoraRtcEngineKit!
    
    private lazy var agoraKitt: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: nil)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        return engine
    }()
  //  @IBOutlet weak var controlButtonsView: UIView!
    let micOffImage = UIImage(named: "mic_off")
    let micOnImage = UIImage(named: "mic_on")
    
    
    var count = 50
    
    var isStart : Bool?
    
    var roomId = ""
    var roomName = ""
    var userRoleType = "0"
    var mic = "0"
    
    @IBOutlet weak var listeningView: UIView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var moderatorUserCV: UICollectionView!
    @IBOutlet weak var lblMaineLabel: UILabel!
    @IBOutlet weak var btnLeave: UIButton!
   // @IBOutlet weak var lblListeningCount: UILabel!
    
    
   // @IBOutlet weak var btnMicrophone: UIButton!
   // @IBOutlet weak var btnStartListening: UIButton!
    
  //  @IBOutlet weak var lblMicLabel: UILabel!
    var liveRoomArray = [[String : Any]]()
    var speakersRoomArray = [[String : Any]]()
    var userss =  [[String : Any]]()
    
    @IBOutlet weak var riseHandUsersBtn: UIButton!
    @IBOutlet weak var MicBtn: UIButton!
    @IBOutlet weak var riseHandBtn: UIButton!
    
   
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        print("room id ", roomId)
        if UserDefaultsManager.shared.spaceRoomId == roomId {
            
        }else {
            UserDefaultsManager.shared.spaceRoomId = roomId
        }
        
        
        
        initializeAgoraEngine()
        initializeRoomUi()
        
        CollectionViewInitilize()
        self.ShowUserJoinRoomApi()
        initilizeFirebaseListeners()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.joinChannel()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            dismiss(animated: true, completion: nil)
            
        }
    }

    
    //MARK: APIS
    
    private lazy var loader : UIView = {
       return (AppUtility?.createActivityIndicator((UIApplication.shared.keyWindow?.rootViewController?.view)!))!
    }()
    var viewModel = ShowRoomViewModel()
    var showUserJoinRoom : ShowUserJoinedRoomsM?
    var joinRoomArray = [JoinedRoomsObject]()
    
    // ShowUserJoinRoomApi
    func ShowUserJoinRoomApi() {

        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        let userID = UserDefaultsManager.shared.user_id
        var parameters = [String : Any]()
        parameters = [
            "user_id"        : userID
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.ShowUserJoinRoomApi(endPoint: "api/\(Endpoint.showUserJoinedRooms.rawValue)", parameters: parameters) { state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
                
                if self.viewModel.showUserJoinRoom?.code == 200 {
                    
                    if self.viewModel.joinRoomArray.count ?? 0 > 0 {
                        self.joinRoomArray = self.viewModel.joinRoomArray
//                        self.userCollectionView.delegate = self
//                        self.userCollectionView.dataSource = self
//                        self.userCollectionView.reloadData()
                        
                        let height = self.userCollectionView.collectionViewLayout.collectionViewContentSize.height
//                        self.uperViewHeightConst.constant = height
                        print("height: ",height)
                        var userRoleType = "0"
                        var mic = "0"
                        
                        if self.joinRoomArray[0].roomMember?.moderator == "1" {
                            userRoleType = "1"
                            mic = "1"
                        }else if self.joinRoomArray[0].roomMember?.moderator == "2" {
                            userRoleType = "2"
                            mic = "1"
                        }else {
                            mic = "0"
                        }
                        self.addLiveRoom(roomID: self.roomId, userRoleType: userRoleType, mic: mic)
                        
                    }
                }
            case .failure:
                print("failure")
            }
        }
    }
    
    
    //MARK:  join room API
    var joinRoomM : JoinRoomM?
    func JoinRoomApi(room_id : String , moderator : String,roomName : String) {
        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        var parameters = [String : Any]()
        // {"user_id":"5","room_id":"25","moderator":"0"}
        parameters = [
            "user_id"        : userID,
            "room_id"        : room_id,
            "moderator"      : moderator
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.joinRoom(endPoint: "api/\(Endpoint.joinRoom.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
                
                if self.viewModel.joinRoomM?.code == 200 {
                    self.joinRoomM = self.viewModel.joinRoomM
                    
//                    let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
//                    myViewController.modalPresentationStyle = .overFullScreen
//                    myViewController.isStart = true
//                    myViewController.roomId = room_id //self.joinRoomM?.msg?.room?.id ?? ""
//                    myViewController.roomName = roomName
//                    self.navigationController?.present(myViewController, animated: true)
                    SpacesListeners.shared.joinRoom(uid: userID, roomId: "\(self.joinRoomM?.msg?.room?.id ?? "")") { (isSuccess) in
                        if isSuccess == true
                        {
                            
                        }
                        self.ShowUserJoinRoomApi()
                        
                    }
                }
            case .failure:
                print("failure")
                SpacesListeners.shared.joinRoom(uid: userID, roomId: room_id) { (isSuccess) in
                    if isSuccess == true
                    {
                        
                    }
                }
//                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
//                myViewController.modalPresentationStyle = .overFullScreen
//                myViewController.isStart = true
//                myViewController.roomId = room_id // self.joinRoomM?.msg?.room?.id ?? ""
//                myViewController.roomName = roomName
//                self.navigationController?.present(myViewController, animated: true)
            }
        }
    }
    
    
    //MARK:  assignModerator API
    var assignModeratorM : AssignModeratorM?
    func assignModerator(room_id : String , moderator : String,roomName : String) {
        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        var parameters = [String : Any]()
        // {"user_id":"5","room_id":"25","moderator":"0"}
        parameters = [
            "user_id"        : userID,
            "room_id"        : room_id,
            "moderator"      : moderator
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.joinRoom(endPoint: "api/\(Endpoint.joinRoom.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
                
                if self.viewModel.joinRoomM?.code == 200 {
                    self.assignModeratorM = self.viewModel.assignModeratorM
                    
//                    let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
//                    myViewController.modalPresentationStyle = .overFullScreen
//                    myViewController.isStart = true
//                    myViewController.roomId = room_id //self.joinRoomM?.msg?.room?.id ?? ""
//                    myViewController.roomName = roomName
//                    self.navigationController?.present(myViewController, animated: true)
//                    SpacesListeners.shared.joinRoom(uid: userID, roomId: "\(self.joinRoomM?.msg?.room?.id ?? "")") { (isSuccess) in
//                        if isSuccess == true
//                        {
//
//                        }
//                        self.ShowUserJoinRoomApi()
//
//                    }
                }
            case .failure:
                print("failure")
                SpacesListeners.shared.joinRoom(uid: userID, roomId: room_id) { (isSuccess) in
                    if isSuccess == true
                    {
                        
                    }
                }
//                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
//                myViewController.modalPresentationStyle = .overFullScreen
//                myViewController.isStart = true
//                myViewController.roomId = room_id // self.joinRoomM?.msg?.room?.id ?? ""
//                myViewController.roomName = roomName
//                self.navigationController?.present(myViewController, animated: true)
            }
        }
    }
    //MARK:  LeaveRoomApi
    var leaveRoomM : LeaveRoomM?
    func LeaveRoomApi(room_id : String) {
        leaveChannel()
        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        // {"user_id":"5","room_id":"25","moderator":"0"}
        var parameters = [String : Any]()
        parameters = [
            "user_id"        : userID,
            "room_id"        : room_id
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.leaveRoom(endPoint: "api/\(Endpoint.leaveRoom.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
                print("successfully leave room server")
                if self.viewModel.leaveRoomM?.code == 200 {
                    self.leaveRoomM = self.viewModel.leaveRoomM
//                    if let msg = self.leaveRoomM?.msg as? String {
//                        if msg == "removed member" {
//                            if self.userRoleType ==
//                            self.DeleteRoomApi(room_id: room_id)
//                        }
//                    }else {
                        SpacesListeners.shared.LeaveRoom(uid: UserDefaultsManager.shared.user_id) { (isSuccess) in
                            if isSuccess == true
                            {
                               print("successfully leave room firebase")
                                
                                self.LeaveJoinUserLiveRoom(roomID: self.roomId)
                            }
                        }
                        UserDefaultsManager.shared.spaceRoomId = ""
                        self.dismiss(animated: true)
//                    }
                    
                }
            case .failure:
                print("failure")
            }
        }
    }
   
    //MARK:  DeleteRoomApi
    var deleteRoomM : DeleteRoomM?
    func DeleteRoomApi(room_id : String) {
        leaveChannel()
        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        // {"user_id":"5","room_id":"25","moderator":"0"}
        var parameters = [String : Any]()
        parameters = [
            "user_id"        : userID,
            "id"        : room_id
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.deleteRoom(endPoint: "api/\(Endpoint.deleteRoom.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
               
                if self.viewModel.deleteRoomM?.code == 200 {
                    self.deleteRoomM = self.viewModel.deleteRoomM
                    SpacesListeners.shared.DeleteRoom(roomID: room_id) { (isSuccess) in
                        if isSuccess == true
                        {
                            
                        }
                    }
                    UserDefaultsManager.shared.spaceRoomId = ""
                    self.dismiss(animated: true)
                }
            case .failure:
                print("failure")
            }
        }
    }
    
    //MARK:  ShowRoomDetailApi
    var roomDetailsM : ShowRoomDetailM?
    func ShowRoomDetailApi(userRoleType : String, mic : String) {
        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        // {"user_id":"5","room_id":"25","moderator":"0"}
        var parameters = [String : Any]()
        parameters = [
            "user_id"        : userID,
            "room_id"        : self.roomId
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.showRoomDetail(endPoint: "api/\(Endpoint.showRoomDetail.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
               
                if self.viewModel.roomDetailsM?.code == 200 {
                    self.roomDetailsM = self.viewModel.roomDetailsM
                    
                    
                    if userRoleType == "0" {
                        self.JoinRoomApi(room_id: self.roomId, moderator: "0", roomName: self.roomName)
                    }else {
                        self.addLiveRoom(roomID: self.roomId, userRoleType: userRoleType, mic: mic)
                    }
//                    SpacesListeners.shared.DeleteRoom(roomID: room_id) { (isSuccess) in
//                        if isSuccess == true
//                        {
//
//                        }
//                    }
//                    self.dismiss(animated: true)
                }
            case .failure:
                print("failure")
            }
        }
    }
    
//    var roomDetailsM : ShowRoomDetailM?
    func CheckRoomDetailsForDeleteRoomApi(userRoleType : String, mic : String) {
        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        // {"user_id":"5","room_id":"25","moderator":"0"}
        var parameters = [String : Any]()
        parameters = [
            "user_id"        : userID,
            "room_id"        : self.roomId
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.showRoomDetail(endPoint: "api/\(Endpoint.showRoomDetail.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
               
                if self.viewModel.roomDetailsM?.code == 200 {
                    self.roomDetailsM = self.viewModel.roomDetailsM
                    let totalRoomMember = self.roomDetailsM?.msg?.room?.member
                    
                    var ModeratorCount = 0
                    let RoomMember = self.roomDetailsM?.msg?.roomMember
                    for i in 0..<(RoomMember?.count ?? 0) {
                        let obj = RoomMember?[i]
                        let mod = obj?.moderator
                        if mod == "1" {
                            ModeratorCount += 1
                        }
                    }
                    
                    if ModeratorCount > 1 {
                        self.LeaveRoomApi(room_id: self.roomId)
                    }else {
                        self.DeleteRoomApi(room_id: self.roomId)
                    }
//
//                    if totalRoomMember == 1 {
//                        self.DeleteRoomApi(room_id: self.roomId)
//                    }else {
//                        self.LeaveRoomApi(room_id: self.roomId)
//                    }
                    
                   
                }
            case .failure:
                print("failure")
            }
        }
    }
    
    
    
    func addLiveRoom(roomID: String,userRoleType: String,mic: String) {
        
//        var parameters = [String : Any]()
        var userModel = [String : Any]()
        var user: Users?
        let RoomMembers = self.joinRoomArray  //self.roomDetailsM?.msg?.roomMember
        for i in 0..<(RoomMembers.count ) {
            let user1 = RoomMembers[i].user
            if UserDefaultsManager.shared.user_id == user1?.id {
                user = user1
            }
        }
        
        userModel = [
            "active"        : user?.active ?? "1",
            "applyVerification"        : "",
            "authToken"        : user?.authToken ?? "",
            "bio"      : user?.bio ?? "",
            "block"      : 0,
            
            "blockByUser"        : UserDefaultsManager.shared.user_id,
            "button"        : "",
            "city"        : user?.city ?? "",
            "cityId"      : "",
            "country"      : user?.country ?? "",
            
            "countryId"        : user?.countryId ?? "",
            "created"        : user?.created ?? "",
            "device"        : "ios",
            "deviceToken"      : UserDefaultsManager.shared.device_token ,
            "dob"      : user?.dob ?? "",
            "email"        : user?.email ?? "",
            "fbId"        : "",
            "firstName"        : user?.firstName ?? "",
            "followersCount"      : "0",
            "followingCount"      : "0",
            
            "gender"        : user?.gender ?? "",
            "id"        : "\(UserDefaultsManager.shared.user_id)",
            "ip"        : user?.ip ?? "",
            "lastName"      : user?.lastName ?? "",
            "lat"      : Double("\(user?.lat ?? "0.0")") ?? 0.0,
            "likesCount"        : "0",
            "lng"        : Double("\(user?.longField ?? "0.0")") ?? 0.0 ,
            "notification"        : "1",
            "online"      : user?.online ?? "",
            "password"      : user?.password ?? "",
            
            "paypal"        : user?.paypal ?? "",
            "phone"        : user?.phone ?? "",
            "profileGif"        : user?.profileGif ?? "",
            "profilePic"      : user?.profilePic ?? "",
            "profileView"      : user?.profileView ?? "",
            "resetWalletDatetime"        : user?.resetWalletDatetime ?? "",
            "role"        : "", //user?.role ?? "",
            "selected"        : false,
            "socialType"      : user?.social ?? "",
            "social_id"      : user?.socialId ?? "",
            
            "stateId"        : user?.state ?? "",
            "token"        : "",
            "username"        : user?.username ?? "",
            "verified"      : "0",
            "version"      : "1.0",
            "videoCount"        : "0",
            "visitorCount"        : NumberFormatter().number(from: "\(user?.website ?? "0")") ?? 0 , //  NSNumber(value: "0"),// Int("\(user?.website ?? "0")") ?? 0, //user?.website ?? "",
            "wallet"        : NumberFormatter().number(from: "\(user?.wallet ?? "0")") ?? 0 , // Int("\(user?.wallet ?? "0")") ?? 0,// user?.wallet ?? "",
            "website"      : user?.website ?? ""
            
        ]
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
        SpacesListeners.shared.JoinUserLiveRoom(roomID: roomID, user_id: UserDefaultsManager.shared.user_id, Users: Users , userModel: userModel) { (isSuccess) in
            if isSuccess == true
            {
                print("succefully add join user in room ")
            }
        }
       
        
    }
    
    
    func LeaveJoinUserLiveRoom(roomID: String) {
        var parameters = [String : Any]()
        var userModel = [String : Any]()
        var user: Users?
        let RoomMembers = self.roomDetailsM?.msg?.roomMember
        print()
        for i in 0..<(RoomMembers?.count ?? 0) {
            let user1 = RoomMembers?[i].user
            if UserDefaultsManager.shared.user_id == user1?.id {
                user = user1
            }
        }
        var Users = [String : Any]()
        Users = [
            "online"        : "0"
        ]
        print(userModel)
        SpacesListeners.shared.LeaveUserLiveRoom(roomID: roomID, values: parameters, Users: Users , userModel: userModel) { (isSuccess) in
            if isSuccess == true
            {
                print("succefully add join user in room ")
            }
        }
    }
    
    //MARK: - BUTTON ACTION
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

    @IBAction func leaveButtonPressed(_ sender: UIButton) {
        if self.userRoleType == "1" {
            self.CheckRoomDetailsForDeleteRoomApi(userRoleType: self.userRoleType, mic: "1")
           // self.DeleteRoomApi(room_id: self.roomId)
            return
        }
        
        if isStart == false {
            self.DeleteRoomApi(room_id: self.roomId)
        }else{
            self.LeaveRoomApi(room_id: self.roomId)
        }
        
    }
    
    @IBAction func riseHandBtnAction(_ sender: Any) {
        let yourVC = RaiseHandViewController()
        yourVC.roomId = self.roomId
        yourVC.roomDetailsM = self.roomDetailsM
        if #available(iOS 15.0, *) {
            if let sheet = yourVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        } else {
            // Fallback on earlier versions
        }
        self.present(yourVC, animated: true, completion: nil)
    }
    
    @IBAction func riseHandUsersBtnAction(_ sender: Any) {
        let yourVC = RaiseHandUsersVC()

        yourVC.roomId = self.roomId
        if #available(iOS 15.0, *) {
            if let sheet = yourVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
        } else {
            // Fallback on earlier versions
        }
        self.present(yourVC, animated: true, completion: nil)
    }

  
    
    //MARK: Initilize Functions
    func initializeRoomUi() {
        if isStart == true{
            self.btnLeave.setTitle("Leave quietly", for: .normal)
            self.lblMaineLabel.text = self.roomName
            if userRoleType == "1" || userRoleType == "2" {
                mic = "1"
            }else {
                mic = "0"
            }
            self.ShowRoomDetailApi(userRoleType: userRoleType, mic: mic)
        }else{
            
            self.btnLeave.setTitle("End", for: .normal)
           
            MicBtn.isHidden = false
        }
    }
    func CollectionViewInitilize() {
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        
        moderatorUserCV.delegate = self
        moderatorUserCV.dataSource = self
        
        userCollectionView.register(UINib(nibName: "ListeningSpaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListeningSpaceCollectionViewCell")
        moderatorUserCV.register(UINib(nibName: "ListeningSpaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListeningSpaceCollectionViewCell")
    }
    func initilizeFirebaseListeners() {
        LiveRoomListener()
        getSpaceRoomInvitation()
    }
    func LiveRoomListener() {
        
        SpacesListeners.shared.LiveRoom() { (isSuccess, message) in
            self.speakersRoomArray.removeAll()
            self.liveRoomArray.removeAll()
            if isSuccess == true
            {
                print(message)
                for key in message
                {
                    print(key)
                    print(key.value)
                    let key1 = key.key
                    print("key1: ", key1)
//                    self.roomId = key1
                    let value1 = key.value
//                    var arr =  [ String : Any ]()
//                    arr["key"] = key1
//                    arr["value"] = value1
                    let messages = key.value as? [String : Any] ?? [:]
                    
//                    let user = value1["Users"] as? [String : Any] ?? [:]
                    
                    if self.roomId == key1 {
                        if let obj = value1 as? NSDictionary {
//                            self.roomId = key1
                            print(obj.allKeys)
                            print(obj.value(forKey: "\(key1)"))
                            let user = obj["Users"] as?  NSDictionary // [[String : Any]]
                            print(user?.count)
                            print(user?.allKeys)
                            print(user?.allValues)
                            
                            let userKeys = user?.allKeys
                            
                            let userValues = user?.allValues
                            
                            for j in 0..<(userValues?.count ?? 0) {
                                
                                let userKey = userKeys?[j]
                                let userValues = userValues?[j]
                                
                                print("userKey",userKey ?? "")
                                print("userValues",userValues ?? "")
                                
                                var arr =  [ String : Any ]()
                                arr["key"] = userKey ?? ""
                                arr["value"] = userValues ?? ""
                                
                                let dict = userValues as? NSDictionary
                                let userModel = dict?["userModel"] as? NSDictionary
                                
                                let userRoleType = dict?["userRoleType"] as? String
                                let mice = dict?["mice"] as? String
                                print(userModel)
                                
                                self.MicBtn.isHidden = true
                                
                                if userModel == nil {
                                    print("user is not in active ")
                                }else {
                                    print("user is in active ")
                                    if userKey as! String == UserDefaultsManager.shared.user_id {
                                        self.userRoleType  = userRoleType ?? "0"
                                    }
                                    if userRoleType == "1" || userRoleType == "2" {
                                        if userKey as! String == UserDefaultsManager.shared.user_id {
                                            
                                            self.riseHandUsersBtn.isHidden = false
                                            self.riseHandBtn.isHidden = true
                                            self.MicBtn.isHidden = false
                                            self.MicBtn.setImage(self.micOnImage, for: .normal)
                                        }
                                        self.speakersRoomArray.append(arr)
                                    }else {
                                        if userKey as! String == UserDefaultsManager.shared.user_id {
                                            self.MicBtn.isHidden = true
                                            self.riseHandUsersBtn.isHidden = true
                                            self.riseHandBtn.isHidden = false
                                            if mice == "0" {
                                                self.agoraKit.muteLocalAudioStream(true)
                                                self.MicBtn.setImage(self.micOffImage, for: .normal)
                                                self.MicBtn.isHidden = true
                                                self.riseHandBtn.isHidden = false
                                            }
                                        }
                                        self.liveRoomArray.append(arr)
                                    }
                                }
                            }
                            
                            for i in 0..<user!.count {
                                let ii = user?[i] as? NSDictionary
                            //    print("dddddddddd",ii)
//                                let use = user
//                                self.liveRoomArray.append(i)
                                
//                                self.userss.append(user)
                            }
                            
                        }
                    }
//                    self.liveRoomArray.append(arr)
                    
//                    self.arrMessages.sort(by: { ("\($0["time"]!)") < ("\($1["time"]!)") })
//                    self.scrollToBottom()
                }
                print(self.liveRoomArray.count)
                self.userCollectionView.reloadData()
                self.moderatorUserCV.isHidden = false
                self.moderatorUserCV.reloadData()
            }
        }
    }
    func getSpaceRoomInvitation() {
        SpacesListeners.shared.getSpaceRoomInvitation(roomID: self.roomId) { (isSuccess, message) in
//            self.speakersRoomArray.removeAll()
//            self.liveRoomArray.removeAll()
            if isSuccess == true
            {
                print(message)
                for key in message
                {
                    print(key)
                    print(key.value)
                    let key1 = key.key
                    print("key1: ", key1)
//                    self.roomId = key1
                    let value1 = key.value
                    
                    if key1 == UserDefaultsManager.shared.user_id {
                        let alertController = UIAlertController(title: "title", message: "invitation", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: {(alert : UIAlertAction!) in
                            alertController.dismiss(animated: true, completion: nil)
                        })
                        
                        let Yes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
                            
                            Database.database().reference().child("LiveRoom").child(self.roomId).child("RoomInvitation").child(key1).removeValue()
                            
                            self.addLiveRoom(roomID: self.roomId, userRoleType: "2", mic: "1")
                            self.assignModerator(room_id: self.roomId, moderator: "2", roomName: self.roomName)
                            
                            
                            self.MicBtn.isHidden = false
                            self.riseHandUsersBtn.isHidden = false
                            self.riseHandBtn.isHidden = true
                            
                        })
                        alertController.addAction(alertAction)
                        alertController.addAction(Yes)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

//MARK: - EXTENSION FOR COLLECTION VIEW

extension ListeningSpaceViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.moderatorUserCV {
            return speakersRoomArray.count
        }else{
            return liveRoomArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListeningSpaceCollectionViewCell", for: indexPath)as! ListeningSpaceCollectionViewCell
//        let type = self.liveRoomArray[indexPath.row]["value"] as? String ?? "type"
        if collectionView == self.moderatorUserCV {
            let obj = self.speakersRoomArray[indexPath.row]
            let dict = obj["value"] as? NSDictionary
            let usermodel = dict?["userModel"] as? NSDictionary
            let profilePic = usermodel?["profilePic"]
            let username = usermodel?["username"]
            let riseHand = dict?["riseHand"]
            let mice = dict?["mice"]
            cell.micImage.isHidden = true
            if riseHand as! String == "1" {
                cell.handImage.isHidden = false
            }else{
                cell.handImage.isHidden = true
            }
            let userImgPath = AppUtility?.detectURL(ipString: "\(profilePic)" as! String)
            let userImgUrl = URL(string: userImgPath!)
            
            cell.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.profileImage.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2.0
            cell.profileImage.layer.masksToBounds = true
            
            cell.lblName.text = "\(username ?? "")"
            return cell
        }else{
            
            let obj = self.liveRoomArray[indexPath.row]
            let dict = obj["value"] as? NSDictionary
            let usermodel = dict?["userModel"] as? NSDictionary
            let profilePic = usermodel?["profilePic"]
            let username = usermodel?["username"]
            let riseHand = dict?["riseHand"]
            let mice = dict?["mice"]
            cell.micImage.isHidden = true
            if riseHand as! String == "1" {
                cell.handImage.isHidden = false
            }else{
                cell.handImage.isHidden = true
            }
            let userImgPath = AppUtility?.detectURL(ipString: "\(profilePic)" as! String)
            let userImgUrl = URL(string: userImgPath!)
            
            cell.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.profileImage.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2.0
            cell.profileImage.layer.masksToBounds = true
            
            cell.lblName.text = "\(username ?? "")"
            
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.moderatorUserCV {
            let obj = self.speakersRoomArray[indexPath.row]
//            let Userid = obj["key"] as? String ?? ""
//            let userValues = obj["value"] as? NSDictionary
//
//            var UserObj =  [ String : Any ]()
//            UserObj["key"] = Userid
//            UserObj["value"] = userValues
//
            let yourVC = SpaceUserProfileVC()
            yourVC.roomId = self.roomId
            
            yourVC.UserObj = obj
            if #available(iOS 15.0, *) {
                if let sheet = yourVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                }
            } else {
                // Fallback on earlier versions
            }
            self.present(yourVC, animated: true, completion: nil)
        }else{
            let obj = self.liveRoomArray[indexPath.row]
//            let Userid = obj["key"] as? String ?? ""
//            let userValues = obj["value"] as? NSDictionary
//            let dict = userValues
//            let userModel = dict?["userModel"] as? NSDictionary
//            let userRoleType = dict?["userRoleType"] as? String
//            let username = userModel?["username"] as? String
            let yourVC = SpaceUserProfileVC()
            yourVC.UserObj = obj
            yourVC.roomId = self.roomId
//            yourVC.Userid = Userid
//            yourVC.Username = username ?? ""
//            yourVC.userRoleType = userRoleType ?? "0"
            if #available(iOS 15.0, *) {
                if let sheet = yourVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                }
            } else {
                // Fallback on earlier versions
            }
            self.present(yourVC, animated: true, completion: nil)
        }
       
        
        
//        self.AcceptRaisHandRoom(UserId: Userid)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.userCollectionView.frame.width / 4.0, height: 120.0)
    }
    
    
}

extension ListeningSpaceViewController {
    //MARK: - Agora Voice
   
    func initializeAgoraEngine() {
        // Initializes the Agora engine with your app ID.
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: nil)
    }
    
    func joinChannel() {
        // Allows a user to join a channel.
        agoraKit.joinChannel(byToken: KeyCenter.Token, channelId: self.roomId, info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
            // Joined channel "demoChannel"
            self.agoraKit.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        hideControlButtons()
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func hideControlButtons() {
//        controlButtonsView.isHidden = true
    }
    @IBAction func microphoneButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Stops/Resumes sending the local audio stream.
        agoraKit.muteLocalAudioStream(sender.isSelected)
        if isStart == true{
            if sender.isSelected == true {
                self.MicBtn.setImage(micOffImage, for: .normal)
                self.addLiveRoom(roomID: self.roomId, userRoleType: "2", mic: "0")
            }else {
                self.addLiveRoom(roomID: self.roomId, userRoleType: "2", mic: "1")
                self.MicBtn.setImage(micOnImage, for: .normal)
            }
        }else{
            if sender.isSelected == true {
                self.MicBtn.setImage(micOffImage, for: .normal)
                self.addLiveRoom(roomID: self.roomId, userRoleType: "1", mic: "0")
            }else {
                self.addLiveRoom(roomID: self.roomId, userRoleType: "1", mic: "1")
                self.MicBtn.setImage(micOnImage, for: .normal)
            }
        }
       
        
    }
    
    @IBAction func didClickSwitchSpeakerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Enables/Disables the audio playback route to the speakerphone.
        //
        // This method sets whether the audio is routed to the speakerphone or earpiece. After calling this method, the SDK returns the onAudioRouteChanged callback to indicate the changes.
        agoraKit.setEnableSpeakerphone(sender.isSelected)
    }
}
