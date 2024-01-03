//
//  InboxViewController.swift
//  WOOW
//
//  Created by Mac on 29/06/2022.
//

import UIKit
import SDWebImage
class NotificationViewController: UIViewController {
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    private var isLoading = true {
        didSet {
            notificationTableView.isUserInteractionEnabled = !isLoading
            notificationTableView.reloadData()
        }
    }
    //MARK:- OUTLET
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var notificationsArr = [notificationsMVC]()
    var notiVidDataArr = [videoMainMVC]()
    
    var startPoint = 0
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
       
        notificationTableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        getNotifications(startPoint: "\(self.startPoint)")
        
       
    }
    

    
    
    func getNotifications(startPoint:String){
        self.isLoading = true
        print("userid: ",UserDefaultsManager.shared.user_id)
        //self.loader.isHidden = false
        ApiHandler.sharedInstance.showAllNotifications(user_id: UserDefaultsManager.shared.user_id, starting_point: "\(startPoint)") { (isSuccess, response) in
            if isSuccess{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.isLoading = false
                }
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    for dic in resMsg{
                        let notiDic = dic["Notification"] as! NSDictionary
                        
//                        let vidDic = dic["Video"] as! NSDictionary
                        let senderDic = dic["Sender"] as! NSDictionary
                        let receiverDic = dic["Receiver"] as! NSDictionary
                        
                        
                        
                        let notiString = notiDic.value(forKey: "string") as! String
                        let type = notiDic.value(forKey: "type") as! String
                        let receiver_id = notiDic.value(forKey: "receiver_id") as! String
                        let sender_id = notiDic.value(forKey: "sender_id") as! String
                        let video_id = notiDic.value(forKey: "video_id") as! String
                        let notiID  = notiDic.value(forKey: "id") as! String
                        
                        let senderUserame  = senderDic.value(forKey: "username") as? String
                        let senderImg = senderDic.value(forKey: "profile_pic") as? String
                        let senderFirstName = senderDic.value(forKey: "first_name") as? String
                        
                        let receiverName = receiverDic.value(forKey: "username") as! String
                        
                        let notiObj = notificationsMVC(notificationString: notiString, id: notiID, sender_id: sender_id, receiver_id: receiver_id, type: type, video_id: video_id, senderName: senderUserame ?? "This user doesn't exist", senderFirstName: senderFirstName ?? "", receiverName: receiverName, senderImg: senderImg ?? "")
                        
                        self.notificationsArr.append(notiObj)

                    }
                    self.noDataView.isHidden = true
                    self.notificationTableView.reloadData()
                    
                }else{
                    self.noDataView.isHidden = false
                    
                    print("!200",response?.value(forKey: "msg"))
                }
            }else{
                self.noDataView.isHidden = false
            }
          //  self.loader.isHidden = true
          
           
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.backgroundColor = UIColor(named: "black")
        setNeedsStatusBarAppearanceUpdate()


        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
        
    }
   
    //MARK:- BUTTON ACTION
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        let myViewController = InboxViewController(nibName: "InboxViewController", bundle: nil)
        
        myViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myViewController, animated: true)
        
        
    }
    
    
}

//MARK:- EXTENSION TABLE VIEW

extension NotificationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath)as! NotificationsTableViewCell
        
       
            let obj = self.notificationsArr[indexPath.row]
            
           
            
            cell.lblName.text = obj.senderName
            cell.lblDescr.text = obj.notificationString
    //        if(obj.type == "video_like"){
    //            cell.foolow_btn_view.alpha = 1
    //        }else if(obj.type == "video_comment"){
    //            cell.foolow_btn_view.alpha = 1
    //        }else{
    //            cell.foolow_btn_view.alpha = 0
    //        }
            
            
            let senderImg = AppUtility?.detectURL(ipString: obj.senderImg)
        print("senderImg",senderImg)
            cell.imgProfile.sd_setImage(with: URL(string:senderImg!), placeholderImage: UIImage(named:"noUserImg"))
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width / 2
            cell.imgProfile.clipsToBounds = true
           
        
      
        
//        cell.follow_view.layer.cornerRadius = cell.follow_view.frame.size.width / 2
//        cell.follow_view.clipsToBounds = true
//
//        cell.foolow_btn_view.layer.cornerRadius = 5
//        cell.foolow_btn_view.clipsToBounds = true
//
//        cell.btn_follow.tag = indexPath.item
//
//        cell.btnWatch.addTarget(self, action: #selector(newNotificationsViewController.btnWatchAction(_:)), for:.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: UIColor(named: "lightGrey"))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let obj = notificationsArr[indexPath.row]
//
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVideoViewController")as! ProfileVideoViewController
//        vc.hidesBottomBarWhenPushed = true
//        vc.otherUserID = obj.sender_id
////        vc.user_name = obj.senderName
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
