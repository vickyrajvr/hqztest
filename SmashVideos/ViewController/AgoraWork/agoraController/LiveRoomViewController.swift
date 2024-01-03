import UIKit
import AgoraRtcKit
import Firebase
import SDWebImage
import FirebaseDatabase

//protocol LiveVCDataSource: NSObjectProtocol {
//    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit
//    func liveVCNeedSettings() -> Settings
//}

class LiveRoomViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var liveCollectionView: UICollectionView!
    
    @IBOutlet weak var broadcastersView: AGEVideoContainer!
    @IBOutlet weak var placeholderView: UIImageView!
    
    @IBOutlet var sessionButtons: [UIButton]!
    
    
    let camera = UIImage(named: "camera-2")
    let unbeauty = UIImage(named: "unbeauty")
    let beauty = UIImage(named: "beauty")
    let unmutevideo = UIImage(named: "unmutevideo")
    let mutevideo = UIImage(named: "mutevideo")
    let unmutemic = UIImage(named: "unmutemic")
    let mutemic = UIImage(named: "mutemic")
    
    
    var mySwitchAccount:[User]? {didSet{}} //:[switchAccount]?{didSet{}}
    var myUser:[User]? {didSet{}}
    var isAudiance = true
    var userImgString = ""
    var userNameString = ""
    var commentsArr = [[String:Any]]()
    var userData = [userMVC]()
    var receiver_id = ""
    var LiveStreamingId = ""
    
    var ip = 0
    var arrliveUser = [[String:Any]]()
//    var myUser:[User]? {didSet{}}
    
    private let beautyOptions: AgoraBeautyOptions = {
        let options = AgoraBeautyOptions()
        options.lighteningContrastLevel = .normal
        options.lighteningLevel = 0.7
        options.smoothnessLevel = 0.5
        options.rednessLevel = 0.1
        return options
    }()
    
    private var agoraKit: AgoraRtcEngineKit {
        return dataSource!.liveVCNeedAgoraKit()
    }
    
    private var settings: Settings {
        return dataSource!.liveVCNeedSettings()
    }
    
    private var isMutedVideo = false {
        didSet {
            // mute local video
            agoraKit.muteLocalVideoStream(isMutedVideo)
           // videoMuteButton.isSelected = isMutedVideo
        }
    }
    
    private var isMutedAudio = false {
        didSet {
            // mute local audio
            agoraKit.muteLocalAudioStream(isMutedAudio)
           // audioMuteButton.isSelected = isMutedAudio
        }
    }
    
    private var isBeautyOn = false {
        didSet {
            // improve local render view
            agoraKit.setBeautyEffectOptions(isBeautyOn,
                                            options: isBeautyOn ? beautyOptions : nil)
            //beautyEffectButton.isSelected = isBeautyOn
        }
    }
    
    private var isSwitchCamera = false {
        didSet {
            agoraKit.switchCamera()
        }
    }
    
    private var videoSessions = [VideoSession]() {
        didSet {
//            placeholderView.isHidden = (videoSessions.count == 0 ? false : true)
            // update render view layout
            updateBroadcastersView()
        }
    }
    
    private let maxVideoSession = 4
    
    weak var dataSource: LiveVCDataSource?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
        self.mySwitchAccount = User.readUserFromArchive() //switchAccount.readswitchAccountFromArchive()
        setup()
        updateButtonsVisiablity()
        loadAgoraKit()
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //         feedCV.layoutIfNeeded()
        self.liveCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.liveCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: true)
        liveCollectionView.isPagingEnabled = true
        liveCollectionView.setCollectionViewLayout(layout, animated: true)

