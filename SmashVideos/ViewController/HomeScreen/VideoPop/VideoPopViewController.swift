//
//  VideoPopViewController.swift
//  SmashVideos
//
//  Created by Mac on 22/10/2022.
//

import UIKit
import Photos
import SDWebImage
protocol NotInterstedDelegate {
    func notInterstedFunc(status : Bool)
}
class VideoPopViewController: UIViewController{
    
    //MARK: - VARS
    
    var isProfile = false

    //MARK:- OUTLET

    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
   
    @IBOutlet weak var tableView: UITableView!
    
    var arr = [["title":"Save video","img":"save"],
               ["title":"Report","img":"report-1"],
               ["title":"Not Interested","img":"inte"]]
 
    var NotInterstedDelegate : NotInterstedDelegate?
    var videoID = "0"
    var receiverID = "0"
    var currentVideoUrl = ""
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
 
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "VideoPopTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoPopTableViewCell")
        
        if isProfile == true {
            arr = [["title":"Save video","img":"save"],
                       ["title":"Report","img":"report-1"]]
        }else {
            arr = [["title":"Save video","img":"save"],
                       ["title":"Report","img":"report-1"],
                       ["title":"Not Interested","img":"inte"]]
        }
        
        tableViewHeight.constant = CGFloat(arr.count * 50)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            let touch = touches.first
            if touch?.view != self.view
            { self.dismiss(animated: false, completion: nil) }
        }
    
  
   
   
    //MARK:- API Handler
    
    func notInterestedVide(videoid:String,UserID:String){
        self.loader.isHidden =  false
        ApiHandler.sharedInstance.NotInterestedVideo(video_id: videoid, user_id: UserID) { (isSuccess, response) in
            self.loader.isHidden =  true
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    print("Video Not Interested")
                    self.NotInterstedDelegate?.notInterstedFunc(status: true)
                }else{
                   
                    print("Video Not Interested != 200 ")
                }
                self.dismiss(animated: false, completion: nil)
            }else{
                self.showToast(message: "Something went wrong,Please try again later", font: .systemFont(ofSize: 12.0))
                
            }
        }
    }
    
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
    func getVideoDownloadURL(){
        ApiHandler.sharedInstance.downloadVideo(video_id: videoID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let currentUrl =  response?.value(forKey: "msg") as! String
                    self.currentVideoUrl = (AppUtility?.detectURL(ipString: currentUrl))!
                    self.downloadVideo()
                    self.loader.isHidden = true
                    print(response?.value(forKey: "msg"))
                    
                }else{
                    self.loader.isHidden = true
                    print("!2200: ",response as Any)
                }
            }
        }
    }
    
    func downloadVideo() {
        print("current url: ",currentVideoUrl)
        self.saveVideoToAlbum((AppUtility?.detectURL(ipString: currentVideoUrl))!) { (error) in
            //Do what you want
            print("err: ",error)
            if error == nil{
                
            }
            
        }
    }
    
    func downloadAPI(){
        ApiHandler.sharedInstance.deleteWaterMarkVideo(video_url: currentVideoUrl) { (isSuccess, response) in
            if isSuccess{
                print("respone: ",response?.value(forKey: "msg"))
                
            }else{
                print("!200: ",response as Any)
            }
        }
    }
    
    func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
    }
    
    func saveVideoToAlbum(_ vidUrlString: String, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: vidUrlString),
                   let urlData = NSData(contentsOf: url) {
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                    let filePath="\(documentsPath)/tempFile.mp4"
                    DispatchQueue.main.async {
                        urlData.write(toFile: filePath, atomically: true)
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                        }) { completed, error in
                            if completed {
                                
                                self.downloadAPI()
                                DispatchQueue.main.async { // Correct
                                    self.loader.isHidden = true
                                    self.dismiss(animated: false)
                                }
                                
                                print("Video is saved!")
                            }else{
                                
                                // self.showToast(message: error as! String, font: .systemFont(ofSize: 12))
                                self.loader.isHidden = true
                                self.dismiss(animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    

}


//MARK:- EXTENSION TABLE VIEW

extension VideoPopViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoPopTableViewCell", for: indexPath)as! VideoPopTableViewCell
        cell.lbl.text = arr[indexPath.row]["title"]as! String
        cell.img.image = UIImage(named: arr[indexPath.row]["img"]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            print("saveVideo Tap")
            let userID = UserDefaultsManager.shared.user_id
            
            if userID == nil || userID == ""{
                loginScreenAppear()
                
            }else{
                self.loader.isHidden = false
                getVideoDownloadURL()
            }
          
        }else if indexPath.row == 1 {
            
            let myViewController = ReportDetailViewController(nibName: "ReportDetailViewController", bundle: nil)
            myViewController.otherUserID = self.receiverID
            myViewController.videoID = self.videoID
            myViewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(myViewController, animated: true)
            
            
            
        }else {
            let userID = UserDefaultsManager.shared.user_id
            if userID == nil || userID == ""{
                loginScreenAppear()
                
            }else{
                self.notInterestedVide(videoid: self.videoID, UserID: UserDefaultsManager.shared.user_id)
            }
        }
    }
    
}
