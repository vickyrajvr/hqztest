//
//  SpacesViewController.swift
//  SmashVideos
//
//  Created by Mac on 06/04/2023.
//

import UIKit
import SDWebImage
import Firebase
class SpacesViewController: UIViewController {
    
    //MARK: - OUTLET

    @IBOutlet weak var uperViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var spaceCollectionView: UICollectionView!
    
    //MARK: - VIEW DID LOAd
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        spaceCollectionView.register(UINib(nibName: "SpacesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpacesCollectionViewCell")
        
        let height = self.spaceCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.uperViewHeightConst.constant = height
        print("height: ",height)
       
        showAllRoomsApi()
        SpacesListeners.shared.LiveRoom() { (isSuccess, message) in
            if isSuccess == true
            {
                print(message)
                self.showAllRoomsApi()
            }
            
        }
        //self.spaceCollectionView.reloadData()
        
        
    }

    //MARK: APIS
    
    private lazy var loader : UIView = {
       return (AppUtility?.createActivityIndicator((UIApplication.shared.keyWindow?.rootViewController?.view)!))!
    }()
    var viewModel = ShowRoomViewModel()
    var showRoomM : ShowRoomM?
    var roomObjectArray = [ShowRoomObject]()
    func showAllRoomsApi() {

        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        var parameters = [String : Any]()
        parameters = [
            "user_id"        : userID
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.showRoomApi(endPoint: "api/\(Endpoint.showRooms.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
                
                if self.viewModel.showRoomM?.code == 200 {
                    
                    if self.viewModel.roomObjectArray.count ?? 0 > 0 {
                        self.roomObjectArray = self.viewModel.roomObjectArray
                        self.spaceCollectionView.delegate = self
                        self.spaceCollectionView.dataSource = self
                        self.spaceCollectionView.reloadData()
                        
                        let height = self.spaceCollectionView.collectionViewLayout.collectionViewContentSize.height
                        self.uperViewHeightConst.constant = height
                        print("height: ",height)
                        
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
                    
                    let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
                    myViewController.modalPresentationStyle = .overFullScreen
                    myViewController.isStart = true
                    myViewController.roomId = room_id //self.joinRoomM?.msg?.room?.id ?? ""
                    myViewController.roomName = roomName
                    self.navigationController?.present(myViewController, animated: true)
                    SpacesListeners.shared.joinRoom(uid: userID, roomId: "\(self.joinRoomM?.msg?.room?.id ?? "")") { (isSuccess) in
                        if isSuccess == true
                        {
                            
                        }
                    }
                }
            case .failure:
                print("failure")
                SpacesListeners.shared.joinRoom(uid: userID, roomId: room_id) { (isSuccess) in
                    if isSuccess == true
                    {
                        
                    }
                }
                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
                myViewController.modalPresentationStyle = .overFullScreen
                myViewController.isStart = true
                myViewController.roomId = room_id // self.joinRoomM?.msg?.room?.id ?? ""
                myViewController.roomName = roomName
                self.navigationController?.present(myViewController, animated: true)
            }
        }
    }
    
  
    
   
    

    //MARK: - BUTTON ACTION

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createSpaceButtonPressed(_ sender: UIButton) {
        let myViewController = CreateSpaceViewController(nibName: "CreateSpaceViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW

extension SpacesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.roomObjectArray.count)
        return self.roomObjectArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpacesCollectionViewCell", for: indexPath)as! SpacesCollectionViewCell
        cell.music()
        let obj = self.roomObjectArray
        let topic = obj[indexPath.row].topic
        let room = obj[indexPath.row].room
        let roomMembers = obj[indexPath.row].roomMember
        
        for i in 0..<(roomMembers?.count ?? 0) {
            let ob = roomMembers?[i]
            if ob?.moderator == "1"{
                let url = URL(string:(AppUtility?.detectURL(ipString: ob?.user?.profilePic ?? ""))!)
                print(url)
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named:"noMusicIcon"))
            }
        }
        cell.lblMainLive.text = room?.title
        cell.lblTag.text = topic?.title
        //cell.imgHost
        cell.imgHost.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgHost.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: obj[indexPath.row].roomMember?[0].user?.profilePic ?? ""))!), placeholderImage: UIImage(named:"noMusicIcon"))
        cell.lblUsername.text = "1"
        cell.lblListener.text = "\(roomMembers?.count ?? 0) Listening"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: spaceCollectionView.frame.width, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.roomObjectArray
        let topic = obj[indexPath.row].topic
        let room = obj[indexPath.row].room
        let roomMembers = obj[indexPath.row].roomMember
        var moderator = "0"
        
        var userRoleType = "0"
        if UserDefaultsManager.shared.spaceRoomId == room?.id ?? "" {
            
            for i in 0..<(roomMembers?.count ?? 0) {
                let obj = roomMembers?[i]
//                let user = obj?.user
//                if UserDefaultsManager.shared.spaceRoomId == obj?.roomId {
//                    addLiveRoom(roomID: room?.id ?? "", user: user, room: room)
//                }

                    if obj?.userId == UserDefaultsManager.shared.user_id {
                        if obj?.moderator == "1" {
                            userRoleType = "1"
                        }else if obj?.moderator == "2" {
                            userRoleType = "2"
                        }else {
                            userRoleType = "0"
                        }
                        let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
                        myViewController.modalPresentationStyle = .overFullScreen
                        myViewController.isStart = true
                        myViewController.userRoleType = userRoleType
                        myViewController.roomId = room?.id ?? "" //self.joinRoomM?.msg?.room?.id ?? ""
                        myViewController.roomName = "\(room?.title ?? "")"
                        self.navigationController?.present(myViewController, animated: true)
                        return
                        
//                        moderator = "1"
                        //                    SpacesListeners.shared.JoinModeratorLiveRoom(roomID: room?.id ?? "", user_id: UserDefaultsManager.shared.user_id, userRoleType: "1") { (isSuccess) in
                        //                        if isSuccess == true
                        //                        {
                        //
                        //                        }
                    }
//                }
            }
            
            let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
            myViewController.modalPresentationStyle = .overFullScreen
            myViewController.isStart = true
            myViewController.userRoleType = userRoleType
            myViewController.roomId = room?.id ?? "" //self.joinRoomM?.msg?.room?.id ?? ""
            myViewController.roomName = "\(room?.title ?? "")"
            self.navigationController?.present(myViewController, animated: true)
            

        }else {
            let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
            myViewController.modalPresentationStyle = .overFullScreen
            myViewController.isStart = true
            myViewController.userRoleType = userRoleType
            myViewController.roomId = room?.id ?? "" //self.joinRoomM?.msg?.room?.id ?? ""
            myViewController.roomName = "\(room?.title ?? "")"
            self.navigationController?.present(myViewController, animated: true)
            
//            self.JoinRoomApi(room_id: room?.id ?? "", moderator: "0", roomName: "\(room?.title ?? "")")
        }
        
       
         
