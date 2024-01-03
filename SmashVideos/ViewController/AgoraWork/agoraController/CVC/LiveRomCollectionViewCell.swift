//
//  LiveRomCollectionViewCell.swift
//  WOOW
//
//  Created by Zubair Ahmed on 28/04/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AgoraRtcKit
import SDWebImage

protocol leaveChannalPushToBackProtocol {
    func pushToBackButton(back : Bool)
}
class LiveRomCollectionViewCell: UICollectionViewCell {
    var backDelegate : leaveChannalPushToBackProtocol?
    @IBOutlet weak var contentView1: UIView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet var sessionButtons: [UIButton]!
    
    @IBOutlet weak var broadcastersView: AGEVideoContainer!
    
    @IBOutlet weak var liveCollectionView: UICollectionView!
    
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
        self.contentView1.addSubview(imageView)
       DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
           imageView.removeFromSuperview()
       }
   }
    
     var agoraKit: AgoraRtcEngineKit {
        return dataSource!.liveVCNeedAgoraKit()
    }
    
     var settings: Settings {
        return dataSource!.liveVCNeedSettings()
    }
    
     var videoSessions = [VideoSession]() {
        didSet {
//            placeholderView.isHidden = (videoSessions.count == 0 ? false : true)
            // update render view layout
            updateBroadcastersView()
        }
    }
     let maxVideoSession = 4
    var mic = "1"
    weak var dataSource: LiveVCDataSource?
    
    var arrliveUser = [[String:Any]]()
    
    private let beautyOptions: AgoraBeautyOptions = {
        let options = AgoraBeautyOptions()
        options.lighteningContrastLevel = .normal
        options.lighteningLevel = 0.7
        options.smoothnessLevel = 0.5
        options.rednessLevel = 0.1
        return options
    }()
    
   
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
    
    let camera = UIImage(named: "camera-2")
    let unbeauty = UIImage(named: "unbeauty")
    let beauty = UIImage(named: "beauty")
    let unmutevideo = UIImage(named: "unmutevideo")
    let mutevideo = UIImage(named: "mutevideo")
    let unmutemic = UIImage(named: "unmutemic")
    let mutemic = UIImage(named: "mutemic")
    
    override func awakeFromNib() {
        liveCollectionView.delegate = self
        liveCollectionView.dataSource = self
        liveCollectionView.register(UINib(nibName: "StartCancelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StartCancelCollectionViewCell")
        liveCollectionView.register(UINib(nibName: "StartCameraCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StartCameraCollectionViewCell")
        
        
       // self.setup()
    }
   
   

    @objc func handleTap1(sender: UITapGestureRecognizer) {
        print("sender?.view!.tag",sender.view!.tag)
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: (sender.view!.tag), section: 0))as! StartCameraCollectionViewCell
//        cell.commentView.isHidden = true
    }

    
    var mySwitchAccount:[User]? {didSet{}} //:[switchAccount]?{didSet{}}
    var myUser:[User]? {didSet{}}
    var isAudiance = true
    var userImgString = ""
    var userNameString = ""
    var commentsArr = [[String:Any]]()
    var userData = [userMVC]()
    var receiver_id = ""
    var LiveStreamingId = ""
    
    func setup(){
        JoinStream()
        self.Comments()
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeUser(notification:)), name: Notification.Name("removeLiveUserNoti"), object: nil)

//        NotificationCenter.default.addObserver(self, selector: #selector(self.loadComments(notification:)), name: Notification.Name("loadComments"), object: nil)
        
        
    }
    var index = 0
    func showDataBooking (selectedIndex : Int , arrliveUser : [[String:Any]] ) {
        print(selectedIndex)
//        if index == selectedIndex {
//            settings.role = .audience

        
            updateButtonsVisiablity()
            updateBroadcastersView()

//            dataSource = self
            loadAgoraKit()
//        }else {
            
            index = selectedIndex
            
//            DispatchQueue.main.async {
//                self.leaveChannel()
//
//            }
//        }
        
        self.arrliveUser = arrliveUser
        
        self.userImgString = self.arrliveUser[index]["userPicture"] as? String ?? ""
        self.userNameString = self.arrliveUser[index]["userName"] as? String ?? ""
        StaticData.obj.liveUserName = userNameString
       
        self.receiver_id = self.arrliveUser[index]["userId"] as? String ?? ""
        StaticData.obj.liveUserID = receiver_id
        setup()
    }
    
    @objc func removeUser(notification: Notification) {
      // Take Action on Notification
        
        leaveChannel()
        AppUtility?.dismissPopAllViewViewControllers()

    }
    
    //MARK: - ui action
    
    @objc func chatButtonPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as? StartCameraCollectionViewCell
//        cell?.commentView.isHidden = false
//        cell?.tfComments.isFirstResponder
    }
