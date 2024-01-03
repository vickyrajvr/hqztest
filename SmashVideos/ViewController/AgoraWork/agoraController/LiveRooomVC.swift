//
//  LiveRooomVC.swift
//  WOOW
//
//  Created by Zubair Ahmed on 27/04/2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AgoraRtcKit
import SDWebImage


class LiveRooomVC: UIViewController, LiveVCDataSource, leaveChannalPushToBackProtocol {
    func pushToBackButton(back: Bool) {
        if back == true {
//            let visiblePaths = self.LiveVideoCollectionView.indexPathsForVisibleItems
//            for i in visiblePaths  {
//                let cell = LiveVideoCollectionView.cellForItem(at: i) as? LiveRomCollectionViewCell
//                cell?.leaveChannel()
//                settings.roomName = nil
//            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit {
        return agoraKit
    }
    
    func liveVCNeedSettings() -> Settings {
        return settings
    }
    
    private lazy var agoraKit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: nil)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        return engine
    }()
    
    weak var dataSource: LiveVCDataSource?
    var LiveStreamingId = ""
    var isAudiance = true
    
    var ip = 0
    var willDispalyIndex = 0
    
    var willindexpath : IndexPath?
    var firsttimedispalt = true
    var arrliveUser = [[String:Any]]()

    private var settings = Settings()
    
    @IBOutlet weak var LiveVideoCollectionView: UICollectionView!
//    @IBOutlet weak var broadcastersView: AGEVideoContainer!
    override func viewDidLoad() {
        super.viewDidLoad()
        LiveVideoCollectionView.delegate = self
        LiveVideoCollectionView.dataSource = self
        LiveVideoCollectionView.reloadData()
//        getAllLivesUser()
        self.LiveVideoCollectionView.performBatchUpdates(nil, completion: {
            (result) in
            // ready  IndexPath(item: 1, section: 0), at: .left, animated: true)
            self.LiveVideoCollectionView.scrollToItem(at:IndexPath(item: self.ip, section: 0), at: .bottom, animated: true)
        })
        
        self.LiveVideoCollectionView.isPagingEnabled = true
        
//        self.LiveVideoCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    func getAllLivesUser(){
//            self.loader.isHidden = false
            let reference = Database.database().reference()
        let LiveUser = reference.child("LiveStreamingUsers")
            LiveUser.observe(.value) { [self] (snapshot) in
//                self.loader.isHidden = true
                self.arrliveUser.removeAll()
                for users in snapshot.children.allObjects as! [DataSnapshot] {
                    print(users.value)
                    self.arrliveUser.append(users.value as! [String:Any])

                    
                }
                if self.arrliveUser.count == 0 {
                    let visiblePaths = self.LiveVideoCollectionView.indexPathsForVisibleItems
                    for i in visiblePaths  {
                        let cell = LiveVideoCollectionView.cellForItem(at: i) as? LiveRomCollectionViewCell
                        cell?.leaveChannel()
                        navigationController?.popViewController(animated: true)
                    }
                    
                    self.LiveVideoCollectionView.isHidden =  true
//                    self.lblLive.isHidden = false
                }else{
                    self.LiveVideoCollectionView.performBatchUpdates(nil, completion: {
                        (result) in
                        // ready  IndexPath(item: 1, section: 0), at: .left, animated: true)
                        self.LiveVideoCollectionView.scrollToItem(at:IndexPath(item: self.ip, section: 0), at: .bottom, animated: false)
                    })
                    
                    self.LiveVideoCollectionView.isPagingEnabled = true
//                    self.lblLive.isHidden = true
                }

            }

        }
    
    func JoinStream(ip : Int){
        
        UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[ip]["streamingId"] as? String ?? ""
        let reference = Database.database().reference()
        let JoinStream = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("JoinStream").child(UserDefaultsManager.shared.user_id)

        let ur = self.arrliveUser[ip]["userPicture"] as? String ?? ""
        let userThumbImgPath = AppUtility?.detectURL(ipString: ur )
        
        var parameters = [String : Any]()
        parameters = [
            "userId": self.arrliveUser[ip]["userId"] as? String ?? "",
            "userName":self.arrliveUser[ip]["userName"] as? String ?? "",
            "userPic":userThumbImgPath ?? ""
        ]
        JoinStream.setValue(parameters) { [self](error, ref) in
            if error != nil{
                print(error ?? "")
                return
            }
        }
    }
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        let visiblePaths = self.LiveVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = LiveVideoCollectionView.cellForItem(at: i) as? LiveRomCollectionViewCell
            cell?.leaveChannel()
            settings.roomName = nil
        }
    }
    
    // MARK: - Collectionview
    
}