//        print(UserDefaultsManager.shared.spaceRoomId)
//        print(room?.id ?? "")
//        if UserDefaultsManager.shared.spaceRoomId == room?.id ?? "" {
//
////            let user: Users?
//            var user = roomMembers?.count
//            let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
//            myViewController.modalPresentationStyle = .overFullScreen
//            myViewController.isStart = true
//            myViewController.roomId = room?.id ?? "" //self.joinRoomM?.msg?.room?.id ?? ""
//            myViewController.roomName = "\(room?.title ?? "")"
//            self.navigationController?.present(myViewController, animated: true)
//        }else {
//
//        }
//
        
        
        
        
    }
    
//    func addLiveRoom(roomID: String, user: Users?, room: Room?) {
//
//        var parameters = [String : Any]()
//
//        var userModel = [String : Any]()
//        let user = user
//        userModel = [
//            "active"        : user?.active ?? "1",
//            "applyVerification"        : "",
//            "authToken"        : user?.authToken ?? "",
//            "bio"      : user?.bio ?? "",
//            "block"      : 0,
//
//            "blockByUser"        : "1",
//            "button"        : "",
//            "city"        : user?.city ?? "",
//            "cityId"      : "",
//            "country"      : user?.country ?? "",
//
//            "countryId"        : user?.countryId ?? "",
//            "created"        : user?.created ?? "",
//            "device"        : "ios",
//            "deviceToken"      : user?.deviceToken ?? "",
//            "dob"      : user?.dob ?? "",
//            "email"        : user?.email ?? "",
//            "fbId"        : "",
//            "firstName"        : user?.firstName ?? "",
//            "followersCount"      : "0",
//            "followingCount"      : "0",
//
//            "gender"        : user?.gender ?? "",
//            "id"        : UserDefaultsManager.shared.user_id,
//            "ip"        : user?.ip ?? "",
//            "lastName"      : user?.lastName ?? "",
//            "lat"      : user?.lat ?? "",
//            "likesCount"        : "0",
//            "lng"        : user?.longField ?? "",
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
//            "role"        : user?.role ?? "",
//            "selected"        : "false",
//            "socialType"      : user?.social ?? "",
//            "social_id"      : user?.socialId ?? "",
//
//            "stateId"        : user?.state ?? "",
//            "token"        : "",
//            "username"        : user?.username ?? "",
//            "verified"      : "0",
//            "version"      : "1.0",
//            "videoCount"        : "0",
//            "visitorCount"        : user?.website ?? "",
//            "wallet"        : user?.wallet ?? "",
//            "website"      : user?.website ?? ""
//
//        ]
//
//
//        var Users = [String : Any]()
//        Users = [
//            "mice"        : "1",
//            "online"        : "1",
//            "riseHand"        : "0",
//            "userRoleType"      : "1"
//        ]
//        // {"user_id":"5","room_id":"25","moderator":"0"}
//        parameters = [
////            "clubId"        : "0",
//            "adminId"        : UserDefaultsManager.shared.user_id,
//            "created"        : room?.created ?? "",
//            "id"      : roomID,
//            "privacyType"      : room?.privacy ?? "0",
//            "riseHandCount"      : "0",
//            "riseHandRule"      : "1",
//            "roomType"      : "room",
//            "title"      : room?.title ?? ""
//        ]
//
//        let value = ["": ""] as [String : Any]
//
//        SpacesListeners.shared.AddLiveRoom(roomID: roomID, values: parameters, Users: Users , userModel: userModel) { (isSuccess) in
//            if isSuccess == true
//            {
//                print("succefully room create")
////                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
////                myViewController.modalPresentationStyle = .overFullScreen
////                myViewController.isStart = false
////                myViewController.roomId = roomID
////                self.navigationController?.present(myViewController, animated: true)
////                SpacesListeners.shared.joinRoom(uid: UserDefaultsManager.shared.user_id, roomId: "\(roomID )") { (isSuccess) in
////                    if isSuccess == true
////                    {
////
////                    }
////                }
//
//                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
//                myViewController.modalPresentationStyle = .overFullScreen
//                myViewController.isStart = true
//                myViewController.roomId = roomID //self.joinRoomM?.msg?.room?.id ?? ""
//                myViewController.roomName = room?.title ?? ""
//                self.navigationController?.present(myViewController, animated: true)
//
//
////                SpacesListeners.shared.joinRoom(uid: userID, roomId: "\(self.joinRoomM?.msg?.room?.id ?? "")") { (isSuccess) in
////                    if isSuccess == true
////                    {
////
////                    }
////                }
////
////                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
////                myViewController.isStart = false
////                myViewController.roomName = room?.title ?? ""
////                myViewController.roomId = roomID
////                self.navigationController?.pushViewController(myViewController, animated: false)
////                self.dismiss(animated: true)
//
//            }
//        }
//
//
//    }
}