//
    var type = "comment"
    @objc func btnSendComment(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! StartCameraCollectionViewCell
//        if cell.tfComments.text == "" {
////            self.showToast(message: "Empty Field", font: UIFont.systemFont(ofSize: 13.0))
//        }else {
//            type = "comment"
//            self.commentTxt = cell.tfComments.text ?? ""
//            AddCommentsToLiveChat(tag: sender.tag)
//        }
    }
//
    @objc func cameraFunctionButtonPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! StartCameraCollectionViewCell
//        cell.backView.isHidden = false
        
    }
    var commentTxt = ""
    @objc func giftButtonPresed(sender: UIButton) {
        type = "gift"
        
//        if let rootViewController = UIApplication.topViewController() {
//            let myViewController = CoinShareViewController(nibName: "CoinShareViewController", bundle: nil)
//            myViewController.myUser = self.myUser
//            myViewController.receiver_id = self.receiver_id
//            myViewController.modalPresentationStyle = .overCurrentContext
//            myViewController.type = self.type
//
//            myViewController.callback = { (id, gift) -> Void in
//                        print("callback")
//                        print(id)
//                        print(gift)
//                self.commentTxt = gift
//                self.AddCommentsToLiveChat(tag: sender.tag)
//                    }
//
//
//            myViewController.callback1 = { string in
//                print("string: ",string)
//                if string == "giftSent" {
//    //                self.AddCommentsToLiveChat(tag: sender.tag)
//                }
//            }
//            rootViewController.navigationController?.isNavigationBarHidden = true
//            rootViewController.navigationController?.present(myViewController, animated: true)
//        }
    }
    
    @objc func reportButtonPresed(sender: UIButton) {
        if let rootViewController = UIApplication.topViewController() {
            let myViewController = ReportDetailViewController(nibName: "ReportDetailViewController", bundle: nil)
            myViewController.otherUserID = self.receiver_id
            myViewController.liveStreamId = UserDefaultsManager.shared.LiveStreamingId
            myViewController.modalPresentationStyle = .overFullScreen
            
            rootViewController.navigationController?.isNavigationBarHidden = true
            rootViewController.navigationController?.present(myViewController, animated: true)
        }
    }
    
}

//MARK: BROADCASTING FUNCTIONS
extension LiveRomCollectionViewCell {
    
    @objc func doSwitchCameraPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! StartCameraCollectionViewCell

        isSwitchCamera.toggle()
//        cell.backView.isHidden = true
    }

   @objc func doBeautyPressed(sender: UIButton) {
       let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! StartCameraCollectionViewCell
        isBeautyOn.toggle()
//       cell.backView.isHidden = true
       
//       if isBeautyOn {
//           cell.beautyEffectButton.setImage(beauty, for: .normal)
////                cell.beautyEffectButton.backgroundColor = UIColor(named: "theme")
//       }else {
//           cell.beautyEffectButton.setImage(unbeauty, for: .normal)
////                cell.beautyEffectButton.backgroundColor = UIColor(named: "theme")
//       }
    }

    @objc func doMuteVideoPressed(sender: UIButton) {
        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! StartCameraCollectionViewCell
        isMutedVideo.toggle()
//        cell.backView.isHidden = true
        
//        if isMutedVideo {
//            cell.videoMuteButton.setImage(unmutevideo, for: .normal)
//        }else {
//            cell.videoMuteButton.setImage(mutevideo, for: .normal)
//        }

        
    }

   @objc func doMuteAudioPressed(sender: UIButton) {
       let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! StartCameraCollectionViewCell
        isMutedAudio.toggle()
//       cell.backView.isHidden = true
       
//       if isMutedAudio {
//           cell.audioMuteButton.setImage(mutemic, for: .normal)
////                cell.audioMuteButton.backgroundColor = UIColor(named: "theme")
//       }else {
//           cell.audioMuteButton.setImage(unmutemic, for: .normal)
////                cell.audioMuteButton.backgroundColor = UIColor(named: "theme")
//       }
    }

    
    
    @objc func cancelButtonPressed(sender:UIButton){
        leaveChannel()
        
        self.backDelegate?.pushToBackButton(back: true)
//        AppUtility?.dismissPopAllViewViewControllers()
    }
    
    @objc func likeButtonPressed(sender:UIButton){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ssZ"
        let resultDate = formatter.string(from: date)

        print("currentDateTime",resultDate)

        var myUser: [User]? {didSet {}}
        myUser = User.readUserFromArchive()

        let reference = Database.database().reference()
        let LiveUser = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("LikesStream").childByAutoId()

        var parameters = [String : Any]()
        parameters = [
            "otherUserId"                   : self.receiver_id,
            "userId"                    : myUser![0].id ?? UserDefaultsManager.shared.user_id
        ]

        LiveUser.setValue(parameters) { (error, ref) in
            if error != nil{
                print(error ?? "")
                return
            }
        }
        self.generateAnimatedViews()

    }
    
    @objc func shareButtonPressed(sender:UIButton){
//
//        if let rootViewController = UIApplication.topViewController() {
//            let myViewController = InviteLiveFriendsViewController(nibName: "InviteLiveFriendsViewController", bundle: nil)
//            myViewController.modalPresentationStyle = .overFullScreen
//            rootViewController.navigationController?.isNavigationBarHidden = true
//            rootViewController.navigationController?.present(myViewController, animated: true)
//        }
       
    }
    
