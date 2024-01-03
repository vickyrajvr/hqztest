//
//  cameraCollectionViewCell.swift
//  WOOW
//
//  Created by Mac on 27/07/2022.
//

import UIKit
import SDWebImage
class cameraCollectionViewCell: UICollectionViewCell {
    
    var commentsArr = [[String:Any]]()
    
    @IBOutlet weak var videoMuteButton: UIButton!
    @IBOutlet weak var audioMuteButton: UIButton!
    @IBOutlet weak var beautyEffectButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var effectBtnAction: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var cameraFucntionButton: UIButton!
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var tfComments: UITextField!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var tblComment :UITableView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var btnGift: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    
    @IBOutlet weak var shareBrodcastBtn: UIButton!
    @IBOutlet weak var userBackView: UIView!
    
    @IBOutlet weak var lblUserLive: UILabel!
    
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var firstName : UILabel!
    @IBOutlet weak var lblLike : UILabel!
    @IBOutlet weak var userImg : CustomImageView!
    
    
    @IBOutlet weak var btnCancel: UIButton!
    
//    func generateAnimatedViews() {
//       let image = drand48() > 0.5 ? #imageLiteral(resourceName: "heartAniIcon") : #imageLiteral(resourceName: "heartAniIcon")
//       let imageView = UIImageView(image: image)
//       let dimension = 20 + drand48() * 10
//       imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
//
//       let animation = CAKeyframeAnimation(keyPath: "position")
//
//       animation.path = AppUtility?.customPath().cgPath
//       animation.duration = 2 + drand48() * 3
//       animation.fillMode = CAMediaTimingFillMode.forwards
//       animation.isRemovedOnCompletion = true
//       animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//
//       imageView.layer.add(animation, forKey: nil)
//        self.userBackView.addSubview(imageView)
//       DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
//           imageView.removeFromSuperview()
//       }
//   }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backView.isHidden = true
        tblComment.delegate = self
        tblComment.dataSource = self
        commentView.isHidden = true
        btnSend.layer.borderWidth = 1.0
        btnSend.layer.borderColor = UIColor(named: "colorAccent")?.cgColor
        tfComments.layer.cornerRadius = 8.0
        tfComments.layer.borderWidth = 1.0
        tfComments.layer.borderColor = UIColor(named: "lightgraycolor")?.cgColor
        
        
        tblComment.register(UINib(nibName: "ShareTableViewCell", bundle: nil), forCellReuseIdentifier: "ShareTableViewCell")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadComments(notification:)), name: Notification.Name("loadComments"), object: nil)
        
       
        
    }
    
    
    
        @objc func loadComments(notification: Notification) {
            if (notification.userInfo?["commentsArray"] as? [[String:Any]]) != nil {
                print("error: ")
                print(notification.userInfo?["commentsArray"] as? [[String:Any]])
                let array = notification.userInfo?["commentsArray"] as? [[String:Any]]
                self.commentsArr = array
                ?? [[:]]
                print(self.commentsArr)
                scrollToBottom()
                self.tblComment.reloadData()
            }else{
                print(notification.userInfo?["commentsArray"] as? [[String:Any]])
                print("startOver pressed")
            }
        }
    
   
    func scrollToBottom(){
        if commentsArr.count > 1 {
//            let cell = self.tblComment.cellForRow(at: IndexPath(row: 0, section: 0))as? commentsNewTableViewCell
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.commentsArr.count-1, section: 0)
    //            cell?.tblComment.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.tblComment.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
    }
    
    
}

