//
//  InboxViewController.swift
//  WOOW
//
//  Created by Mac on 29/06/2022.
//

import UIKit
import Firebase
import SDWebImage
class InboxViewController: UIViewController {
  
    //MARK:- OUTLET
    
    private lazy var loader : UIView = {
       return (AppUtility?.createActivityIndicator((UIApplication.shared.keyWindow?.rootViewController?.view)!))!
    }()
    
    @IBOutlet weak var whoopView: UIView!
    
    @IBOutlet weak var inboxTableView: UITableView!
    var senderID = ""
    var arrConversation = [[String : Any]]()
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        inboxTableView.delegate = self
        inboxTableView.dataSource = self
        
        inboxTableView.register(UINib(nibName: "InboxTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxTableViewCell")
        senderID = UserDefaultsManager.shared.user_id
        self.loader.isHidden = false
        ChatDBhandler.shared.fetchUserInbox(userID: self.senderID) { (isSuccess, conversation) in
            self.arrConversation.removeAll()

            for key in conversation
            {
                let conver = key.value as? [String: Any] ?? [:]
                self.arrConversation.append(conver)
                self.arrConversation.sort(by: { ("\($0["timestamp"])") > ("\($1["timestamp"])") })
            }
            self.loader.isHidden = true
            self.inboxTableView.reloadData()
        }
        
        if arrConversation.count == 0{
            self.whoopView.isHidden = false
        }else{
            self.whoopView.isHidden = true
        }
        
    }
    
    //MARK:- BUTTON ACTION
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK:- EXTENSION TABLE VIEW

extension InboxViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrConversation.count == 0
        {
          //  self.lblMessage.isHidden = false
            return 0
        }
        else
        {
           // self.lblMessage.isHidden = true
            return self.arrConversation.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell", for: indexPath)as! InboxTableViewCell
        let data = self.arrConversation[indexPath.row]
        let image = data["pic"] as? String ?? "pic"
        let name = data["name"] as? String ?? "name"
        let lastMessage = data["msg"] as? String ?? "message"
        let dateMessage = data["date"] as? String ?? "date"
        let timestamp = data["timestamp"] as? String ?? "timestamp"
        let epochTime = Double("\(dateMessage)") ?? 0.0
        let newTime = Date(timeIntervalSince1970: TimeInterval(epochTime))
        print(newTime)
        
        let dateFormatterNow = DateFormatter()
        dateFormatterNow.locale = Locale(identifier: "EN")
        dateFormatterNow.dateFormat = "HH:mm:ss a" // "dd-MM-yyyy"
        let createdDate = dateMessage //sections[section].createDate! as? String ?? "2019-06-23 12:54:00 "
        let localCreateDate = createdDate.convertedDigitsToLocale(Locale(identifier: "EN"))

        print("localCreateDate",localCreateDate)
        let dateComment = dateFormatterNow.date(from: localCreateDate)
        print("localCreateDate",dateComment ?? "")
        
        print("currentDate",currentDate())
        
        
        let date1 = Date(timeIntervalSince1970: (Double("\(timestamp)") ?? 0)/1000 )
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm a" //Specify your format that you want
        let strDate = dateFormatter.string(from: date1)
        
        print("strDate", strDate)
        
        print("dateMessage",dateMessage)
        let type = data["type"] as? String ?? "type"
        
        
        if type == "text"
        {
            let userChatCell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell", for: indexPath)as! InboxTableViewCell
            
          
            
            userChatCell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userChatCell.imgProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "noUserImg"))
            userChatCell.lblName.text = name
            userChatCell.lblMsg.isHidden = false
            userChatCell.lblMsg.text = lastMessage
//            userChatCell.lblDate.text = "\(strDate)"
//            userChatCell.lblDate.isHidden = true
//            userChatCell.hiddenView.isHidden = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(longTap))
            userChatCell.deleteBtn.addGestureRecognizer(tap)
            
            
            return userChatCell
        }
        else
        {
            let userChatCell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell", for: indexPath)as! InboxTableViewCell
            
            userChatCell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userChatCell.imgProfile.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "noUserImg"))
            userChatCell.lblName.text = name
            userChatCell.lblMsg.isHidden = false
            userChatCell.lblMsg.text = lastMessage
           // userChatCell.lblDate.isHidden = true
//            userChatCell.hiddenView.isHidden = false
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(longTap))
            userChatCell.deleteBtn.addGestureRecognizer(tap)
            
            
            return userChatCell
        }

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
//        chatVC.receiverDict = self.arrConversation[indexPath.row]
//        navigationController?.pushViewController(chatVC, animated: true)
        
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = story.instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
        chatVC.receiverDict = self.arrConversation[indexPath.row]
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    @objc func longTap(gestureReconizer: UITapGestureRecognizer)
    {
        let longPress = gestureReconizer as UITapGestureRecognizer
        _ = longPress.state
        let locationInView = longPress.location(in: inboxTableView)
       
        let indexPath = inboxTableView.indexPathForRow(at: locationInView)!
        print("indexPath",indexPath)
        let alert = UIAlertController.init(title: "Delete this Chat?", message: "Meesage will only be removed from this account.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            print("Cancel")
        }))
        
        alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
            print("Delete")
            
            let rid = self.arrConversation[indexPath.row]["rid"] as? String ?? "rid"
            
            ChatDBhandler.shared.deleteConversation(senderID: self.senderID, receiverID: rid) { (isSuccess) in
                if isSuccess == true
                {
                    print("conversation And chat is deleted: ", indexPath.row)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
