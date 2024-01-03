//
//  CommentViewController.swift
//  WOOW
//
//  Created by Wasiq Tayyab on 10/06/2022.
//


import UIKit
import Alamofire
//import Kingfisher
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import GrowingTextView
import SDWebImage
import KeyboardLayoutGuide
protocol CommentCountUpdateDelegate {
    func CommentCountUpdateDelegate(commentCount : Int)
    
}
class CommentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UITextViewDelegate{
    
    @IBOutlet weak var lblNoComment: UILabel!
    //MARK:- Outlets
    var commentDelegate : CommentCountUpdateDelegate?
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var tfGowingTextField: GrowingTextView!
    @IBOutlet weak var tfView: UIView!
    
    private(set) var liked_count:Int! = 0
    private(set) var liked = false
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    var heightComment : CGFloat?
    
    var refreshLoader = false
    
    var Allow_Comment = "true"
    var loadData = false
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    var myUser:[User]? {didSet{}}
    var sections: [Section] = []
    var Video_Id = "0"
    var startingPoint = 0
    var commentID = "0"
    let spinner = UIActivityIndicatorView(style: .white)
    var totalPages = 1
    var isDataLoading:Bool=false
    
    
    //MARK:- viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfGowingTextField.delegate = self
        self.setupView()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
        tfView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuideNoSafeArea.topAnchor).isActive = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            dismiss(animated: true, completion: nil)
            
        }
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
//
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "darkGrey") {
            textView.text = nil
            textView.textColor = UIColor(named: "black")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Leave a comment...."
            textView.textColor = UIColor(named: "darkGrey")
        }
    }
    
    //MARK:- SetupView
    
    func setupView(){
        self.loadData =  true
       // self.myUser = User.readUserFromArchive()
        self.tfGowingTextField.delegate =  self
        //print("login user image:\((self.myUser?[0].image)!)")
//        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.white
//        self.imgProfile.sd_setImage(with: URL(string:AppUtility?.detectURL(ipString:self.myUser?[0].image ?? "") ?? ""), placeholderImage: UIImage(named:"NoUserImage"))
        self.registerXIB()
        self.showVideoComments(videoID: Video_Id, Pagenumber: 0)
        
    }
    
    //MARK:- XIB Register
    
    func registerXIB(){
        
        //TableView fooer spinner
        
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        tblComment.tableFooterView = spinner
        tblComment.refreshControl =  self.refresher

        tblComment.register(UINib(nibName: "CommentRowTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentRowTableViewCell")
        
        tblComment.register(UINib(nibName: "CommentHeaderTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CommentHeaderTableView")
        
    }
    
    //MARK:- Refresher Controller
    
    @objc func requestData() {
        
        print("requesting data")
        self.startingPoint = 0
       
        self.loadData = false
        refreshLoader = true
        self.showVideoComments(videoID: Video_Id, Pagenumber: 0)
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
            self.refreshLoader = false
        }
        
    }
    //MARK:- Button Actions
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        if AppUtility!.isEmpty(self.tfGowingTextField.text!){
          //  AppUtility?.showToast(string: "Please enter some comments", view: self.view)
            return
        }
        if Allow_Comment == "false"{
           // AppUtility?.showToast(string: "Comment is Off", view: self.view)
            return
        }
        
        var desc = ""
        
        if tfGowingTextField.textColor == UIColor(named: "darkGrey") {
            tfGowingTextField.text = nil
            
        }else {
            desc = tfGowingTextField.text!
        }
        
        
        if commentID != "0"{
            self.postCommentReply(commentID: self.commentID)
        }else{
            self.postComment()
        }
        self.tfGowingTextField.resignFirstResponder()

        
    }
    
    @objc func btnProfilePressed(sender : UITapGestureRecognizer){
        var  obj =  self.sections[sender.view?.tag ?? 0]
        print("obj user id : ",obj.user_id)
        let header = self.tblComment.dequeueReusableCell(withIdentifier: "CommentHeaderTableView") as? CommentHeaderTableView
        let otherUserID = obj.user_id
        let userID = UserDefaultsManager.shared.user_id
        
        if userID == otherUserID{
//            loginScreenAppear()
        }else{
            if header?.lblName.text == "this user does not exist"{
            }else {
//                let storyMain = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyMain.instantiateViewController(withIdentifier: "ProfileVideoViewController")as! ProfileVideoViewController
//                vc.hidesBottomBarWhenPushed = true
//                vc.otherUserID = otherUserID ?? ""
//                vc.user_name = obj.name ?? ""
//                vc.modalPresentationStyle = .fullScreen
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func btnRplyUsrProfilePressed(sender : UITapGestureRecognizer){
//        var  obj =  self.sections[sender.view?.tag ?? 0]
        let  obj =  self.sections[sender.view?.superview?.tag ?? 0].items![sender.view?.tag ?? 0]
        print("obj user id : ",obj.user_id ?? "")
        let header = self.tblComment.dequeueReusableCell(withIdentifier: "CommentHeaderTableView") as? CommentHeaderTableView
        let otherUserID = obj.user_id
        let userID = UserDefaultsManager.shared.user_id
        
        if userID == otherUserID{
//            loginScreenAppear()
        }else{
            if header?.lblName.text == "this user does not exist"{
            }else {
//                let storyMain = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyMain.instantiateViewController(withIdentifier: "ProfileVideoViewController")as! ProfileVideoViewController
//                vc.hidesBottomBarWhenPushed = true
//                vc.otherUserID = otherUserID ?? ""
//                vc.user_name = obj.name ?? ""
//                vc.modalPresentationStyle = .fullScreen
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK:- Functions
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.sections.count-1, section: 0)
            self.tblComment.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].collapsed! ? 0 : sections[section].items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  =  tableView.dequeueReusableCell(withIdentifier: "CommentRowTableViewCell") as! CommentRowTableViewCell
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentHeaderTableView") as? CommentHeaderTableView
        let item: CommentItem = sections[indexPath.section].items![indexPath.row]
        
        
//        cell.btnReply.isHidden = true
        if sections[indexPath.section].items!.count - 1 == indexPath.row {
            cell.btnReply.isHidden = false
            header?.btnViewAllReply.isHidden = true
            
        }else {
            cell.btnReply.isHidden = true
        }
        
        cell.lblComments.text = item.comment
        cell.lblName.text = item.name
        cell.lblTotalLike.text = "\((item.like_count) ?? 0)".shorten()
        print("Pic",sections[indexPath.section].items![indexPath.row].pic )
        
        if sections[indexPath.section].items![indexPath.row].pic!.isValidURL{
            let userImgPath =  sections[indexPath.section].items![indexPath.row].pic ?? ""
            let userImgUrl = URL(string: userImgPath)
            cell.userImage.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
        }else{
            let userImgPath = BASE_URL +  sections[indexPath.section].items![indexPath.row].pic!
            let userImgUrl = URL(string: userImgPath)
            cell.userImage.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
        }
     
        
        if item.like == 1{
            
            cell.btnLike.setImage(UIImage(named: "ic_like_fill"), for: .normal)
        }else{
            cell.btnLike.setImage(UIImage(named: "ic_heart_gray_out"), for: .normal)
        }
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.superview?.tag = indexPath.section
        cell.btnReply.tag =  indexPath.section
        
        cell.btnLike.addTarget(self, action: #selector(self.CommentLiked(btn:)), for: .touchUpInside)
        cell.btnReply.addTarget(self, action: #selector(self.hideRow(section:)), for: .touchUpInside)
        
        let gestureUserImg = UITapGestureRecognizer(target: self, action:  #selector(self.btnRplyUsrProfilePressed(sender:)))
        cell.userImage.tag = indexPath.row
        cell.userImage.superview?.tag = indexPath.section
        gestureUserImg.view?.superview?.tag = indexPath.section
        gestureUserImg.view?.tag = indexPath.row
        cell.userImage.isUserInteractionEnabled = true
        cell.userImage.addGestureRecognizer(gestureUserImg)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentHeaderTableView") as? CommentHeaderTableView
        header?.lblComments.text = sections[section].comment
        header?.lblName.text = sections[section].name // .username
        
        self.heightComment = header?.lblComments.frame.height
        print("heightComment",heightComment)
        header?.btnViewAllReply.tag = section
        header?.btnLike.tag =  section
        header?.btnReply.tag =  section
        
        header?.btnReply.addTarget(self, action: #selector(self.btnReply(section:)), for: .touchUpInside)
        header?.btnViewAllReply.addTarget(self, action: #selector(self.hideRow(section:)), for: .touchUpInside)
        header?.btnLike.addTarget(self, action: #selector(self.headerCommentLiked(btn:)), for: .touchUpInside)
        
        if sections[section].items?.count  == 0 {
            header?.btnViewAllReply.isHidden = true
        }else{
            header?.btnViewAllReply.isHidden = false
        }
        
        let userImgPath = AppUtility?.detectURL(ipString: sections[section].pic ?? "")
        print("Header Imge:",userImgPath)
        let userImgUrl = URL(string:userImgPath!)
        header?.userImage.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
        
        let gestureUserImg = UITapGestureRecognizer(target: self, action:  #selector(self.btnProfilePressed(sender:)))
        header?.userImage.tag = section
        gestureUserImg.view?.tag = section
        header?.userImage.isUserInteractionEnabled = true
        header?.userImage.addGestureRecognizer(gestureUserImg)
       
        
        
        let dateFormatterNow = DateFormatter()
        dateFormatterNow.locale = Locale(identifier: "EN")
        dateFormatterNow.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createdDate = sections[section].createDate! as? String ?? "2019-06-23 12:54:00 "
        let localCreateDate = createdDate.convertedDigitsToLocale(Locale(identifier: "EN"))

        print("localCreateDate",localCreateDate)
        print("currentDate",currentDate())
        let dateComment = dateFormatterNow.date(from: localCreateDate)
        header?.lblCommentTime.text  = AppUtility?.timeAgoSinceDate(dateComment!, currentDate: currentDate() , numericDates: false)

        header?.lblTotalLike.text = "\((sections[section].like_count) ?? 0)".shorten()
        
        if sections[section].like == 1{
            header?.btnLike.setImage(UIImage(named: "ic_like_fill"), for: .normal)
            self.liked = true
        }else{
            self.liked = false
            header?.btnLike.setImage(UIImage(named: "ic_heart_gray_out"), for: .normal)
        }
        
        let objItems =  sections[section].items
        for var i in  0..<objItems!.count{
            if objItems![i].id as! String == ""{
                header?.btnViewAllReply.isHidden = true
            }else{
                header?.btnViewAllReply.setTitle("view replies (\(sections[section].items!.count))" , for:.normal)
            }
        }
        return header
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat{
        return 32
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            print("Next page call")
//            if self.startingPoint < self.totalPages{
//                self.startingPoint = self.startingPoint + 1
//                self.refreshLoader =  true
//                //spinner.startAnimating()
//                self.showVideoComments(videoID: self.Video_Id,Pagenumber:   self.startingPoint)
//            }
        }
    }
    
    
    //MARK:- Delegate funcations
    
    @objc func hideRow(section:UIButton){
        
        
        let collapsed = !sections[section.tag].collapsed!
        if collapsed == false{
            self.commentID =  sections[section.tag].id!
        }else{
            self.commentID =  "0"
        }
        print("collapsed",collapsed)
        print("commentID",commentID)
        sections[section.tag].collapsed = collapsed
        tblComment.reloadSections(NSIndexSet(index: section.tag) as IndexSet, with: .automatic)
    }
    
    @objc func btnReply(section:UIButton){
        self.tfGowingTextField.becomeFirstResponder()
        self.commentID =  sections[section.tag].id!
    }
    
    
    
    @objc func headerCommentLiked(btn:UIButton){
        print("section",btn.superview!.tag)
        print("index",btn.tag)
        
        var  obj =  self.sections[btn.tag]
//        if obj.like == 1 {
//            liked_count = liked_count - 1
//            obj.like = 0
//            obj.like_count  = liked_count!
//            self.headerCommentLiked(commentID: obj.id! )
//        }else{
//            liked_count = liked_count + 1
//            obj.like = 1
//            obj.like_count  = liked_count!
//            self.headerCommentLiked(commentID: obj.id!)
//        }
        
        self.myUser = User.readUserFromArchive()
        ApiHandler.sharedInstance.likeComments(user_id:UserDefaultsManager.shared.user_id, comment_id:  obj.id!) { (isSuccess, response) in
            if isSuccess {
                print(response)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let like_count = response?.value(forKey: "like_count") as? NSNumber
                    if let msg = response?.value(forKey: "msg") as? String {
                        if msg == "unfavourite" {
                            if obj.like == 1 {
                                self.liked_count = self.liked_count - 1
                                
                                obj.like = 0
                                obj.like_count  = Int(truncating: like_count ?? 0)
//                                self.headerCommentLiked(commentID: obj.id! )
                                self.sections.remove(at: btn.tag)
                                self.sections.insert(obj, at: btn.tag)
                                self.tblComment.reloadSections(NSIndexSet(index: btn.tag) as IndexSet, with: .automatic)
                            }
                        }
                    }else {
                        if obj.like == 0{
                            self.liked_count = self.liked_count + 1
                            obj.like = 1
                            obj.like_count  = Int(truncating: like_count ?? 0)
                            self.sections.remove(at: btn.tag)
                            self.sections.insert(obj, at: btn.tag)
                            self.tblComment.reloadSections(NSIndexSet(index: btn.tag) as IndexSet, with: .automatic)
                        }
                    }
                   
                }else{
                  
                }
            }else{
                //AppUtility!.showToast(string: response?.value(forKey: "msg") as! String, view:self.view)
            }
        }
        
        
//        self.sections.remove(at: btn.tag)
//        self.sections.insert(obj, at: btn.tag)
//        tblComment.reloadSections(NSIndexSet(index: btn.tag) as IndexSet, with: .automatic)
        
    }
    
    
    @objc func CommentLiked(btn:UIButton){
        print("section",btn.superview!.tag)
        print("index",btn.tag)
        
        var  objItems =  self.sections[btn.superview!.tag].items![btn.tag]
//        if objItems.like == 1 {
//            liked_count = liked_count - 1
//            objItems.like = 0
//            objItems.like_count  = liked_count!
//            self.ReplyCommentLiked(commentID: objItems.id! )
//        }else{
//            liked_count = liked_count + 1
//            objItems.like = 1
//            objItems.like_count  = liked_count!
//            self.ReplyCommentLiked(commentID: objItems.id!)
//        }
//        self.sections[btn.superview!.tag].items!.remove(at: btn.tag)
//        self.sections[btn.superview!.tag].items!.insert(objItems, at: btn.tag)
//        self.tblComment.reloadRows(at: [IndexPath(row: btn.tag, section: btn.superview!.tag)], with: .none)
        
        self.myUser = User.readUserFromArchive()
        ApiHandler.sharedInstance.likeReplyComments(user_id:UserDefaultsManager.shared.user_id, comment_reply_id: objItems.id!) { (isSuccess, response) in
            if isSuccess {
                print(response)
                let like_count = response?.value(forKey: "like_count") as? NSNumber
                if let msg = response?.value(forKey: "msg") as? String {
                    if msg == "unfavourite" {
                        if objItems.like == 1 {
                            self.liked_count = self.liked_count - 1
                            
                            objItems.like = 0
                            objItems.like_count  = Int(truncating: like_count ?? 0)
//                                self.headerCommentLiked(commentID: obj.id! )
                            self.sections[btn.superview!.tag].items!.remove(at: btn.tag)
                            self.sections[btn.superview!.tag].items!.insert(objItems, at: btn.tag)
                            self.tblComment.reloadRows(at: [IndexPath(row: btn.tag, section: btn.superview!.tag)], with: .none)
                        }
                    }
                }else {
                    if objItems.like == 0{
                        self.liked_count = self.liked_count + 1
                        objItems.like = 1
                        objItems.like_count  = Int(truncating: like_count ?? 0)
                        self.sections[btn.superview!.tag].items!.remove(at: btn.tag)
                        self.sections[btn.superview!.tag].items!.insert(objItems, at: btn.tag)
                        self.tblComment.reloadRows(at: [IndexPath(row: btn.tag, section: btn.superview!.tag)], with: .none)
                    }
                }
                
            }else{
               // AppUtility!.showToast(string: response?.value(forKey: "msg") as! String, view:self.view)
            }
        }
        
    }
    
    var totlaComments = ""
}
//MARK:- API Handler



extension CommentViewController{
    
    func headerCommentLiked(commentID:String){
        self.myUser = User.readUserFromArchive()
        ApiHandler.sharedInstance.likeComments(user_id:UserDefaultsManager.shared.user_id, comment_id: commentID) { (isSuccess, response) in
            if isSuccess {
                print(response)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    if let msg = response?.value(forKey: "msg") as? String {
                        if msg == "unfavourite" {
                            
                        }
                    }
                   
                }else{
                  
                }
            }else{
                //AppUtility!.showToast(string: response?.value(forKey: "msg") as! String, view:self.view)
            }
        }
    }
    func ReplyCommentLiked(commentID:String){
        self.myUser = User.readUserFromArchive()
        ApiHandler.sharedInstance.likeReplyComments(user_id:UserDefaultsManager.shared.user_id, comment_reply_id: commentID) { (isSuccess, response) in
            if isSuccess {
                print(response)
            }else{
               // AppUtility!.showToast(string: response?.value(forKey: "msg") as! String, view:self.view)
            }
        }
    }
    
    func postComment(){
        self.myUser = User.readUserFromArchive()
        ApiHandler.sharedInstance.postCommentOnVideo(user_id:UserDefaultsManager.shared.user_id, comment: self.tfGowingTextField.text!,video_id:self.Video_Id) { (isSuccess, response) in
            if isSuccess {
                print(response)
                self.tfGowingTextField.text = nil
                self.showVideoComments(videoID: self.Video_Id, Pagenumber: self.startingPoint)
            }else{
               // AppUtility!.showToast(string:error, view:self.view)
            }
        }
    }
    func postCommentReply(commentID:String){
        self.myUser = User.readUserFromArchive()
        ApiHandler.sharedInstance.postCommentReply(user_id:UserDefaultsManager.shared.user_id, comment: self.tfGowingTextField.text!,comment_id:commentID){ (isSuccess, response, error ) in
            if isSuccess {
                print(response)
                self.tfGowingTextField.text = nil
                self.showVideoComments(videoID: self.Video_Id,Pagenumber:  self.startingPoint)
            }else{
                //AppUtility!.showToast(string:error, view:self.view)
            }
        }
    }
    
    func showVideoComments(videoID:String,Pagenumber:Int){

        self.myUser = User.readUserFromArchive()
        if  refreshLoader == false{
            self.loader.isHidden =  false
        }
        var userID = ""
        if (myUser?.count != 0) && self.myUser != nil{
            userID = UserDefaultsManager.shared.user_id
        }else{
            return
        }
        
        ApiHandler.sharedInstance.showVideoComments(video_id:videoID ,user_id: UserDefaultsManager.shared.user_id , starting_point: Pagenumber) { (isSuccess, response) in
            self.loader.isHidden =  true
            if Pagenumber == 0 {
                self.sections.removeAll()
            }
            self.sections.removeAll()
            if isSuccess {
              
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let msg = response?.value(forKey: "msg")as![[String:Any]]
                    self.totlaComments = "\(msg.count)"
                    for objres in msg{
                        
                        let objVideo = objres["Video"] as! [String:Any]
                        if objVideo["allow_comments"] as! String == "true"{
                            self.Allow_Comment == "true"
                        }else{
                            self.Allow_Comment == "false"
                        }
                        
                     let data =  userComments.shared.userCommentDetail(obj:objres)
                        self.sections.append(data)
                    }
                    self.totalPages = self.totalPages + 1
                    self.refreshLoader =  false
                    self.tblComment.dataSource =  self
                    self.tblComment.delegate   =  self
                    self.tblComment.reloadData()
                    
                    if self.sections.count == 0{
                        self.lblNoComment.isHidden = false
                    }else {
                        self.lblNoComment.isHidden = true
                    }
                    
                    self.lblComment.text = "\(self.totlaComments) comments"
                    
                    self.commentDelegate?.CommentCountUpdateDelegate(commentCount: 1)
                    
                    
//                  if self.loadData == true{
//                        self.scrollToBottom()
//                    }
                }else{
                    self.refreshLoader =  false
                    self.totalPages = self.startingPoint
                    self.spinner.hidesWhenStopped = true
                    self.spinner.stopAnimating()
                }
            }else{
                self.loader.isHidden =  true
                print("response failed getFollowingVideos : ",response!)
                //AppUtility!.showToast(string: "Error", view:self.view)
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            guard let digit = Self.formatter.number(from: String($0)) else {
                assertionFailure("Can not convert to number from: \(original)")
                return (original, original)
            }
            guard let localized = Self.formatter.string(from: digit) else {
                assertionFailure("Can not convert to string from: \(digit)")
                return (original, original)
            }
            return (original, localized)
        }

        var converted = self
        for map in maps { converted = converted.replacingOccurrences(of: map.original, with: map.converted) }
        return converted
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