//    @objc func cancel(sender:UIButton){
//        let cell = liveCollectionView.cellForItem(at: IndexPath(row: sender.tag, section: 0))as! StartCameraCollectionViewCell
//        cell.backView.isHidden = true
//        self.backDelegate?.pushToBackButton(back: true)
//    }
    
}

//MARK: Comments Function
extension LiveRomCollectionViewCell {
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
                self.liveCollectionView.reloadData()
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

        let cell = liveCollectionView.cellForItem(at: IndexPath(row: tag, section: 0))as? StartCameraCollectionViewCell
        
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
//        cell?.tfComments.text =  nil

        }
    
    
    func AddCommentsToLiveChatForJoin(tag:Int){

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
                "comment"                   : "Add a comment",
                "commentTime"               : resultDate,
                "key"                       : LiveUser.key,
                "type"                      : "joined",
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
//        cell?.tfComments.text =  nil

        }
    
    
    func AddLikessToLiveChat(tag:Int){

//        if self.isAudiance == true {
            let cell = liveCollectionView.cellForItem(at: IndexPath(row: tag, section: 0))as? StartCameraCollectionViewCell
            
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm:ssZ"
                let resultDate = formatter.string(from: date)

                print("currentDateTime",resultDate)

                var myUser: [User]? {didSet {}}
                myUser = User.readUserFromArchive()

                let reference = Database.database().reference()
                let LiveUser = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("LikesStream").childByAutoId()

                var parameters = [String : Any]()
                parameters = [
                    "otherUserId"                   : self.receiver_id,
                    "userId"                    : myUser![0].id ?? UserDefaultsManager.shared.user_id
                ]

                LiveUser.setValue(parameters) { (error, ref) in
                    if error != nil{
                        print(error ?? "")
                        return
                    }
                }
//            cell?.tfComments.text =  nil
//            }else {
//            }
        }
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
        let visiblePaths = self.liveCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = liveCollectionView.cellForItem(at: i) as? StartCameraCollectionViewCell
            let userID = UserDefaultsManager.shared.user_id
            self.AddLikessToLiveChat(tag: 0)
//            if userID != ""{
//                if cell?.isLiked == false{
//                    cell?.like()
//                    self.likeVideo(uid:userID,ip: currentVidIP)
//                }else{
//                    cell?.unlike()
//                    self.likeVideo(uid:userID,ip: currentVidIP)
//                }
//            }else{
//                loginScreenAppear()
//            }
        }
    }
}
 extension LiveRomCollectionViewCell {
    func updateBroadcastersView() {
//        self.leaveChannel()
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

private extension LiveRomCollectionViewCell {
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
 extension LiveRomCollectionViewCell {
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
            
//            self.myUser = User.readUserFromArchive()
            let reference = Database.database().reference()
//            print(self.myUser?[0].id)
//            NotificationCenter.default.post(name: Notification.Name("removeLiveUserNoti"), object:nil,userInfo:nil)
            let LiveUser = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).removeValue()
            
        }
        
        setIdleTimerActive(true)
        
//        navigationController?.popViewController(animated: true)
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
         
         AddCommentsToLiveChatForJoin(tag: 0)
     }
}

// MARK: - AgoraRtcEngineDelegate
extension LiveRomCollectionViewCell: AgoraRtcEngineDelegate {
    
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


extension LiveRomCollectionViewCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StartCancelCollectionViewCell", for: indexPath)as! StartCancelCollectionViewCell
            cell.btnCancel.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: .touchUpInside)
            return cell
            
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StartCameraCollectionViewCell", for: indexPath)as! StartCameraCollectionViewCell
            cell.commentsArr = self.commentsArr
            
//            cell.commentView.isHidden = true
            
            cell.btnCancel.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: .touchUpInside)
            cell.pause_liveView.isHidden = true
            cell.btnMenu.isHidden  = true
