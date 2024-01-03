//
//  CreateSpaceViewController.swift
//  SmashVideos
//
//  Created by Mac on 10/04/2023.
//

import UIKit
import AVFAudio

class CreateSpaceViewController: UIViewController,UITextViewDelegate {
    
    
    //MARK: - OUTLET
 
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        aboutTextView.delegate = self
        aboutTextView.text = "What do you want to talk about?"
        aboutTextView.textColor = UIColor.systemGray2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.askPermissionIfNeeded(isOn:false)

    }
    

    func askPermissionIfNeeded(isOn:Bool) {
        if isOn == true {
            switch AVAudioSession.sharedInstance().recordPermission {
                case .granted:
                    print("Permission granted")
                //code and run microphone
                
                self.AddRoomApi(title: aboutTextView.text, privacy: "0", topic_id: "1")
                
                
                case .denied:
                    print("Permission denied")
                let alert = UIAlertController(title: "Error", message: "Please allow microphone usage from settings", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Open settings", style: .default, handler: { action in
                           UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                       }))
                       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                       present(alert, animated: true, completion: nil)
                case .undetermined:
                    print("Request permission here")
                    AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                        // Handle granted
                    })
                @unknown default:
                    print("Unknown case")
                }
            
        }else{
            switch AVAudioSession.sharedInstance().recordPermission {
                case .granted:
                    print("Permission granted")
                case .denied:
                    print("Permission denied")
                case .undetermined:
                    print("Request permission here")
                    AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                       
                    })
                @unknown default:
                    print("Unknown case")
                }
        }
      
    }
    
    
    //MARK: - DELEGATE
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray2 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What do you want to talk about?"
            textView.textColor = UIColor.systemGray2
        }
    }
    //MARK: APIS
    
    private lazy var loader : UIView = {
       return (AppUtility?.createActivityIndicator((UIApplication.shared.keyWindow?.rootViewController?.view)!))!
    }()
    var viewModel = ShowRoomViewModel()
    //MARK:  AddRoomApi
    var addRoomM : AddRoomM?
    func AddRoomApi(title : String,privacy : String,topic_id : String) {
        if AppUtility!.connected() == false{
          //  self.tabBarController?.setTabBarVisible(visible: true, animated: true)
            return
        }

        var userID = UserDefaultsManager.shared.user_id
        // {"user_id":"5332","title":"lms","privacy":"0","topic_id":"1"}
        var parameters = [String : Any]()
        parameters = [
            "user_id"        : userID,
            "title"        : title,
            "privacy"        : privacy,
            "topic_id"        : topic_id
        ]
        print(parameters)
        self.loader.isHidden = false
//        self.isLoading = true
//        AppUtility?.startLoader(view: self.view)
        viewModel.AddRoom(endPoint: "api/\(Endpoint.addRoom.rawValue)", parameters: parameters){ state in
            self.loader.isHidden = true
//            self.isLoading = false
            switch state {
            case .success:
//                if response?.value(forKey: "code") as! NSNumber == 200 {
                
                if self.viewModel.addRoomM?.code == 200 {
                    self.addRoomM = self.viewModel.addRoomM
                    self.addLiveRoom(roomID: self.addRoomM?.msg?.room?.id ?? "")
                   
                }
            case .failure:
                print("failure")
            }
        }
    }
    
    func addLiveRoom(roomID: String) {
        
        var parameters = [String : Any]()
        
        var userModel = [String : Any]()
        let user = self.addRoomM?.msg?.roomMember?[0].user
        userModel = [
            "active"        : user?.active ?? "1",
            "applyVerification"        : "",
            "authToken"        : user?.authToken ?? "",
            "bio"      : user?.bio ?? "",
            "block"      : 0,
            
            "blockByUser"        : "1",
            "button"        : "",
            "city"        : user?.city ?? "",
            "cityId"      : "",
            "country"      : user?.country ?? "",
            
            "countryId"        : user?.countryId ?? "",
            "created"        : user?.created ?? "",
            "device"        : "ios",
            "deviceToken"      : user?.deviceToken ?? "",
            "dob"      : user?.dob ?? "",
            "email"        : user?.email ?? "",
            "fbId"        : "",
            "firstName"        : user?.firstName ?? "",
            "followersCount"      : "0",
            "followingCount"      : "0",
            
            "gender"        : user?.gender ?? "",
            "id"        : UserDefaultsManager.shared.user_id,
            "ip"        : user?.ip ?? "",
            "lastName"      : user?.lastName ?? "",
            "lat"      : user?.lat ?? "",
            "likesCount"        : "0",
            "lng"        : user?.longField ?? "",
            "notification"        : "1",
            "online"      : user?.online ?? "",
            "password"      : user?.password ?? "",
            
            "paypal"        : user?.paypal ?? "",
            "phone"        : user?.phone ?? "",
            "profileGif"        : user?.profileGif ?? "",
            "profilePic"      : user?.profilePic ?? "",
            "profileView"      : user?.profileView ?? "",
            "resetWalletDatetime"        : user?.resetWalletDatetime ?? "",
            "role"        : user?.role ?? "",
            "selected"        : "false",
            "socialType"      : user?.social ?? "",
            "social_id"      : user?.socialId ?? "",
            
            "stateId"        : user?.state ?? "",
            "token"        : "",
            "username"        : user?.username ?? "",
            "verified"      : "0",
            "version"      : "1.0",
            "videoCount"        : "0",
            "visitorCount"        : user?.website ?? "",
            "wallet"        : user?.wallet ?? "",
            "website"      : user?.website ?? ""
            
        ]
        
        
        var Users = [String : Any]()
        Users = [
            "mice"        : "1",
            "online"        : "1",
            "riseHand"        : "0",
            "userRoleType"      : "1"
        ]
        // {"user_id":"5","room_id":"25","moderator":"0"}
        parameters = [
//            "clubId"        : "0",
            "adminId"        : UserDefaultsManager.shared.user_id,
            "created"        : self.addRoomM?.msg?.room?.created ?? "",
            "id"      : roomID,
            "privacyType"      : self.addRoomM?.msg?.room?.privacy ?? "0",
            "riseHandCount"      : "0",
            "riseHandRule"      : "1",
            "roomType"      : "room",
            "title"      : self.addRoomM?.msg?.room?.title ?? ""
        ]
        
        let value = ["": ""] as [String : Any]
        
        SpacesListeners.shared.AddLiveRoom(roomID: roomID, values: parameters, Users: Users , userModel: userModel) { (isSuccess) in
            if isSuccess == true
            {
                print("succefully room create")
//                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
//                myViewController.modalPresentationStyle = .overFullScreen
//                myViewController.isStart = false
//                myViewController.roomId = roomID
//                self.navigationController?.present(myViewController, animated: true)
                SpacesListeners.shared.joinRoom(uid: UserDefaultsManager.shared.user_id, roomId: "\(roomID )") { (isSuccess) in
                    if isSuccess == true
                    {
                        
                    }
                }
                
                let myViewController = ListeningSpaceViewController(nibName: "ListeningSpaceViewController", bundle: nil)
                myViewController.isStart = false
                myViewController.roomName = self.addRoomM?.msg?.room?.title ?? ""
                myViewController.roomId = roomID
                self.navigationController?.pushViewController(myViewController, animated: false)
//                self.dismiss(animated: true)
                
            }
        }
       
        
    }
    
    
    //MARK: - BUTTON ACTION
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addTopicsButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func startNowButtonPressed(_ sender: UIButton) {
        self.askPermissionIfNeeded(isOn:true)
        
    }
   
    
    
}