//        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(LiveRoomViewController.handleDoubleTap(_:)))
//        doubleTapGR.delegate = self
//        doubleTapGR.numberOfTapsRequired = 2
//        view.addGestureRecognizer(doubleTapGR)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
   
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("sender?.view!.tag",sender.view!.tag)
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: (sender.view!.tag), section: 0))as! cameraCollectionViewCell
        cell.backView.isHidden = true
    }

    @objc func handleTap1(sender: UITapGestureRecognizer) {
        print("sender?.view!.tag",sender.view!.tag)
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: (sender.view!.tag), section: 0))as! cameraCollectionViewCell
        cell.commentView.isHidden = true
    }

    
    func setup(){
        self.Comments()
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeUser(notification:)), name: Notification.Name("removeLiveUserNoti"), object: nil)

        if self.isAudiance == true {
            self.JoinStream()
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.loadComments(notification:)), name: Notification.Name("loadComments"), object: nil)
    }
    @objc func removeUser(notification: Notification) {
      // Take Action on Notification
        
        leaveChannel()
        AppUtility?.dismissPopAllViewViewControllers()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    //MARK: - ui action
    

    @objc func doSwitchCameraPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! cameraCollectionViewCell

        isSwitchCamera.toggle()
        cell.backView.isHidden = true
    }

   @objc func doBeautyPressed(sender: UIButton) {
       let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! cameraCollectionViewCell
        isBeautyOn.toggle()
       cell.backView.isHidden = true
       
       if isBeautyOn {
           cell.beautyEffectButton.setImage(beauty, for: .normal)
//                cell.beautyEffectButton.backgroundColor = UIColor(named: "theme")
       }else {
           cell.beautyEffectButton.setImage(unbeauty, for: .normal)
//                cell.beautyEffectButton.backgroundColor = UIColor(named: "theme")
       }
    }

    @objc func doMuteVideoPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! cameraCollectionViewCell
        isMutedVideo.toggle()
        cell.backView.isHidden = true
        
        if isMutedVideo {
            cell.videoMuteButton.setImage(unmutevideo, for: .normal)
        }else {
            cell.videoMuteButton.setImage(mutevideo, for: .normal)
        }

        
    }

   @objc func doMuteAudioPressed(sender: UIButton) {
       let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! cameraCollectionViewCell
        isMutedAudio.toggle()
       cell.backView.isHidden = true
       
       if isMutedAudio {
           cell.audioMuteButton.setImage(mutemic, for: .normal)
//                cell.audioMuteButton.backgroundColor = UIColor(named: "theme")
       }else {
           cell.audioMuteButton.setImage(unmutemic, for: .normal)
//                cell.audioMuteButton.backgroundColor = UIColor(named: "theme")
       }
    }

    
    
    @objc func cancelButtonPressed(sender:UIButton){
        leaveChannel()
//        AppUtility?.dismissPopAllViewViewControllers()
    }
    @objc func shareButtonPressed(sender:UIButton){
        
//        if let rootViewController = UIApplication.topViewController() {
//            let myViewController = InviteLiveFriendsViewController(nibName: "InviteLiveFriendsViewController", bundle: nil)
//            myViewController.modalPresentationStyle = .overFullScreen
//        myViewController.navigationController?.isNavigationBarHidden = true
//        myViewController.navigationController?.present(myViewController, animated: true)
////
//        let myViewController = InviteLiveFriendsViewController(nibName: "InviteLiveFriendsViewController", bundle: nil)
//
//        // myViewController.modalPresentationStyle = .overFullScreen
//
//        let nav = UINavigationController(rootViewController: myViewController)
////        nav.modalPresentationStyle = .overFullScreen
//        nav.modalPresentationStyle = .overFullScreen
//        present(nav, animated: true, completion: nil)
        
        
//        }
       
    }
    @objc func cancel(sender:UIButton){
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! cameraCollectionViewCell
        cell.backView.isHidden = true
    }
    
    
    
    @objc func chatButtonPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as? cameraCollectionViewCell
        cell?.commentView.isHidden = false
    }
