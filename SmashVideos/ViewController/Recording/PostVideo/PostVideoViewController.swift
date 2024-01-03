//
//  postViewController.swift
//  InfoTex
//
//  Created by Mac on 28/08/2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import Photos
import StoreKit

class PostVideoViewController: UIViewController,UITextViewDelegate {
    
    
    //MARK:- Outlets
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var vidThumbnail: UIImageView!
    @IBOutlet weak var describeTextView: AttrTextView!
    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var privacyIconImg: UIImageView!
    
    @IBOutlet weak var draftBtn: UIButton!
    @IBOutlet weak var btnFriends: CustomButton!
    @IBOutlet weak var btnHashtah: CustomButton!
    //MARK:- Variables
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator(self.view))!
    }()
    
    var privacyType = "Public"
    var myUser:[User]? {didSet{}}
    var videoUrl:URL?
    var desc = ""
    var allowDuet = "0"
    var allowComments = "false"
    var saveV = "0"
    var duet = "0"
    var soundId = "null"
    
    
    var boxView = UIView()
    var blurView = UIView()
    
    var hashTagsArr = [String]()
    var userTagsArr = [String]()
    
    //Edit Post
    //weak var delegate: videoLikeDelegate?
    var isEditPost = false
    var videoMain:videoMainMVC!
    var currentIndex = 0
    var isDraft =  false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK:- viewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("videoURL",videoUrl)
        self.myUser = User.readUserFromArchive()
        
        self.describeTextView.layer.cornerRadius =  2
        self.describeTextView.layer.borderWidth =  1
        self.describeTextView.layer.borderColor =  UIColor.systemGray5.cgColor
        self.describeTextView.text = "Describe your post"
        self.describeTextView.textColor = UIColor.lightGray
        self.describeTextView.delegate =  self
        self.getThumbnailImageFromVideoUrl(url: videoUrl!) { (thumb) in
            self.vidThumbnail.image = thumb
        }
        if isEditPost == true{
            self.describeTextView.text = self.videoMain.description
        }
        
        let privayOpt = UITapGestureRecognizer(target: self, action:  #selector(self.privacyOptionsList))
        self.privacyView.addGestureRecognizer(privayOpt)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("selected row : ",UserDefaults.standard.integer(forKey: "selectRow"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("privTypeNC"), object: nil)
        
    }
    //MARK:- TextView
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.text = .none
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your post"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        describeTextView.setText(text: describeTextView.text,textColor: .black, withHashtagColor: UIColor(named: "theme")!, andMentionColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), andCallBack: { (strng, type) in
            print("type: ",type)
            print("strng: ",strng)
            
            
        }, normalFont: .systemFont(ofSize: 14, weight: UIFont.Weight.light), hashTagFont: .systemFont(ofSize: 14, weight: UIFont.Weight.bold), mentionFont: .systemFont(ofSize: 14, weight: UIFont.Weight.bold))
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= 150
    }
    
    //MARK:- API Handler
    
    func uploadData(){
        self.loader.isHidden = false
        let hashtags = describeTextView.text.hashtags()
        let mentions = describeTextView.text.mentions()

        let newHashtags : NSMutableArray = []
        var newMentions : NSMutableArray = []
       
        
        for hash in hashtags{
            print(hash)
            var dict = [String : String]()
            dict = ["name" : hash]
            print("hashobject",dict)
            newHashtags.add(dict)
        }
        
        print("hash",hash)
        for mention in mentions{
            var dict = [String : Any]()
            dict = ["user_id" : ""]
            print("hashobject",dict)
            newMentions.add(dict)
        }
        let uid = UserDefaultsManager.shared.user_id
        if(uid == nil || uid == ""){
           
        }
        
        var hashtags_json = ""
        do {
            let data = try JSONSerialization.data(withJSONObject: newHashtags)
            let dataString = String(data: data, encoding: .utf8)!
            print(dataString)
            hashtags_json = dataString
        } catch {
            print("JSON serialization failed: ", error)
        }
        
        var users_json = ""
        do {
            let data = try JSONSerialization.data(withJSONObject: newMentions)
            let dataString = String(data: data, encoding: .utf8)!
            print(dataString)
            users_json = dataString
        } catch {
            print("JSON serialization failed: ", error)
        }
        
        
        
        let url : String = ApiHandler.sharedInstance.baseApiPath+"postVideo"
        let cmnt = self.allowComments
        let allwDuet = self.allowDuet
        let prv = self.privacyType
        var des = self.desc
        if describeTextView.text != "Describe your post" {
            des = describeTextView.text
        }else{
            des = ""
        }
        
        print("cmnt",cmnt)
        print("allwDuet",allwDuet)
        print("prv",prv)
        print("des",des)
        print("hashtags",hashtags)
        print("mentions",mentions)
        
        
        let parameter :[String:Any] = ["user_id"       : UserDefaultsManager.shared.user_id,
                                        "sound_id"      : UserDefaultsManager.shared.sound_id,
                                        "description"   : des,
                                        "privacy_type"  : prv,
                                        "allow_comments": cmnt,
                                        "allow_duet"    : allwDuet,
                                        "users_json"    : users_json,
                                        "hashtags_json" : hashtags_json,
                                       "video_id" : "0",
                                      "videoType" : "0",
                                       "story":"0"
        ]
        
        let uidString = UserDefaultsManager.shared.user_id
        let soundIDString = "null"
        
        print(url)
        print(parameter)
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            
            
            if (!JSONSerialization.isValidJSONObject(parameter)) {
                print("is not a valid json object")
                return
            }
            for key in parameter.keys{
                let name = String(key)
                if let val = parameter[name] as? String{
                    MultipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
 
            MultipartFormData.append(self.videoUrl!, withName: "video")
    
            
        }, to: url, method: .post, headers: headers)
        
        .uploadProgress(closure: { (progress) in
            
            print("Upload Progress: \(progress.fractionCompleted)")
           
            let per  =  progress.fractionCompleted
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploadVideo"), object: per)
            let myViewController = UploadViewController(nibName: "UploadViewController", bundle: nil)
            myViewController.modalPresentationStyle = .overFullScreen
            self.present(myViewController, animated: true, completion: nil)
        })
       
            .responseJSON { (response) in
           
                switch response.result{
                    
                case .success(let value):
                       
                        
                        
                    
                    print("progress: ",Progress.current())
                    let json = value
                    let dic = json as! NSDictionary
                    
                    print("response:- ",response)
                    if(dic["code"] as! NSNumber == 200){
                        print("200")
                        debugPrint("SUCCESS RESPONSE: \(response)")
                        
                        if self.saveV == "1"{
                            self.saveVideoToAlbum(self.videoUrl!) { (err) in
                                
                                if err != nil{
                          
                                    print("Unable to save video to album dur to: ",err!)
                                    self.showToast(message: "Unable to save video to album dur to:", font: .systemFont(ofSize: 12))
                                }else{
                                    print("video saved to gallery")
                                    self.showToast(message: "video saved to gallery", font: .systemFont(ofSize: 12))
                                }
                                
                            }
                        }
                        self.loader.isHidden = true
                        print("Dict: ",dic)
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        
                        
                    }else{
                        self.loader.isHidden = true
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        print(dic)
                        
                    }
                case .failure(let error):
                    self.loader.isHidden = true
                    self.showToast(message: error.localizedDescription, font: .systemFont(ofSize: 12))
                    print("\n\n===========Error===========1")
                    print("Error Code1: \(error._code)")
                    print("Error Messsage1: \(error.localizedDescription)")
                    if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Server Error1: " + str)
                    }
                    debugPrint(error as Any)
                    print("===========================\n\n1")
                }
                
        }
        /*.response(responseSerializer: serializer) { response in
            // Process response.
            switch response.result{
            case .success(let value):
                let json = value
                let dic = json as? NSDictionary
                let code = dic?["code"] as? NSString
                
                print("value: ",value)
                print("response",response)
                if(code == "200"){
                    print("200")
                    debugPrint("SUCCESS RESPONSE: \(response)")
                }else{
                    print("dic: ",dic)
                    
                }
                
                if self.saveV == "1"{
                    self.saveVideoToAlbum(self.videoUrl!) { (err) in
                        
                        if err != nil{
                            //                                    AppUtility?.stopLoader(view: self.view)
                            print("Unable to save video to album dur to: ",err!)
                            self.showToast(message: "Unable to save video to album dur to:", font: .systemFont(ofSize: 12))
                            AppUtility?.stopLoader(view: self.view)
                        }else{
                            //                                    HomeViewController.removeSpinner(spinner: sv)
                            
                            print("video saved to gallery")
                            self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                            AppUtility?.stopLoader(view: self.view)
//                            self.showToast(message: "video saved to gallery", font: .systemFont(ofSize: 12))
                        }
                        
                    }
                }
                
                
            case .failure(let error):
                AppUtility?.stopLoader(view: self.view)
                print("\n\n===========Error===========")
                print("Error Code2: \(error._code)")
                print("Error Messsage2: \(error.localizedDescription)")
                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Server Error2: " + str)
                }
                debugPrint(error as Any)
                print("===========================\n\n2")
                
            }
        }*/
    }

    func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: outputURL, options: nil)
            }) { (result, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Saved VIDEO TO photos successfully")
                    }
                    completion?(error)
                }
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
    
    func editPost(){
        
        let hashtags = describeTextView.text.hashtags()
        let mentions = describeTextView.text.mentions()

        var newHashtags = [[String:String]]()
        var newMentions = [[String:String]]()
        
        for hash in hashtags{
            newHashtags.append(["name":hash])
        }
        for mention in mentions{
            newMentions.append(["name":mention])
        }
       
        if(UserDefaults.standard.string(forKey: "sid") == nil || UserDefaults.standard.string(forKey: "sid") == ""){
            
            UserDefaults.standard.set("null", forKey: "sid")
        }
        let url : String = ApiHandler.sharedInstance.baseApiPath+"editVideo"
        let cmnt = self.allowComments
        let allwDuet = self.allowDuet
        let prv = self.privacyType
        var des = self.desc
        if describeTextView.text != "Describe your video" {
            des = describeTextView.text
        }else{
            des = ""
        }
        
        print("cmnt",cmnt)
        print("allwDuet",allwDuet)
        print("prv",prv)
        print("des",des)
        print("hashtags",hashtags)
        print("mentions",mentions)
        
        
        let parameter :[String:Any] = ["user_id"       : UserDefaultsManager.shared.user_id,
                                        "sound_id"      : "null",
                                        "description"   : des,
                                        "privacy_type"  : prv,
                                        "allow_comments": cmnt,
                                        "allow_duet"    : allwDuet,
                                        "users_json"    : newMentions,
                                        "hashtags_json" : newHashtags
        ]
        
        print(url)
        print(parameter)
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        AF.upload(multipartFormData: { MultipartFormData in
            
            
            if (!JSONSerialization.isValidJSONObject(parameter)) {
                print("is not a valid json object")
                return
            }
            for key in parameter.keys{
                let name = String(key)
                if let val = parameter[name] as? String{
                    MultipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
 
            MultipartFormData.append(self.videoUrl!, withName: "video")
            
        
            
        },  to: url, method: .post, headers: headers)
        .responseJSON { (response) in
            self.loader.isHidden = true
            switch response.result{

            case .success(let value):
                print("progress: ",Progress.current())
                let json = value
                let dic = json as! NSDictionary

                print("response:- ",response)
                if(dic["code"] as! NSNumber == 200){
                    print("200")
                    self.loader.isHidden =  true
                    var obj = self.videoMain
                    var strDscr  =   obj!.description
                    strDscr =  des
                    obj!.allow_comments = cmnt
                    obj!.allow_duet = allwDuet
                    //self.delegate!.updateObj(obj: obj!, index: self.currentIndex, islike: false)
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)


                }else{
                    
                  //  AppUtility?.stopLoader(view: self.view)
                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    print(dic)

                }
            case .failure(let error):
                self.loader.isHidden =  true
                //     AppUtility?.stopLoader(view: self.view)
                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Server Error: " + str)
                }
                debugPrint(error as Any)
                print("===========================\n\n")

            }
        }
    }

    //    MARK:- CHANEGE PRIVACY INFO
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let type = notification.userInfo?["privType"] as? String {
            print("type: ",type)
            self.publicLabel.text = type
            self.privacyType = type
            
            switch type {
            case "Public":
                self.privacyIconImg.image = #imageLiteral(resourceName: "openLockIcon")
                UserDefaults.standard.set(0, forKey: "selectRow")
            case "Friends":
                self.privacyIconImg.image = #imageLiteral(resourceName: "30")
            case "Private":
                self.privacyIconImg.image = #imageLiteral(resourceName: "music tok icon-1")
                UserDefaults.standard.set(1, forKey: "selectRow")
            default:
                self.privacyIconImg.image = #imageLiteral(resourceName: "openLockIcon")
                self.publicLabel.text = "Public"
                self.privacyType = "Public"
                UserDefaults.standard.set(0, forKey: "selectRow")
                //                UserDefaults.standard.set(0, forKey: "selection")
            }
        }
    }
    
    
    
    
    //MARK:- Button Actions
    
    
    
    //    MARK:- UIVIEWS ACTIONS
    @objc func privacyOptionsList(sender : UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyViewController") as! privacyViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func saveSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.saveV = "1"
        }else{
            self.saveV = "0"
        }
        
    }
    
    
    @IBAction func btnPost(_ sender: Any) {
        if self.isEditPost == false{
            
            self.uploadData()
//            let story:UIStoryboard = UIStoryboard(name: "influncer", bundle: nil)
//            let vc  =  storyboard?.instantiateViewController(withIdentifier: "UploadingVideoViewController") as! UploadingVideoViewController
//            self.present(vc, animated: true, completion: nil)
        }else{
            // self.editPost()
        }
       
    }
    @IBAction func commentSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.allowComments = "true"
        }else{
            self.allowComments = "false"
        }
    }
    
    @IBAction func duetSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.allowDuet = "1"
        }else{
            self.allowDuet = "0"
        }
    }
    
    @IBAction func btnHashtag(_ sender: UISwitch) {
        
        guard self.describeTextView.text != "Describe your post" else {return}
        if describeTextView.text.count == 150 {
            return
        }
        
        self.describeTextView.setText(text: describeTextView.text+" #",textColor: .black, withHashtagColor: UIColor(named: "theme")!, andMentionColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), andCallBack: { (strng, type) in
            print("type: ",type)
            print("strng: ",strng)
        }, normalFont: .systemFont(ofSize: 14, weight: UIFont.Weight.light), hashTagFont: .systemFont(ofSize: 14, weight: UIFont.Weight.bold), mentionFont: .systemFont(ofSize: 14, weight: UIFont.Weight.bold))
        
    }
    
    @IBAction func btnMention(_ sender: UISwitch) {
        
        guard self.describeTextView.text != "Describe your post" else {return}
        if describeTextView.text.count == 150 {
            return
        }
        self.describeTextView.setText(text: describeTextView.text+" @",textColor: .black, withHashtagColor: UIColor(named: "theme")!, andMentionColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), andCallBack: { (strng, type) in
            print("type: ",type)
            print("strng: ",strng)
        }, normalFont: .systemFont(ofSize: 14, weight: UIFont.Weight.light), hashTagFont: .systemFont(ofSize: 14, weight: UIFont.Weight.bold), mentionFont: .systemFont(ofSize: 14, weight: UIFont.Weight.bold))
        
    }
    
    
    
    
    @IBAction func btnSaveToDraft(_ sender: Any) {

//        if isDraft == true{
//            self.navigationController?.popViewController(animated: true)
//            return
//        }
//        var obj = [String:Any]()
//        obj = [
//            "mediaURL" : self.videoUrl?.absoluteString,
//            "soundID"  : self.soundId,
//            "videoID"  : 0,
//            "image"    : []
//
//        ]

//        DraftDataDetail.shared.Objresponse(response: obj)
//        AppUtility?.showToast(string: "Your video save as draft", view: self.view)
//        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

    }

    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:- Functions
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    
    func showShimmer(progress: String){
        
        //        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 70, width: 180, height: 50))
        boxView.backgroundColor = UIColor.white
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.gray
        textLabel.text = progress
        
        blurView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        let blurView = UIView(frame: UIScreen.main.bounds)
        
        
        boxView.addSubview(blurView)
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
    func HideShimmer(){
        boxView.removeFromSuperview()
    }
    func dictToJSON(dict:[String: AnyObject]) -> AnyObject {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return jsonData as AnyObject
    }
    
    //Core data video saved in Draft
    func saveVideoURL(_ urlString: String) {
        let video = DraftVideos(context: context)
        video.videoURL = urlString
        
        do {
            try context.save()
        } catch {
            print("Error saving video URL: \(error.localizedDescription)")
        }
    }
    
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }
        
        return String(data: theJSONData, encoding: .ascii)
    }
}