extension LiveRooomVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrliveUser.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveRom", for: indexPath) as! LiveRomCollectionViewCell

        
//        self.userImgString = self.arrliveUser[ip]["userPicture"] as? String ?? ""
//        self.userNameString  = self.arrliveUser[ip]["userName"] as? String ?? ""
      
        cell.backDelegate = self
        if indexPath.row == ip {
            
            UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[indexPath.row]["streamingId"] as? String ?? ""
            
            if self.isAudiance == true {
               
//                let JoinStream = Database.database().reference().child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("JoinStream")
//                JoinStream.observe(DataEventType.value, with: { (snapshot) in
//                        //self.commentsArr.removeAll()
//                        let Join = snapshot.children.allObjects.count
//                        print("total JoinStream: ", Join)
//                        print("\(Join)")
//                    if Join == 0 {
////                        cell.leaveChannel()
//                    }
//                    })
            }
            
            cell.arrliveUser = self.arrliveUser
//            cell.liveCollectionView.reloadData()
//            StaticData.singleton.liveUserID = self.arrliveUser[ip]["userId"] as? String ?? ""
//            StaticData.singleton.liveUserName = self.arrliveUser[ip]["userName"] as? String ?? ""
            
//            UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[ip]["streamingId"] as? String ?? ""
//            settings.roomName = self.arrliveUser[ip]["streamingId"] as? String
//            cell.dataSource = self
//            cell.loadAgoraKit()
            
            if self.isAudiance == true {
                
//                self.JoinStream(ip: self.ip)
//                cell.updateButtonsVisiablity()
//                settings.roomName = self.arrliveUser[ip]["streamingId"] as? String
//                cell.dataSource = self
//                cell.loadAgoraKit()
//
//                cell.updateBroadcastersView()
            }
//            UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[ip]["streamingId"] as? String ?? ""
            
//            cell.settings.role = .audience
            
            
        }else {
//            cell.leaveChannel()
        }
        
        
        
//        if indexPath.row == 0 {
//            cell.broadcastersView.backgroundColor = .red
//        }else if indexPath.row == 1 {
//            cell.broadcastersView.backgroundColor = .gray
//        }else {
//            cell.broadcastersView.backgroundColor = .black
//        }
//        cell.settings.role = .audience
//        UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[ip]["streamingId"] as? String ?? ""
//        cell.settings.roomName = self.arrliveUser[ip]["streamingId"] as? String
//
       
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? LiveRomCollectionViewCell {
            
//            self.ip = indexPath.row
            
//            cell.leaveChannel()
            
//            if let cell = cell as? LiveRomCollectionViewCell {
//                if self.isAudiance == true {
//                    if self.arrliveUser.count < 1 {
//                        cell.leaveChannel()
//                        self.navigationController?.popViewController(animated: true)
//                        return
//                    }
//                    UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[indexPath.row]["streamingId"] as? String ?? ""
//                    settings.roomName = self.arrliveUser[indexPath.row]["streamingId"] as? String
//
//                    self.JoinStream(ip: indexPath.row)
//                }
//                settings.role = .audience
//
//                cell.updateButtonsVisiablity()
//                cell.updateBroadcastersView()
//
//                cell.dataSource = self
//                cell.loadAgoraKit()
//    //
//
//
//            }
            
        }

    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let itemWidth = LiveVideoCollectionView.frame.width // Get the itemWidth. In my case every cell was the same width as the collectionView itself