//
    var type = "comment"
    @objc func btnSendComment(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! cameraCollectionViewCell
        if cell.tfComments.text == "" {
            self.showToast(message: "Empty Field", font: UIFont.systemFont(ofSize: 13.0))
        }else {
            type = "comment"
            self.commentTxt = cell.tfComments.text ?? ""
            AddCommentsToLiveChat(tag: sender.tag)
        }
      
        
       
    }
//
    @objc func cameraFunctionButtonPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! cameraCollectionViewCell
        cell.backView.isHidden = false
        
    }
    var commentTxt = ""
    @objc func giftButtonPresed(sender: UIButton) {
        type = "gift"
//        let myViewController = CoinShareViewController(nibName: "CoinShareViewController", bundle: nil)
//        myViewController.myUser = self.myUser
//        myViewController.receiver_id = self.receiver_id
//        myViewController.modalPresentationStyle = .overCurrentContext
//        myViewController.type = self.type
//
//        myViewController.callback = { (id, gift) -> Void in
//                    print("callback")
//                    print(id)
//                    print(gift)
//            self.commentTxt = gift
//            self.AddCommentsToLiveChat(tag: sender.tag)
//                }
//
//
//        myViewController.callback1 = { string in
//            print("string: ",string)
//            if string == "giftSent" {
////                self.AddCommentsToLiveChat(tag: sender.tag)
//            }
//        }
//
//
//        self.present(myViewController, animated: true, completion: nil)
        
      
        
    }
    
    @objc func reportButtonPresed(sender: UIButton) {
        
        let myViewController = ReportDetailViewController(nibName: "ReportDetailViewController", bundle: nil)
        myViewController.otherUserID = self.receiver_id
        myViewController.liveStreamId = UserDefaultsManager.shared.LiveStreamingId
        myViewController.modalPresentationStyle = .overFullScreen
        self.present(myViewController, animated: true, completion: nil)
        
        
//        type = "gift"
//        let myViewController = CoinShareViewController(nibName: "CoinShareViewController", bundle: nil)
//        myViewController.myUser = self.myUser
//        myViewController.receiver_id = self.receiver_id
//        myViewController.modalPresentationStyle = .overCurrentContext
//        myViewController.type = self.type
//
//        myViewController.callback = { (id, gift) -> Void in
//                    print("callback")
//                    print(id)
//                    print(gift)
//            self.commentTxt = gift
//            self.AddCommentsToLiveChat(tag: sender.tag)
//                }
//
//
//        myViewController.callback1 = { string in
//            print("string: ",string)
//            if string == "giftSent" {
////                self.AddCommentsToLiveChat(tag: sender.tag)
//            }
//        }
//
//
//        self.present(myViewController, animated: true, completion: nil)
        
      
        
    }
    
    
    
}

private extension LiveRoomViewController {
    func updateBroadcastersView() {
        // video views layout
        if videoSessions.count == maxVideoSession {
            broadcastersView.reload(level: 0, animated: true)
        } else {
            var rank: Int
            var row: Int
            
            if videoSessions.count == 0 {
                broadcastersView.removeLayout(level: 0)
                return
            } else if videoSessions.count == 1 {
                rank = 1
                row = 1
            } else if videoSessions.count == 2 {
                rank = 1
                row = 2
            } else {
                rank = 2
                row = Int(ceil(Double(videoSessions.count) / Double(rank)))
            }
            
            let itemWidth = CGFloat(1.0) / CGFloat(rank)
            let itemHeight = CGFloat(1.0) / CGFloat(row)
            let itemSize = CGSize(width: itemWidth, height: itemHeight)
            let layout = AGEVideoLayout(level: 0)
                        .itemSize(.scale(itemSize))
            
            broadcastersView
                .listCount { [unowned self] (_) -> Int in
                    return self.videoSessions.count
                }.listItem { [unowned self] (index) -> UIView in
                    return self.videoSessions[index.item].hostingView
                }
            
            broadcastersView.setLayouts([layout], animated: true)
        }
    }
    