//            cell.btnMenu.addTarget(self, action: #selector(menuButtonPressed(sender:)), for: .touchUpInside)
            cell.comentBtn.addTarget(self, action: #selector(commentButtonPressed(sender:)), for: .touchUpInside)
            
            cell.visitorStackView.isHidden = true
            
            cell.likeView.isHidden = false
            cell.btnLike.addTarget(self, action: #selector(likeButtonPressed(sender:)), for: .touchUpInside)
//
            cell.moreView.isHidden = true
            
            if isAudiance == true{
                cell.comentBtn.isHidden = false
//                cell.btnReport.isHidden = false
//                cell.cameraFucntionButton.isHidden = true
                
                cell.giftView.isHidden = false
                cell.btnGift.addTarget(self, action: #selector(giftButtonPressed(sender:)), for: .touchUpInside)
                
                
                
                print("mySwitchAccount",self.mySwitchAccount?[0].profile_pic)
                
                let obj = self.arrliveUser
                let userImg = self.userImgString
                let userImgUrl = URL(string: userImg)
               // let userObj = userData[0]
                
               // let profilePic = AppUtility?.detectURL(ipString: userObj.userProfile_pic)
               // let userImg = URL(string: profilePic!)
                
                
                cell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.userImg.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
                cell.userImg.layer.cornerRadius = cell.userImg.frame.height / 2.0
                cell.userImg.layer.masksToBounds = true
                cell.firstName.text = self.userNameString
                
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
                       // self.leaveChannel()
                    }
                    })
            }else{
                cell.comentBtn.isHidden = true
//                cell.btnReport.isHidden = true
//                cell.cameraFucntionButton.isHidden = false
//                cell.btnGift.isHidden = true
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
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(sender:)))
//            cell.userBackView.tag = indexPath.row
            tap1.view?.tag = indexPath.row
//            cell.userBackView.isUserInteractionEnabled = true
//            cell.userBackView.addGestureRecognizer(tap1)
//
            return cell
           
            
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: liveCollectionView.bounds.width , height: liveCollectionView.bounds.height)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        print("didEndDisplayingSupplementaryView")
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

//        self.ip = indexPath.row
    }
       
     @objc func giftButtonPressed(sender:UIButton){

         if let rootViewController = UIApplication.topViewController() {
             let storyMain = UIStoryboard(name: "Main", bundle: nil)
             let vc =  storyMain.instantiateViewController(withIdentifier: "CoinShareViewController") as! CoinShareViewController
             vc.modalPresentationStyle = .overFullScreen
             vc.hidesBottomBarWhenPushed = true
             
             
             vc.callback = { (text,id) -> Void in
                 print("string: ",id)
                 print("id: ",text)
                
             }
             
             
             rootViewController.navigationController?.isNavigationBarHidden = true
             rootViewController.navigationController?.present(vc, animated: false)
         }


     }
    
   
    
   
    
     @objc func commentButtonPressed(sender:UIButton){
         
         if let rootViewController = UIApplication.topViewController() {
             
             weak var pvc = rootViewController.presentingViewController

                 let myViewController = StartChatViewController(nibName: "StartChatViewController", bundle: nil)
                 myViewController.modalPresentationStyle = .overFullScreen
                 myViewController.callback = { (id,text) -> Void in
                     print("string: ",id)
                     print("id: ",text)
//                     self.callback?(id , "\(text)")
                     self.commentTxt = id
                     self.AddCommentsToLiveChat(tag: sender.tag)
                    
                 }
                 pvc?.present(myViewController, animated: false)
            
             rootViewController.navigationController?.isNavigationBarHidden = true
             rootViewController.navigationController?.present(myViewController, animated: false)
         }
         

     }
   
    @objc func menuButtonPressed(sender:UIButton){
        
        if let rootViewController = UIApplication.topViewController() {
            let myViewController = StartSettingViewController(nibName: "StartSettingViewController", bundle: nil)
            myViewController.modalPresentationStyle = .overFullScreen
            
            myViewController.mic = self.mic
            myViewController.callback1 = { string in
                print("string: ",string)
                if string == "1" {
                    self.isSwitchCamera.toggle()
                }else if string == "2" {
                }else if string == "3" {
    //                let localSession = VideoSession.localSession()
    //                localSession.updateInfo(fps: settings.frameRate.rawValue)
    //                videoSessions.append(localSession)
    //                agoraKit.setupLocalVideo(localSession.canvas)
    //
    //                self.agoraKit.setupLocalVideo(nil)
                }else if string == "4" {
                    self.isMutedAudio.toggle()
                }
            }
            
            myViewController.callback = { (text,id) -> Void in
                print("string: ",id)
                print("id: ",text)
                if text == "mic" {
                    self.mic = id
                    self.isMutedAudio.toggle()
                }else {
                    self.commentTxt = text
                    self.AddCommentsToLiveChat(tag: sender.tag)
                }
                
                
                
            }
            
            rootViewController.navigationController?.isNavigationBarHidden = true
            rootViewController.navigationController?.present(myViewController, animated: false)
        }
        

    }
}