//            let contentOffset = targetContentOffset.pointee.x
//
//            let targetItem = lround(Double(contentOffset/itemWidth))
//            let targetIndex = targetItem % YOUR_ARRAY.count // numberOfItems which shows in the collection view
//            print(targetIndex)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        let visiblePaths = self.LiveVideoCollectionView.indexPathsForVisibleItems
//        for i in visiblePaths  {
            let cell = self.LiveVideoCollectionView.cellForItem(at: self.willindexpath!) as? LiveRomCollectionViewCell
            cell?.leaveChannel()
        cell?.broadcastersView.removeAllLayouts()
            self.settings.roomName = nil
//        }
        
        
        let pageWidth = scrollView.frame.size.width
                let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
                print("page = \(page)")

        var visibleRect = CGRect()

            visibleRect.origin = LiveVideoCollectionView.contentOffset
            visibleRect.size = LiveVideoCollectionView.bounds.size

            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

            guard let indexPath = LiveVideoCollectionView.indexPathForItem(at: visiblePoint) else { return }

            print(indexPath)
        print(willDispalyIndex)
        print(indexPath.row)
        
        self.willindexpath = indexPath
        
        print(self.settings.roomName)
       
//                    if self.settings.roomName == nil {
        
        
        let visiblePaths = self.LiveVideoCollectionView.indexPathsForVisibleItems
//        for i in visiblePaths  {
            
            let cell1 = LiveVideoCollectionView.cellForItem(at: indexPath) as? LiveRomCollectionViewCell
            
          //  cell?.leaveChannel()
//            settings.roomName = nil
            
                UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[indexPath.row]["streamingId"] as? String ?? ""
                self.settings.roomName = self.arrliveUser[indexPath.row]["streamingId"] as? String
                self.settings.role = .audience
            cell1?.dataSource = self
            cell1?.showDataBooking(selectedIndex: indexPath.row, arrliveUser: self.arrliveUser)
            cell1?.broadcastersView.removeAllLayouts()