    func updateButtonsVisiablity() {
        guard let sessionButtons = sessionButtons else {
            return
        }
        
        let isHidden = settings.role == .audience
        
        for item in sessionButtons {
            item.isHidden = isHidden
        }
    }
    
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
}

private extension LiveRoomViewController {
    func getSession(of uid: UInt) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        return nil
    }
    
    func videoSession(of uid: UInt) -> VideoSession {
        if let fetchedSession = getSession(of: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
}

//MARK: - Agora Media SDK
private extension LiveRoomViewController {
    func loadAgoraKit() {
        guard let channelId = settings.roomName else {
            return
        }
        
        setIdleTimerActive(false)
        agoraKit.delegate = self
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setClientRole(settings.role)
        agoraKit.enableDualStreamMode(true)
    
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(
                size: settings.dimension,
                frameRate: settings.frameRate,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .adaptative, mirrorMode: .auto
            )
        )
        
        if settings.role == .broadcaster {
            addLocalSession()
            agoraKit.startPreview()
        }
    
        if settings.role == .audience {}
        agoraKit.joinChannel(byToken: KeyCenter.Token, channelId: channelId, info: nil, uid: 0, joinSuccess: nil)
        agoraKit.setEnableSpeakerphone(true)
    }
    
    func addLocalSession() {
        let localSession = VideoSession.localSession()
        localSession.updateInfo(fps: settings.frameRate.rawValue)
        videoSessions.append(localSession)
        agoraKit.setupLocalVideo(localSession.canvas)
    }
    
    func leaveChannel() {
  
        agoraKit.setupLocalVideo(nil)
        agoraKit.leaveChannel(nil)
        if settings.role == .broadcaster {
            agoraKit.stopPreview()
            
            self.myUser = User.readUserFromArchive()
            let reference = Database.database().reference()
            print(self.myUser?[0].id)
//            NotificationCenter.default.post(name: Notification.Name("removeLiveUserNoti"), object:nil,userInfo:nil)
            let LiveUser = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).removeValue()
            
        }
        
        setIdleTimerActive(true)
        
        navigationController?.popViewController(animated: true)
    }
    
    func JoinStream(){
        
        self.myUser = User.readUserFromArchive()
        if (myUser?.count == 0) || self.myUser == nil{
            return
        }
        let reference = Database.database().reference()
        let JoinStream = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("JoinStream").child(UserDefaultsManager.shared.user_id)

        let ur = (self.myUser?[0].profile_pic)
        let userThumbImgPath = AppUtility?.detectURL(ipString: ur ?? "")
        
        var parameters = [String : Any]()
        parameters = [
            "userId": UserDefaultsManager.shared.user_id,
            "userName":self.myUser?[0].username ?? "",
            "userPic":userThumbImgPath ?? ""
        ]
        JoinStream.setValue(parameters) { [self](error, ref) in
            if error != nil{
                print(error ?? "")
                return
            }
        }
    }
}

