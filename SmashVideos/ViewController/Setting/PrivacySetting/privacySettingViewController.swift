//
//  privacySettingViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 05/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class privacySettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    
    var privacySettingData = [privacySettingMVC]()
    
    var video_download = "OFF"
    var direct_message = "EVERYONE"
    var duet_videos = "EVERYONE"
    var video_like = "EVERYONE"
    var comment_video = "EVERYONE"
    var account_private = "OFF"
    var btnTag = ""
    
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tblData: UITableView!
    
    @IBOutlet weak var videoDownloadButton: UIButton!
    @IBOutlet weak var directButton: UIButton!
    @IBOutlet weak var duetButton: UIButton!
    @IBOutlet weak var videolikeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var acccountPrivateButton: UIButton!
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    //array
    var MainArray  = [String]()
    var downloadarray  = ["ON","OFF","CANCEL"]
    var directMessagedarray = ["EVERYONE","FRIEND","NO ONE","CANCEL"]
    var duetarray = ["EVERYONE","FRIEND","NO ONE","CANCEL"]
    var videolikearray = ["EVERYONE","ONLY ME","CANCEL"]
    var commentarray = ["EVERYONE","FRIEND","NO ONE","CANCEL"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenView.isHidden = true
        popView.isHidden = true
        popView.layer.cornerRadius = 3.0
        tblHeight.constant = CGFloat(downloadarray.count * 45)
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 100
        
        getData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "privacySettingTVC", for: indexPath)as! privacySettingTableViewCell
        
        cell.stateLabel.text = MainArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var key = ""
        var value = ""
        if indexPath.row != self.MainArray.count - 1 {
            
            print(MainArray[indexPath.row])
            
            // self.offButton.setTitle(MainArray[indexPath.row], for: .normal)
            
            print(indexPath.row)
            if btnTag == "A" {
                self.videoDownloadButton.setTitle(MainArray[indexPath.row], for: .normal)
                if videoDownloadButton.titleLabel?.text == "ON"{
                    video_download = "0"
                    key = "videos_download"
                    value = "0"
                }else if videoDownloadButton.titleLabel?.text == "OFF" {
                    
                    video_download = "1"
                    key = "videos_download"
                    value = "1"
                }
                
                
            }else if btnTag == "B"{
                self.directButton.setTitle(MainArray[indexPath.row], for: .normal)
                direct_message = MainArray[indexPath.row]
                key = "direct_message"
                value = direct_message
                
            }else if btnTag == "C"{
                self.duetButton.setTitle(MainArray[indexPath.row], for: .normal)
                duet_videos = MainArray[indexPath.row]
                key = "duet"
                value = duet_videos
            }else if btnTag == "D"{
                self.videolikeButton.setTitle(MainArray[indexPath.row], for: .normal)
                video_like = MainArray[indexPath.row]
                print(video_like)
                key = "liked_videos"
                value = video_like
            }else if btnTag == "E"{
                self.commentButton.setTitle(MainArray[indexPath.row], for: .normal)
                comment_video = MainArray[indexPath.row]
                key = "video_comment"
                value = comment_video
                
            }else {
                self.acccountPrivateButton.setTitle(MainArray[indexPath.row], for: .normal)
                if acccountPrivateButton.titleLabel?.text == "ON"{
                    account_private = "0"
                    key = "private"
                    value = "0"
                }else if acccountPrivateButton.titleLabel?.text == "OFF" {
                    account_private = "1"
                    key = "private"
                    value = "1"
                }
            }
            
        }
        
        if MainArray[indexPath.row] == "CANCEL" {
            self.hiddenView.isHidden =  true
        }else {
            
            self.addPrivacy(params: [key : value])
            
            self.hiddenView.isHidden =  true
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    //MARK:-ACTION
    
    @IBAction func offButtonPressed(_ sender: UIButton) {
        self.btnTag = "A"
        
        self.MainArray = downloadarray
        self.mainLabel.text = "Select download option"
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        
        tblHeight.constant = CGFloat(downloadarray.count * 45)
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 45
        
    }
    
    @IBAction func messageButtonPressed(_ sender: UIButton) {
        self.btnTag = "B"
        self.MainArray = directMessagedarray
        self.mainLabel.text = "Select message option"
        self.tblHeight.constant = CGFloat(directMessagedarray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        
        viewHeight.constant = CGFloat(directMessagedarray.count * 45) + 45
        
    }
    
    @IBAction func duetButtonPressed(_ sender: UIButton) {
        self.btnTag = "C"
        
        self.MainArray = duetarray
        self.mainLabel.text = "Select duet option"
        self.tblHeight.constant = CGFloat(duetarray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        
        viewHeight.constant = CGFloat(duetarray.count * 45) + 45
    }
    
    @IBAction func videoLikesButtonPressed(_ sender: UIButton) {
        self.btnTag = "D"
        
        self.MainArray = videolikearray
        self.mainLabel.text = "Select like video option"
        self.tblHeight.constant = CGFloat(videolikearray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        viewHeight.constant = CGFloat(videolikearray.count * 45) + 45
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        self.btnTag = "E"
        
        self.MainArray = commentarray
        self.mainLabel.text = "Select Comment option"
        self.tblHeight.constant = CGFloat(commentarray.count * 45)
        self.tblData.reloadData()
        hiddenView.isHidden = false
        
        popView.isHidden = false
        
        
        viewHeight.constant = CGFloat(commentarray.count * 45) + 45
        
        
    }
    
    @IBAction func accountPrivateButtonPressed(_ sender: UIButton) {
        self.btnTag = "F"
        self.MainArray = downloadarray
        self.mainLabel.text = "Select your account privacy"
        self.tblData.reloadData()
        hiddenView.isHidden = false
        popView.isHidden = false
        
        tblHeight.constant = CGFloat(downloadarray.count * 45)
        viewHeight.constant = CGFloat(downloadarray.count * 45) + 45
    }
    
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- API Handler
    func addPrivacy(params : [String : String]){
        var parameters = [String : String]()
        parameters =  params
        parameters["user_id"] = UserDefaultsManager.shared.user_id
        self.loader.isHidden = false
        
        if btnTag == "F" {
            
            ApiHandler.sharedInstance.editProfile(isPhoneChange:false,isEditProfile: false, username: "", user_id: UserDefaultsManager.shared.user_id , first_name: "", last_name: "", gender: "", website: "", bio: "", dob: "", privateKey: account_private,phone:"") { isSuccess, response in
                if isSuccess {
                    self.loader.isHidden = true
                    if response?.value(forKey: "code") as! NSNumber == 200{
                        self.showToast(message: "Setting Updated", font: .systemFont(ofSize: 12))
                    }else{
                        self.loader.isHidden = true
                        self.showToast(message: "Something went wrong", font: .systemFont(ofSize: 12))
                        print(response!)
                    }
                }
            }
           
            
        }else {
            
            ApiHandler.sharedInstance.addPrivacySetting(params: parameters) { (isSuccess, response) in
                if isSuccess {
                    self.loader.isHidden = true
                    if response?.value(forKey: "code") as! NSNumber == 200{
                        self.showToast(message: "Setting Updated", font: .systemFont(ofSize: 12))
                    }else{
                        self.loader.isHidden = true
                        self.showToast(message: "Something went wrong", font: .systemFont(ofSize: 12))
                        print(response!)
                    }
                }
                
            }
            
            
        }
    }
    
    func getData(){
        self.privacySettingData.removeAll()
        self.loader.isHidden = false
        ApiHandler.sharedInstance.showOwnDetail(user_id: UserDefaultsManager.shared.user_id) { (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200{
                    
                    let msgDict = response?.value(forKey: "msg") as! NSDictionary
                    print("msgDict",msgDict)
                    let privSettingObj = msgDict.value(forKey: "PrivacySetting") as! NSDictionary
                    
                    //                    MARK:- PRIVACY SETTING DATA
                    let direct_message = privSettingObj.value(forKey: "direct_message") as! String
                    let duet = privSettingObj.value(forKey: "duet") as! String
                    let liked_videos = privSettingObj.value(forKey: "liked_videos") as! String
                    let video_comment = privSettingObj.value(forKey: "video_comment") as! String
                    let videos_download = privSettingObj.value(forKey: "videos_download") as! String
                    let privID = privSettingObj.value(forKey: "id")
                    
                    
                    
                    
                    
                    self.directButton.setTitle(direct_message.uppercased(), for: .normal)
                    self.duetButton.setTitle( duet.uppercased(), for: .normal)
                    self.videolikeButton.setTitle( liked_videos.uppercased(), for: .normal)
                    self.commentButton.setTitle( video_comment.uppercased(), for: .normal)
                    
                    if videos_download == "1"{
                        self.videoDownloadButton.setTitle("ON", for: .normal)
                    }else{
                        self.videoDownloadButton.setTitle("OFF", for: .normal)
                    }
                    
                    let User = msgDict.value(forKey: "User") as! NSDictionary
                    let privatekey = User.value(forKey: "private") as? String
                    print("privatekey",privatekey)
                    if privatekey == "1"{
                        self.acccountPrivateButton.setTitle("ON", for: .normal)
                    }else{
                        self.acccountPrivateButton.setTitle("OFF", for: .normal)
                    }
                    
                    
                    let privObj = privacySettingMVC(direct_message: direct_message, duet: duet, liked_videos: liked_videos, video_comment: video_comment, videos_download: "\(videos_download)", id: "\(privID!)")
                    self.privacySettingData.append(privObj)
                    
                    self.tblData.reloadData()
                    
                }else{
                    print("!200: ",response as Any)
                    
                }
            }
        }
    }
    
}