//        }

        
        
        
//        self.ip = indexPath.row
//        LiveVideoCollectionView.reloadData()
//
//        for cell in LiveVideoCollectionView.visibleCells {
//                let indexPath = LiveVideoCollectionView.indexPath(for: cell)
//                print(indexPath)
//            print(self.arrliveUser[indexPath?.row ?? 0])
//            }
//
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        return CGSize(width: LiveVideoCollectionView.bounds.width , height: LiveVideoCollectionView.bounds.height)

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
        willDispalyIndex = indexPath.row
        
        DispatchQueue.main.async {
            
            if self.firsttimedispalt == true {
                
                if let cell = cell as? LiveRomCollectionViewCell {
                    if self.isAudiance == true {
        //                if UserDefaultsManager.shared.LiveStreamingId == self.arrliveUser[indexPath.row]["streamingId"] as? String {
                        print(self.settings.roomName)
                       
    //                    if self.settings.roomName == nil {
                        UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[self.ip]["streamingId"] as? String ?? ""
                        self.settings.roomName = self.arrliveUser[self.ip]["streamingId"] as? String
                            self.settings.role = .audience
                            cell.dataSource = self
                        
                        cell.showDataBooking(selectedIndex: self.ip, arrliveUser: self.arrliveUser)
                            cell.broadcastersView.removeAllLayouts()
                        
                        self.firsttimedispalt = false
                        self.willindexpath = indexPath
                        
    //                        print(self.settings.roomName)
    //                        self.JoinStream(ip: indexPath.row)
    //                        self.settings.role = .audience
    //
    //                        cell.updateButtonsVisiablity()
    //                        cell.updateBroadcastersView()
    //
                           
    //                        cell.loadAgoraKit()
    //                    }else{
    //                      //  self.settings.roomName = nil
    //                      //  cell.leaveChannel()
    //
    //                        UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[indexPath.row]["streamingId"] as? String ?? ""
    //                        self.settings.roomName = self.arrliveUser[indexPath.row]["streamingId"] as? String
    //                        self.settings.role = .audience
    //                        cell.dataSource = self
    //
    //
    //                        print(self.settings.roomName)
    ////                        self.JoinStream(ip: indexPath.row)
    //                        cell.showDataBooking(selectedIndex: indexPath.row, arrliveUser: self.arrliveUser)
    //                        cell.broadcastersView.removeAllLayouts()
    //                    }
        //                    UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[indexPath.row]["streamingId"] as? String ?? ""
        //                    settings.roomName = self.arrliveUser[indexPath.row]["streamingId"] as? String
        //
        //                print(settings.roomName)
        //                    self.JoinStream(ip: indexPath.row)
        //                    settings.role = .audience
        //
        //                    cell.updateButtonsVisiablity()
        //                    cell.updateBroadcastersView()
        //
        //                    cell.dataSource = self
        //                    cell.loadAgoraKit()
        //                }
        //                if let result = agoraEngine.leaveChannelEx(rtcSecondConnection, leaveChannelBlock: nil)
        //                    4        print("leaveChannelEx result: \(result)")
        //                    5        if result == 0 {
        //                    6            showMessage(title: "Success", text: "Successfully left the second channel")
        //                    7            isSecondChannelJoined = false
        //                    8            print("Leave Channel Success - left channel: \(secondChannelName)")
        //                    9            secondChannelBtn.setTitle("Join Second Channel", for: .normal)
        //                    10        }
        //                print(self.arrliveUser[indexPath.row]["streamingId"] as? String ?? "")
        //                UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[indexPath.row]["streamingId"] as? String ?? ""
        //                settings.roomName = self.arrliveUser[indexPath.row]["streamingId"] as? String
        //
        //                self.JoinStream(ip: indexPath.row)
                    }
                    
        //


                }
            }else{
                if let cell = cell as? LiveRomCollectionViewCell {
                   // cell.leaveChannel()
//
//
//                        UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[indexPath.row]["streamingId"] as? String ?? ""
//                        self.settings.roomName = self.arrliveUser[indexPath.row]["streamingId"] as? String
//                        self.settings.role = .audience
//                    cell.dataSource = self
//                    cell.showDataBooking(selectedIndex: indexPath.row, arrliveUser: self.arrliveUser)
//                    cell.broadcastersView.removeAllLayouts()
                    
                    
                    
                    
                    
                    
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
//                        let visiblePaths = self.LiveVideoCollectionView.indexPathsForVisibleItems
//                        for i in visiblePaths  {
//                            let cell = self.LiveVideoCollectionView.cellForItem(at: self.willindexpath!) as? LiveRomCollectionViewCell
//                            cell?.leaveChannel()
//                            self.settings.roomName = nil
//                        }
//                    }
                  
//
                    
                    
                    
//                    self.agoraKit.setupLocalVideo(nil)
//                    self.agoraKit.leaveChannel(nil)
//                    if self.settings.role == .broadcaster {
//                        self.agoraKit.stopPreview()
//
//            //            self.myUser = User.readUserFromArchive()
//                        let reference = Database.database().reference()
//            //            print(self.myUser?[0].id)
//            //            NotificationCenter.default.post(name: Notification.Name("removeLiveUserNoti"), object:nil,userInfo:nil)
//                        let LiveUser = reference.child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).removeValue()
//
//                    }
//
//                    self.setIdleTimerActive(true)
                    
                }
            }
        }
    }
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
}