extension cameraCollectionViewCell:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
        
        
        let userName = (self.commentsArr[indexPath.row]["userName"] as? String ?? "unknown User")
        
        var commentText = (self.commentsArr[indexPath.row]["comment"] as? String)
        var userId = (self.commentsArr[indexPath.row]["userId"] as? String)
      
        print(commentText ?? "")
        // 1==========https://firebasestorage.googleapis.com/v0/b/woow-77985.appspot.com/o/Gifts%2Fgift1.png?alt=media&token=af7b9da9-738a-4968-b281-bfccc18a20d3=====1
        
        let type = (self.commentsArr[indexPath.row]["type"] as? String)
        if type == "comment" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentsNewTableViewCell", for: indexPath) as! commentsNewTableViewCell
            cell.userName.text = userName
            cell.comment.text =  commentText
            cell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.userImg.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: (self.commentsArr[indexPath.row]["userPicture"] as? String ?? "unknown User")))!), placeholderImage: #imageLiteral(resourceName: "noUserImg"))
            
            cell.userImg.layer.cornerRadius = cell.userImg.frame.height / 2.0
            cell.userImg.layer.masksToBounds = true
            
            return cell
            
          }else /*if type == "joined" */{
              let cell = tableView.dequeueReusableCell(withIdentifier: "commentsNewTableViewCell", for: indexPath) as! commentsNewTableViewCell
              cell.userName.text = userName + "  Joined"
              cell.comment.text =  commentText
              cell.comment.isHidden = true
              cell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.white
              cell.userImg.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: (self.commentsArr[indexPath.row]["userPicture"] as? String ?? "unknown User")))!), placeholderImage: #imageLiteral(resourceName: "noUserImg"))
              
              cell.userImg.layer.cornerRadius = cell.userImg.frame.height / 2.0
              cell.userImg.layer.masksToBounds = true
              
              return cell
              
            }/*else if type == "like" {
              
//              let giftcell = tableView.dequeueReusableCell(withIdentifier: "giftNewTableViewCell", for: indexPath) as! giftNewTableViewCell
//
////            var fullNameArr = commentText?.components(separatedBy:"1==========")
////            print(fullNameArr ?? "")
////            fullNameArr = commentText?.components(separatedBy:"=====")
////            let giftUrl: String = fullNameArr?[2] ?? ""
////            let lastName: String = fullNameArr?[3] ?? ""
////
////            print(giftUrl)
////            print(lastName)
////            commentText = "\(userName) sent $\(lastName)"
//
//            giftcell.userName.text = commentText
////            giftcell.giftImg.sd_imageIndicator = SDWebImageActivityIndicator.white
////            giftcell.giftImg.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: giftUrl))!), placeholderImage: #imageLiteral(resourceName: "noUserImg"))
//
//            return giftcell
          }else if type == "shareStream" {
//              let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
//              cell.isHidden = true
//              cell.btnShare.tag = indexPath.row
//              cell.btnShare.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: .touchUpInside)
//
//              return cell
              
            }else { //if type == "gift" {
              
//              let giftcell = tableView.dequeueReusableCell(withIdentifier: "giftNewTableViewCell", for: indexPath) as! giftNewTableViewCell
//
//            var fullNameArr = commentText?.components(separatedBy:"1==========")
//            print(fullNameArr ?? "")
//            fullNameArr = commentText?.components(separatedBy:"=====")
//            let giftUrl: String = fullNameArr?[2] ?? ""
//            let price: String = fullNameArr?[1] ?? ""
//
//                if userId == UserDefaultsManager.shared.user_id {
//                    commentText = "\(userName) Sent \(price)"
//                }else{
//                    commentText = "\(userName) sent you \(price)"
//                }
//
//            giftcell.userName.text = commentText
//            giftcell.giftImg.sd_imageIndicator = SDWebImageActivityIndicator.white
//            giftcell.giftImg.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: giftUrl))!), placeholderImage: #imageLiteral(resourceName: "noUserImg"))
//
//            return giftcell
          } //else {
//            return cell
//        }
        
        */
        
        
    }
    
    @objc func shareButtonPressed(sender:UIButton){
        
//        if let rootViewController = UIApplication.topViewController() {
//            let myViewController = InviteLiveFriendsViewController(nibName: "InviteLiveFriendsViewController", bundle: nil)
//            myViewController.modalPresentationStyle = .overFullScreen
//            rootViewController.navigationController?.isNavigationBarHidden = true
//            rootViewController.navigationController?.present(myViewController, animated: true)
//        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = (self.commentsArr[indexPath.row]["type"] as? String)
//        if type == "comment" {
            return 60
//          }else {
//              return 30
//          }
//        return 60
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        //        label.frame = CGRect.init(x: 35, y: headerView.frame.midY, width: headerView.frame.width-10, height: headerView.frame.height)
        label.numberOfLines = 0
        label.textDropShadow()
        label.font = .boldSystemFont(ofSize: 14)// .systemFont(ofSize: 14.0)
        if #available(iOS 13.0, *) {
            label.textColor = .white// UIColor(named: "colorAccent")
        } else {
            label.textColor = .white //UIColor(named: "colorAccent")
        }
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        // label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        
        label.text = "Welcome to WOOW LIVE! Enjoy interacting with others in real time. Hosts and Viewers must be 18 or older to go LIVE & to send gifts."
        
        
        
        return headerView
        
    }
}