// MARK: - AgoraRtcEngineDelegate
extension LiveRoomViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let selfSession = videoSessions.first {
            selfSession.updateInfo(resolution: size)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        if let selfSession = videoSessions.first {
            selfSession.updateChannelStats(stats)
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        guard videoSessions.count <= maxVideoSession else {
            return
        }
        
        let userSession = videoSession(of: uid)
        userSession.updateInfo(resolution: size)
        agoraKit.setupRemoteVideo(userSession.canvas)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() where session.uid == uid {
            indexToDelete = index
            break
        }
        
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            
            // release canvas's view
            deletedSession.canvas.view = nil
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        if let session = getSession(of: stats.uid) {
            session.updateVideoStats(stats)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
        if let session = getSession(of: stats.uid) {
            session.updateAudioStats(stats)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("warning code: \(warningCode.description)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("warning code: \(errorCode.description)")
    }
    
    
}


//MARK:- EXTENSION FOR COLLECTION VIEW

extension LiveRoomViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        2
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.isAudiance == true {
            
//            if section == 0{
//                return 2
//            }else {
//                return self.arrliveUser.count
//            }
//        }else {
            return 2
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 0 {
//
//        }else {
//
//        }
        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cancelCollectionViewCell", for: indexPath)as! cancelCollectionViewCell
            cell.btnCancel.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: .touchUpInside)
            return cell
            
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraCollectionViewCell", for: indexPath)as! cameraCollectionViewCell
            cell.commentsArr = self.commentsArr
            cell.backView.isHidden = true
            cell.commentView.isHidden = true
            
            cell.btnCancel.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: .touchUpInside)
                 
            cell.shareBrodcastBtn.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: .touchUpInside)
            
            cell.cancelButton.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
            cell.cancelButton.tag = indexPath.row
            
            
            if isBeautyOn {
                cell.beautyEffectButton.setImage(unbeauty, for: .normal)
//                cell.beautyEffectButton.backgroundColor = UIColor(named: "theme")
            }else {
                cell.beautyEffectButton.setImage(beauty, for: .normal)
//                cell.beautyEffectButton.backgroundColor = UIColor(named: "theme")
            }
            
            if isMutedAudio {
                cell.audioMuteButton.setImage(unmutemic, for: .normal)
//                cell.audioMuteButton.backgroundColor = UIColor(named: "theme")
            }else {
                cell.audioMuteButton.setImage(mutemic, for: .normal)
//                cell.audioMuteButton.backgroundColor = UIColor(named: "theme")
            }
            
            
            if isMutedVideo {
                cell.videoMuteButton.setImage(unmutevideo, for: .normal)
            }else {
                cell.videoMuteButton.setImage(mutevideo, for: .normal)
            }
            
            if isSwitchCamera {
                cell.cameraButton.setImage(camera, for: .normal)
            }else {
                cell.cameraButton.setImage(camera, for: .normal)
            }
            
            
            cell.cameraButton.addTarget(self, action: #selector(doSwitchCameraPressed(sender:)), for: .touchUpInside)
            cell.cameraButton.tag = indexPath.row
            
            cell.beautyEffectButton.addTarget(self, action: #selector(doBeautyPressed(sender:)), for: .touchUpInside)
            cell.beautyEffectButton.tag = indexPath.row
            
            cell.effectBtnAction.addTarget(self, action: #selector(doBeautyPressed(sender:)), for: .touchUpInside)
            cell.effectBtnAction.tag = indexPath.row
            
            
            
            cell.videoMuteButton.addTarget(self, action: #selector(doMuteVideoPressed(sender:)), for: .touchUpInside)
            cell.videoMuteButton.tag = indexPath.row
            
            cell.audioMuteButton.addTarget(self, action: #selector(doMuteAudioPressed(sender:)), for: .touchUpInside)
            cell.audioMuteButton.tag = indexPath.row
            
            cell.chatButton.addTarget(self, action: #selector(chatButtonPressed(sender:)), for: .touchUpInside)
            cell.chatButton.tag = indexPath.row
            
            
            
//            @IBOutlet weak var firstName : UILabel!
//            @IBOutlet weak var lblLike : UILabel!
//            @IBOutlet weak var userImg : UIImageView!
            
           

//            self.userImg.sd_imageIndicator = SDWebImageActivityIndicator.white
//            self.userImg.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: obj.userProfile_pic))!), placeholderImage: #imageLiteral(resourceName: "noUserImg"))
//
//            self.firstName.text = obj.first_name
//            self.lastName.text = obj.last_name
//
//
            cell.cameraFucntionButton.layer.cornerRadius = cell.cameraFucntionButton.frame.height / 2.0
            cell.cameraFucntionButton.layer.masksToBounds = true
            if isAudiance == true{
                cell.btnReport.isHidden = false
                cell.cameraFucntionButton.isHidden = true
                cell.btnGift.isHidden = false
                print("mySwitchAccount",self.mySwitchAccount?[0].profile_pic)
                
                let obj = self.arrliveUser
                let userImg = userImgString
                let userImgUrl = URL(string: userImg)
               // let userObj = userData[0]
                
               // let profilePic = AppUtility?.detectURL(ipString: userObj.userProfile_pic)
               // let userImg = URL(string: profilePic!)
                
                
                cell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.userImg.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
                cell.userImg.layer.cornerRadius = cell.userImg.frame.height / 2.0
                cell.userImg.layer.masksToBounds = true
                cell.firstName.text = userNameString
                
//                cell.lblLike.text = ""
//                cell.lblUserLive.text = "0"
                
                let LiveUsers = Database.database().reference().child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("LikesStream")
                LiveUsers.observe(DataEventType.value, with: { (snapshot) in
                        //self.commentsArr.removeAll()
                        let likes = snapshot.children.allObjects.count
                        print("total likes: ", likes)
                        if likes == 0 {
                            cell.lblLike.text = " likes"
                        }else {
                            cell.lblLike.text = "\(likes) likes"
                        }
                    })
                let JoinStream = Database.database().reference().child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("JoinStream")
                JoinStream.observe(DataEventType.value, with: { (snapshot) in
                        //self.commentsArr.removeAll()
                        let Join = snapshot.children.allObjects.count
                        print("total JoinStream: ", Join)
                        cell.lblUserLive.text = "\(Join)"
                    if Join == 0 {
                        self.leaveChannel()
                    }
                    })
            }else{
                cell.btnReport.isHidden = true
                cell.cameraFucntionButton.isHidden = false
                cell.btnGift.isHidden = true
                print("mySwitchAccount",self.mySwitchAccount?[0].profile_pic)
                let userImg = self.mySwitchAccount?[0].profile_pic ?? "" // BASE_URL + (self.mySwitchAccount?[0].profile_pic ?? "")
                let userImgUrl = URL(string: userImg)
               // let userObj = userData[0]
                
               // let profilePic = AppUtility?.detectURL(ipString: userObj.userProfile_pic)
               // let userImg = URL(string: profilePic!)
                
                
                cell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.userImg.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
                
                cell.userImg.layer.cornerRadius = cell.userImg.frame.height / 2.0
                cell.userImg.layer.masksToBounds = true
                cell.firstName.text = self.mySwitchAccount?[0].username
                
//                cell.lblLike.text = ""
//                cell.lblUserLive.text = "0"
                let LiveUsers = Database.database().reference().child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("LikesStream")
                LiveUsers.observe(DataEventType.value, with: { (snapshot) in
                        //self.commentsArr.removeAll()
                        let likes = snapshot.children.allObjects.count
                        print("total likes: ", likes)
                        if likes == 0 {
                            cell.lblLike.text = " likes"
                        }else {
                            self.generateAnimatedViews()
                            cell.lblLike.text = "\(likes) likes"
                        }
                    })
                let JoinStream = Database.database().reference().child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("JoinStream")
                JoinStream.observe(DataEventType.value, with: { (snapshot) in
                        //self.commentsArr.removeAll()
                        let Join = snapshot.children.allObjects.count
                        print("total JoinStream: ", Join)
                        cell.lblUserLive.text = "\(Join)"
                    })
            }
            
            
            cell.btnReport.addTarget(self, action: #selector(reportButtonPresed(sender:)), for: .touchUpInside)
            cell.btnReport.tag = indexPath.row
            
            cell.btnGift.addTarget(self, action: #selector(giftButtonPresed(sender:)), for: .touchUpInside)
            cell.btnGift.tag = indexPath.row
            
            cell.cameraFucntionButton.addTarget(self, action: #selector(cameraFunctionButtonPressed(sender:)), for: .touchUpInside)
            cell.cameraFucntionButton.tag = indexPath.row
            
            
            cell.btnSend.addTarget(self, action: #selector(btnSendComment(sender:)), for: .touchUpInside)
            cell.btnSend.tag = indexPath.row
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
            cell.backView.tag = indexPath.row
            tap.view?.tag = indexPath.row
            cell.backView.isUserInteractionEnabled = true
            cell.backView.addGestureRecognizer(tap)
            
            
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(sender:)))
            cell.userBackView.tag = indexPath.row
            tap1.view?.tag = indexPath.row
            cell.userBackView.isUserInteractionEnabled = true
            cell.userBackView.addGestureRecognizer(tap1)
           
            return cell
           
            
        }
        
        
    }
    
    func generateAnimatedViews() {
       let image = drand48() > 0.5 ? #imageLiteral(resourceName: "heartAniIcon") : #imageLiteral(resourceName: "heartAniIcon")
       let imageView = UIImageView(image: image)
       let dimension = 20 + drand48() * 10
       imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
       
       let animation = CAKeyframeAnimation(keyPath: "position")
       
       animation.path = AppUtility?.customPath().cgPath
       animation.duration = 2 + drand48() * 3
       animation.fillMode = CAMediaTimingFillMode.forwards
       animation.isRemovedOnCompletion = true
       animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
       
       imageView.layer.add(animation, forKey: nil)
       view.addSubview(imageView)
       DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
           imageView.removeFromSuperview()
       }
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.liveCollectionView.frame.width, height: self.liveCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.liveCollectionView {
//            if pageControl.currentPage == indexPath.row {
                guard let visible = collectionView.visibleCells.first else { return }
                guard let index = collectionView.indexPath(for: visible)?.row else { return }
//                pageControl.currentPage = index
//            }

        }
    }
    
    
    func Comments(){
        let cell = self.liveCollectionView.cellForItem(at: IndexPath(row: 0, section: 0))as? cameraCollectionViewCell
        let childRef = Database.database().reference().child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("Chat")

            childRef.observe(DataEventType.value, with: { (snapshot) in
                self.commentsArr.removeAll()
                for cmnt in snapshot.children.allObjects as! [DataSnapshot] {
                    let artistObject = cmnt.value as? [String: AnyObject]
                    
                    //if UserDefaultsManager.shared.LiveStreamingId ==
                    self.commentsArr.append(artistObject!)
//                    self.scrollToBottom()
                    print(artistObject!)
//                    cell?.tblComment.reloadData()

                }
                print(self.commentsArr)
                NotificationCenter.default.post(name: Notification.Name("loadComments"), object:nil,userInfo:["commentsArray":self.commentsArr])
                
              //  for self.commentsArr.count
            })
    }
    
//    func scrollToBottom(){
//        let cell = self.liveCollectionView.cellForItem(at: IndexPath(row: 0, section: 0))as? cameraCollectionViewCell
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: 1, section: 0)
//            self.liveCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
//
//                //.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }

    
    func AddCommentsToLiveChat(tag:Int){

        let cell = liveCollectionView.cellForItem(at: IndexPath(row: tag, section: 0))as? cameraCollectionViewCell
        
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ssZ"
            let resultDate = formatter.string(from: date)

            print("currentDateTime",resultDate)

            var myUser: [User]? {didSet {}}
            myUser = User.readUserFromArchive()

            let reference = Database.database().reference()
            let LiveUser = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("Chat").childByAutoId()


            var parameters = [String : Any]()
        let imgUrl = self.mySwitchAccount?[0].profile_pic ?? ""
        let userId = myUser![0].id
        
            parameters = [
                "comment"                   : self.commentTxt, //cell?.tfComments.text!,
                "commentTime"               : resultDate,
                "key"                       : LiveUser.key,
                "type"                      : self.type,
                "userId"                    : myUser![0].id,
                "userName"                  : myUser![0].username ,
                "userPicture"               : AppUtility?.detectURL(ipString: imgUrl) ?? ""

            ]

            LiveUser.setValue(parameters) { (error, ref) in
                if error != nil{
                    print(error ?? "")
                    return
                }
            }
        cell?.tfComments.text =  nil

        }
    
   
}
