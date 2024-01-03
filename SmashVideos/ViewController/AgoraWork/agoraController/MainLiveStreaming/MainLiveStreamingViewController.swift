//
//  MainLiveStreamingViewController.swift
//  SmashVideos
//
//  Created by Mac on 03/07/2023.
//

import UIKit
import AgoraRtcKit
import Firebase
import FirebaseDatabase


class MainLiveStreamingViewController: UIViewController,UITextViewDelegate, SettingsVCDelegate, SettingsVCDataSource, LiveVCDataSource {
    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit {
        return agoraKit
    }
    
    func liveVCNeedSettings() -> Settings {
        return settings
    }
    
    func settingsVC(_ vc: SettingAgroraViewController, didSelect dimension: CGSize) {
        settings.dimension = dimension
    }
    
    func settingsVC(_ vc: SettingAgroraViewController, didSelect frameRate: AgoraVideoFrameRate) {
        settings.frameRate = frameRate
    }
    
    func settingsVCNeedSettings() -> Settings {
        return settings
    }
    
    
    //MARK: - VARS
    
    private lazy var agoraKit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: nil)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        return engine
    }()

    var isAudience = false
    var audienceID = ""
    var audienceName = ""
    var audienceImg = ""
    var isSelected = "Public"
    var LiveStreamingId = ""
    var userData = [userMVC]()
    var i = 0
    private var settings = Settings()
    
    //MARK: - OUTLET
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tfCoin: CustomTextField!
    
    @IBOutlet var tfDescription: UITextView!
    
    
    @IBOutlet var btnPrivateSelected: UIButton!
    @IBOutlet var btnPublicSelected: UIButton!
    
    
    //MARK: - VIEW DID LOAD

    override func viewDidLoad() {
        super.viewDidLoad()
        tfCoin.isUserInteractionEnabled = false
        tfDescription.delegate = self
        self.lblName.text = userData[0].first_name + " " + userData[0].last_name
        tfDescription.text = "Write description"
        tfDescription.textColor = UIColor.lightGray
        tfCoin.text = "0"
        self.liveStream()
    }
    
    //MARK: - View WILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
        
        
    }
    
    
    //MARK: - TEXTVIEW DELEGATE
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    //MARK: - BUTTON ACTION
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        let myViewController = SettingAgroraViewController(nibName: "SettingAgroraViewController", bundle: nil)
        myViewController.delegate = self
        myViewController.dataSource = self
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        i = i + 1
        self.tfCoin.text = "\(i)"
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        if i == 0 {
            i = 0
        }else{
            i = i - 1
        }
        self.tfCoin.text = "\(i)"
       
    }
    
    @IBAction func startLiveBroadcasting(_ sender: UIButton) {
      
        
        settings.roomName = UserDefaultsManager.shared.LiveStreamingId
        settings.role = .broadcaster
        AddToLive()
    
        
//        performSegue(withIdentifier: "mainToLive", sender: nil)
        
       
        let main = UIStoryboard(name: "Main", bundle: nil)
        let liveVC = main.instantiateViewController(withIdentifier: "StartLiveRoomViewController")as! StartLiveRoomViewController
        liveVC.userData = userData
        liveVC.LiveStreamingId = self.LiveStreamingId
        liveVC.dataSource = self
        self.navigationController?.pushViewController(liveVC, animated: true)
        
        
    }
   
    
    
    @IBAction func btnSelected(_ sender: UIButton) {
        if sender == self.btnPrivateSelected{
            self.btnPrivateSelected.setImage(UIImage(named: "red circle"), for: .normal)
            self.btnPrivateSelected.tintColor = UIColor(named: "theme")
            self.btnPublicSelected.setImage(UIImage(named: "gray_circle"), for: .normal)
            self.btnPublicSelected.tintColor = UIColor(named: "lightGrey")
            self.isSelected = "Private"
        }else{
            self.btnPrivateSelected.setImage(UIImage(named: "gray_circle"), for: .normal)
            self.btnPrivateSelected.tintColor = UIColor(named: "lightGrey")
            self.btnPublicSelected.setImage(UIImage(named: "red circle"), for: .normal)
            self.btnPublicSelected.tintColor = UIColor(named: "theme")
            self.isSelected = "Public"
            
        }
        
        print("isSelecte",isSelected)
    }
    
    //MARK: - API
    
    
    func liveStream(){
        let time = Date().millisecondsSince1970
        let date = Date(timeIntervalSince1970: Double(time)/1000)
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
//               dateFormatter.amSymbol = "am"
//               dateFormatter.pmSymbol = "pm"
               let dateString = dateFormatter.string(from: date)
        print(dateString)
        
//        self.loader.isHidden = false
        var uid = UserDefaultsManager.shared.user_id
        ApiHandler.sharedInstance.liveStream(user_id: uid, started_at: "\(dateString)") { (isSuccess, response) in
            
            if isSuccess{
//                self.loader.isHidden = true
                //                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let msg = response?.value(forKey: "msg") as? NSDictionary
                    let LiveStreaming = msg?.value(forKey: "LiveStreaming") as? NSDictionary
                    let LiveStreamingId = LiveStreaming?.value(forKey: "id") as? String
                    self.LiveStreamingId = LiveStreamingId ?? ""
                    UserDefaultsManager.shared.LiveStreamingId = LiveStreamingId ?? ""
                }else{
                    
                }
            }else{
                
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    
    func AddToLive(){

        let userObj = userData[0]

        //Firebase
        let reference = Database.database().reference()
        let LiveUser = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId)
        print("User_Id",LiveUser.key!)

        let defaults = UserDefaults.standard
        defaults.set(LiveUser.key!, forKey: "LiveChat")

        let name = userObj.first_name + " " + userObj.last_name

       

        var parameters = [String : Any]()
        parameters = [
            "description"                       :   "",
            "dualStreaming"                     :   false,
            "duetConnectedUserId"               :   "",
            "isStreamJoinAllow"                 :   false,
            "isVerified"                        :   "0",
            "joinStreamPrice"                   :   "0",
            "onlineType"                        :   "multicast",
            "secureCode"                        :   "",
            "streamJoinAllow"                   :   false ,
            "streamingId"                       :   UserDefaultsManager.shared.LiveStreamingId,
            "userCoins"                         :   "0",

            "userId"                    :   userObj.userID,
            "userName"                  :   name,
            "userPicture"               :   userObj.userProfile_pic,

        ]

        LiveUser.setValue(parameters) { [self](error, ref) in
            if error != nil{
                print(error ?? "")
                return
            }
        }
        
        let chatKey = LiveUser.child("Chat").childByAutoId()
        var chatparameters = [String : String]()
        chatparameters = [
            "comment"                    :   "",
            "commentTime"                :   "",
            "key"                        :   "\(chatKey.key ?? "")",
            "type"                       :   "shareStream",
            "userId"                    :   userObj.userID,
            "userName"                  :   name,
            "userPicture"               :   userObj.userProfile_pic,
        ]
        
        chatKey.setValue(chatparameters) { [self](error, ref) in
            if error != nil{
                print(error ?? "")
                return
            }
        }
        
        settings.roomName = LiveUser.key!
        settings.role = .broadcaster

    }
    
    

}

