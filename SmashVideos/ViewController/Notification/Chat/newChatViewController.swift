//
//  ChatViewController.swift
//  WOOW
//
//  Created by Mac on 25/08/2022.
//

 
 


//    func numberOfSections(in tableView: UITableView) -> Int {
//            return sections.count
//        }
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return sections[section].count
//        }
//
//    let event = sections[indexPath.section].events[indexPath.row]
//    let events = eventGroup[indexPath.section]
//        let dateRow = events[indexPath.row].start
//        let dateRowEnd = events[indexPath.row].end
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let myString = formatter.string(from: dateRow)
//        let yourDate = formatter.date(from: myString)
//        formatter.dateFormat = "MM-dd-yyyy h:mm a"
//        let myStringafd = formatter.string(from: yourDate!)
//
//        cell.titleLabel.text = eventList[indexPath.row].title
//        cell.dateStartLabel.text = "Start date: \(myStringafd)"


import UIKit
import IQKeyboardManagerSwift
import Firebase
import SDWebImage
import QCropper
struct ChatMessage {
    let text : String
    let isIncoming: Bool
    let date: Date
    let type : String
    let chat_id : String
    let pic_url : String
    let receiver_id : String
    let sender_id : String
    let sender_name : String
    let time : String
}
struct ChatSection {
    let chatDate: [ChatMessage]
}


class newChatViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    func groupedSectionsByDate(from events: [ChatMessage]) -> [ChatSection] {
        let sortChatArray = events.sorted(by: { ($0.date) < ($1.date) } )
        let grouped = Dictionary(grouping: sortChatArray) { $0.date.toString() }
        let grouped1 = sortChatArray.sliced(by: [.year, .month, .day, .hour, .minute], for: \.date)
        // here you will need a date formatter object that will be used to convert
        // the Date type to String type. It's left as an assignment for the reader
        let dateFormatter: DateFormatter // init and configure it yourself
        let sections = grouped1.map { ChatSection(chatDate: $0.value) }
        let sortedArray = sections.sorted(by: { ($0.chatDate[0].date) < ($1.chatDate[0].date) } )
        return sortedArray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true;
        }
        return false
    }
    //MARK:- OUTLET
    
    var isFirstTime = false
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: CustomImageView!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    
    @IBOutlet weak var btnSend: UIButton!
//    @IBOutlet weak var tfSend: UITextField!
    
    @IBOutlet weak var lblMessage: UILabel!
    
        var imagedata = Data()
        let imagePicker = UIImagePickerController()
        
    var profilePicData = ""
    var profilePicSmallData = ""
    var originalImage: UIImage?
        var cropperState: CropperState?
    
        //    var currentUserId = Auth.auth().currentUser!.uid
        
        var dict = [String : Any]()
        var receiverDict = [String : Any]()
        
        var receiverData = [userMVC]()
        var otherVisiting = false
        
        var msgDict = [String : Any]()
        
        var receiverName = String()
        var receiverProfile = String()
        var senderName = String()
        var senderProfile = String()
        
        var dateString = String()
        
        var currentUserName = String()
        
        var senderID = "1"
        var receiverID = "2"
        
        var currentUserId = "2"
  
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtMessageHeight: NSLayoutConstraint!
    @IBOutlet weak var accessoryViewBottom: NSLayoutConstraint!
    @IBOutlet weak var accessoryView: CustomView!
    var minTextViewHeight: CGFloat = 40
    var maxTextViewHeight: CGFloat = 100
    
    var arrMessages = [ChatMessage]()
    var groupedMessages = [[ChatMessage]]()
    
    var sections = [ChatSection]()
    
    var timeFormatter = DateFormatter()
        var myUser: [User]? {didSet {}}
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.disabledToolbarClasses.append(newChatViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(newChatViewController.self)
        
     //   self.hideKeyboardWhenTappedAround()
        myUser = User.readUserFromArchive()
        
        print("myUser: ",myUser![0].username)
        self.senderName = myUser![0].username
        self.senderProfile = (AppUtility?.detectURL(ipString: myUser![0].profile_pic))!
        self.senderID = UserDefaultsManager.shared.user_id
        
        if otherVisiting == true{
            let obj = receiverData[0]
            self.receiverID = obj.userID
            self.receiverName = obj.username
            self.lblName.text = self.receiverName
            self.receiverProfile = (AppUtility?.detectURL(ipString:obj.userProfile_pic))!
            let userImgUrl = URL(string: receiverProfile)
           
            self.imgProfile.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
            
            print("receiverProfile: ",receiverProfile)
            
        }else{
            self.receiverID = receiverDict["rid"] as? String ?? "receiver id"
            self.receiverName = receiverDict["name"] as? String ?? "name"
            //        self.receiverID = msgDict["rid"] as? String ?? "receiver id"
            self.lblName.text = self.receiverName
            self.receiverProfile = ((AppUtility?.detectURL(ipString: receiverDict["pic"] as! String))!)
            let userImgUrl = URL(string: receiverProfile)
          
            self.imgProfile.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
            print("receiverProfile: ",receiverProfile)
        }
        
        txtMessage.text = "Send Message..."
        txtMessage.textColor = UIColor.lightGray
        
        txtMessage.delegate = self
        timeFormatter.dateFormat = "EEEE HH:mm aa"
        ChatDBhandler.shared.fetchMessage(senderID: senderID, receiverID: receiverID) { (isSuccess, message) in
            self.arrMessages.removeAll()
            self.sections.removeAll()
            if isSuccess == true
            {
                for key in message
                {
                    let messages = key.value as? [String : Any] ?? [:]
                    print(messages)
                    let dateStr = messages["timestamp"] as? String
                    print(dateStr)
//                    self.arrMessages.append(messages)
//                    self.arrMessages.sort(by: { ("\($0["timestamp"]!)") < ("\($1["timestamp"]!)") })
//                    let grouped = arrMessages.sliced(by: [.year, .month, .day], for: \.createdAt)
//                    self.arrMessages.sort(by: { ("\($0.time)")  ("\($1.time)") })
                    
//                    self.arrMessages.sort(by: { { $0.time > $1.time })
                    let text = messages["text"] as? String
                    let sender_id = messages["sender_id"] as? String
                    let timestamp = messages["timestamp"] as? String
                    let type = messages["type"] as? String
                    let chat_id = messages["chat_id"] as? String
                    let pic_url = messages["pic_url"] as? String
                    let receiver_id = messages["receiver_id"] as? String
                    let sender_name = messages["sender_name"] as? String
                    let time = messages["time"] as? String
                    
                    var iscomming = false
                    if sender_id == UserDefaultsManager.shared.user_id {
                        iscomming = false
                    }else {
                        iscomming = true
                    }
                    let datest = timestamp!.toDate(withFormat: "dd-MM-yyyy' 'HH:mm:ssZZ")// toDate()
                    let obj = ChatMessage(text: "\(text ?? "")", isIncoming: iscomming, date: datest!, type: "\(type ?? "")", chat_id: "\(chat_id ?? "")", pic_url: "\(pic_url ?? "")", receiver_id: "\(receiver_id ?? "")", sender_id: "\(sender_id ?? "")", sender_name: "\(sender_name ?? "")", time: "\(time ?? "")")
                    
                    self.arrMessages.append(obj)
                }
                
                let g = self.groupedSectionsByDate(from: self.arrMessages)
                               print(g)
                self.sections = g
                self.chatTableView.reloadData()
                let row = self.sections[self.sections.count - 1].chatDate.count - 1
                self.chatTableView.scrollToRow(at: IndexPath(row: row, section: self.sections.count - 1), at: .bottom, animated: true)
                
               // self.txtMessage.text = ""
                self.txtMessage.textColor = UIColor.lightGray
            }
        }

        
        self.txtMessage.tintColor = #colorLiteral(red: 0.9568627451, green: 0.5490196078, blue: 0.01960784314, alpha: 1)
        self.txtMessage.tintColorDidChange()
        self.txtMessage.delegate = self
        
        self.imagePicker.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
       
        
//        if tfSend.text == "" {
//            btnSend.setImage(UIImage(named: "2Artboard 1 copy 3"), for: .normal)
//        }else {
            btnSend.setImage(UIImage(named: "ic_send"), for: .normal)
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if self.isFirstTime == false {
                    let keyboard = keyboardSize.height + 40
                    self.view.frame.origin.y -= keyboard
                    self.isFirstTime = true
                }else {
                    self.view.frame.origin.y -= keyboardSize.height
                }
                
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    
    //MARK:- scroll to bottom
    func scrollToBottom()
    {
        if sections.count > 0
        {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.sections.count-1, section: 0)
                self.chatTableView.isPagingEnabled = false
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    //MARK:- tap gesture
    @objc func tapImage(sender:UITapGestureRecognizer)
    {
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.modalPresentationStyle = .fullScreen
//        self.present(imagePicker, animated: true, completion: nil)
        
        var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func openCamera(){
//        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
//            self.viewController!.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallery(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Change the height of textView when type
    func textViewDidChange(_ textView: UITextView)
    {
        var height = textView.contentSize.height
        
        if height < minTextViewHeight
        {
            height = minTextViewHeight
        }
        
        if (height > maxTextViewHeight)
        {
            height = maxTextViewHeight
        }
        
        if height != txtMessageHeight.constant
        {
            txtMessageHeight.constant = height
            textView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    //    MARK:- PLACEHOLDER OF TEXT VIEW
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
               // textView.text = "Send Message..."
                textView.textColor = UIColor.lightGray
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            }
        }
    
    
    //MARK:- TEXTFIELD DELEGATE
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        if tfSend.text == "" {
//            btnSend.setImage(UIImage(named: "2Artboard 1 copy 3"), for: .normal)
//        }else {
//            btnSend.setImage(UIImage(named: "ic_send"), for: .normal)
//        }
    }
    
    
    
    //MARK:- BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func alertButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func attachButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
    }
    
    
    // MARK: - ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[.originalImage] as? UIImage) else { return }

               originalImage = image
        NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
               // Custom
               // let cropper = CustomCropperViewController(originalImage: image)
               // Circular
               // let cropper = CropperViewController(originalImage: image, isCircular: true)
               let cropper = CropperViewController(originalImage: image)

               cropper.delegate = self

               picker.dismiss(animated: true) {
                   self.present(cropper, animated: true, completion: nil)
               }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
        NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
    }
   
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        sendPressed()
    }
    func sendPressed() {
        self.txtMessage.becomeFirstResponder()
        if self.txtMessage.text == ""
        {
            AppUtility!.displayAlert(title: "customChat", message: "Please type your message")
        }
        else
        {
            let time = Date().millisecondsSince1970
            let date = Date(timeIntervalSince1970: Double(time)/1000)
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd-MM-yyyy' 'HH:mm:ssZZ"
                   dateFormatter.amSymbol = "am"
                   dateFormatter.pmSymbol = "pm"
                   let dateString = dateFormatter.string(from: date)
            print(dateString)
            let textTimestamp = dateString
            
            //            AppUtility?.startLoader(view: self.view)
            
            print("sender: \(senderID) && receiver: \(receiverID)")
            
            print("self.txtMessage.text: ",self.txtMessage.text!)
            let msg = self.txtMessage.text!
            ChatDBhandler.shared.sendMessage(senderID: senderID, receiverID: receiverID, senderName: self.senderName, message: self.txtMessage.text!, status: "0", time: "", textTimestamp: "\(textTimestamp)", type: "text"){ (isSuccess) in
                if isSuccess == true{
                    print("Message Sent")
                    let userID = UserDefaultsManager.shared.user_id // UserDefaults.standard.string(forKey: "userID")
                    //        sendMsgNoti()
                    ApiHandler.sharedInstance.sendMessageNotification(senderID: userID, receiverID: self.receiverID, msg: self.txtMessage.text!, title: self.senderName,video_id : "") { (isSuccess, response) in
                        if isSuccess{
                            if response?.value(forKey: "code") as! NSNumber == 200{
                                let msg = response!["msg"] as! String
                                print("msg noti sent: ",msg)
                                self.showToast(message: msg, font: .systemFont(ofSize: 12))
                               
                            }else{
                                print("!200: ",response as Any)
                            }
                        }
                    }
                    
//                    self.txtMessage.textColor = UIColor.lightGray

                }
            }
            ChatDBhandler.shared.userChatInbox(senderID: self.senderID, receiverID: self.receiverID, image: receiverProfile, name: self.receiverName, message: self.txtMessage.text!, timestamp: time, date: "\(time)", status: "1") { (result) in
                if result == true
                {
                    print("user Sent")
                    self.txtMessage.text = ""
                }
            }
                 
            self.txtMessageHeight.constant = 40 //self.minTextViewHeight
        }
    }
    
}

//MARK:- EXTENSION TABLE VIEW

extension newChatViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.sections.count == 0
        {
            return 0
        }
        else
        {
            return self.sections.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.sections[section].chatDate.count == 0
        {
          //  self.lblMessage.isHidden = false
            return 0
        }
        else
        {
          //  self.lblMessage.isHidden = true
            
            return self.sections[section].chatDate.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell6", for: indexPath)as! ChatTableViewCell
        let event = self.sections[indexPath.section]
        let obj = event.chatDate[indexPath.row]
        print(obj)
        let picture = obj.pic_url
        if obj.isIncoming == false {
            if obj.type == "text" {
                let chatCell1 = tableView.dequeueReusableCell(withIdentifier: "chatCell4") as! ChatTableViewCell
                chatCell1.lblRightChat.text = obj.text // arrMessages[indexPath.row]["text"] as? String ?? "text"
                
//                cell.chatMessage = obj

    //                chatCell1.lblDate.text = dateString
                chatCell1.lblRightSeenTime.text = ""
                
                chatCell1.lblRightChat.isUserInteractionEnabled = true
                chatCell1.lblRightChat.tag = indexPath.row
                chatCell1.lblRightChat.superview?.tag = indexPath.section
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
//
                chatCell1.lblRightChat.addGestureRecognizer(longPressRecognizer)
                
                chatCell1.lblRightSeenTime.isHidden = true
                return chatCell1
            }else if obj.type == "delete" {
                let chatCell1 = tableView.dequeueReusableCell(withIdentifier: "chatDeleteCell") as! ChatTableViewCell
                chatCell1.lblDelete.text = "This message is deleted by \(obj.sender_name)"
                return chatCell1
            }else {
                let chatCell2 = tableView.dequeueReusableCell(withIdentifier: "chatCell5") as! ChatTableViewCell
                chatCell2.imgRightChat.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                chatCell2.imgRightChat.sd_setImage(with: URL(string: picture), placeholderImage: UIImage(named: "videoPlaceholder"))
                
                chatCell2.imgRightChat.tag = indexPath.row
                chatCell2.imgRightChat.superview?.tag = indexPath.section
                let tap = UITapGestureRecognizer(target: self, action:  #selector(self.imagePreview(sender:)))
                
                
//                let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.imagePreview(_:)))
                chatCell2.imgRightChat.isUserInteractionEnabled = true
                chatCell2.imgRightChat.addGestureRecognizer(tap)
                
              
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
//
                chatCell2.imgRightChat.addGestureRecognizer(longPressRecognizer)
                
                return chatCell2
            }
        }else {
            if obj.type == "text" {
                let chatCell3 = tableView.dequeueReusableCell(withIdentifier: "chatCell1") as! ChatTableViewCell
                chatCell3.lblLeft.text = obj.text
//                cell.chatMessage = obj
                //                chatCell3.lblRightSeenTime.text = dateString
                return chatCell3
            }else if obj.type == "delete" {
                let chatCell1 = tableView.dequeueReusableCell(withIdentifier: "chatDeleteCell") as! ChatTableViewCell
                chatCell1.lblDelete.text = "This message is deleted by \(obj.sender_name)"
                return chatCell1
            }else {
                let chatCell4 = tableView.dequeueReusableCell(withIdentifier: "chatCell2") as! ChatTableViewCell
                chatCell4.imgLeft.sd_imageIndicator = SDWebImageActivityIndicator.gray
                chatCell4.imgLeft.sd_setImage(with: URL(string: picture), placeholderImage: UIImage(named: "videoPlaceholder"))
                
//                let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.imagePreview(_:)))
//                chatCell4.imgLeft.isUserInteractionEnabled = true
//                chatCell4.imgLeft.addGestureRecognizer(tap)
                
                chatCell4.imgLeft.tag = indexPath.row
                chatCell4.imgLeft.superview?.tag = indexPath.section
                let tap = UITapGestureRecognizer(target: self, action:  #selector(self.imagePreview(sender:)))
                
                
                chatCell4.imgLeft.isUserInteractionEnabled = true
                chatCell4.imgLeft.addGestureRecognizer(tap)
                
//                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
////
//                chatCell4.imgLeft.addGestureRecognizer(longPressRecognizer)
                
                
                
                return chatCell4
            }
        }
       

        return cell
    }
    @objc func handleLongPress(_ gesture: UITapGestureRecognizer){
        print("long press")
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: ""), message: "", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "Deleted a message", style: .default) { (action:UIAlertAction!) in
            let event = self.sections[gesture.view?.superview?.tag ?? 0]
            let obj = event.chatDate[gesture.view?.tag ?? 0]
            let type = obj.type
            let picture = obj.pic_url
            let chat_id = obj.chat_id
            print("pic: ",picture)
            if type == "image" || type == "text"
            {
//                let vc = ImagePreviewViewController(nibName: "ImagePreviewViewController", bundle: nil)
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.imgUrl =  picture
//                vc.isUserPofile = false
//                self.present(vc, animated: true, completion: nil)

                
                let time = Date().millisecondsSince1970
                let date = Date(timeIntervalSince1970: Double(time)/1000)
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "dd-MM-yyyy' 'HH:mm:ssZZ"
                       dateFormatter.amSymbol = "am"
                       dateFormatter.pmSymbol = "pm"
                       let dateString = dateFormatter.string(from: date)
                print(dateString)
                let textTimestamp = dateString
                
                //            AppUtility?.startLoader(view: self.view)
                
                print("sender: \(self.senderID) && receiver: \(self.receiverID)")
                
                print("self.txtMessage.text: ",self.txtMessage.text!)
                ChatDBhandler.shared.deleteMessage(senderID: self.senderID, receiverID: self.receiverID, senderName: self.senderName, message: "Deleted a message", status: "0", time: "", textTimestamp: "\(textTimestamp)", type: "delete", chat_id : "\(chat_id)"){ (isSuccess) in
                    if isSuccess == true{
                        print("Message Sent")
                        let userID = UserDefaultsManager.shared.user_id // UserDefaults.standard.string(forKey: "userID")
                        //        sendMsgNoti()
                        ApiHandler.sharedInstance.sendMessageNotification(senderID: userID, receiverID: self.receiverID, msg: "Deleted a message", title: self.senderName,video_id : "") { (isSuccess, response) in
                            if isSuccess{
                                if response?.value(forKey: "code") as! NSNumber == 200{
                                    let msg = response!["msg"] as! String
                                    print("msg noti sent: ",msg)
                                    self.showToast(message: msg, font: .systemFont(ofSize: 12))
                                }else{
                                    print("!200: ",response as Any)
                                }
                            }
                        }
                    }
                }
                ChatDBhandler.shared.userChatInbox(senderID: self.senderID, receiverID: self.receiverID, image: self.receiverProfile, name: self.receiverName, message: "Deleted a message", timestamp: time, date: "\(time)", status: "1") { (result) in
                    if result == true
                    {
                        print("user Sent")
                    }
                }
                
                
            }
            
            
//            let tapLocation = gesture.location(in: self.chatTableView)
//            let indexPath = self.chatTableView.indexPathForRow(at: tapLocation)!
//
//            let chat_id = self.arrMessages[indexPath.row].chat_id
            
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)

        
       
        
    }
    //MARK:- tap getsure recognizer
    
    @objc func imagePreview(sender : UITapGestureRecognizer) {
        // Do what you want
        let event = self.sections[sender.view?.superview?.tag ?? 0]
        let obj = event.chatDate[sender.view?.tag ?? 0]
        let type = obj.type
        let picture = obj.pic_url
        print("pic: ",picture)
        if type == "image"
        {
            let vc = ImagePreviewViewController(nibName: "ImagePreviewViewController", bundle: nil)
            vc.modalPresentationStyle = .overCurrentContext
            vc.imgUrl =  picture
            vc.isUserPofile = false
            self.present(vc, animated: true, completion: nil)

        }
    }
    
    
    @objc func imagePreview(_ gesture: UITapGestureRecognizer)
    {
        let tapLocation = gesture.location(in: self.chatTableView)
        let indexPath = self.chatTableView.indexPathForRow(at: tapLocation)!

        let type = self.arrMessages[indexPath.row].type
        let picture = arrMessages[indexPath.row].pic_url

        print("pic: ",picture)
        if type == "pic"
        {

            let vc = ImagePreviewViewController(nibName: "ImagePreviewViewController", bundle: nil)
            vc.modalPresentationStyle = .overCurrentContext
            vc.imgUrl =  picture
            vc.isUserPofile = false
            self.present(vc, animated: true, completion: nil)

        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let firstMsg = self.arrMessages[section].time as? String
//
//        return firstMsg
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // header view
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .white

        var date1 = ""
        let view = UIView()
        view.backgroundColor = UIColor(named: "lightgraycolor")
        view.layer.cornerRadius = 5.0
        
        let event = self.sections[section]
        
        let obj = event.chatDate[0]
        
        
      //  let reversedIndex = self.arrMessages.count - 1 - section
        let firstMsg = obj.date as? Date
        
    
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale// Locale(identifier: "fa-IR")
        dateFormatter.timeZone = Calendar.current.timeZone// TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "MMM d, h:mm a"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        let str = dateFormatter.string(from: firstMsg as? Date ?? Date())
        
        
        let dat = str //firstMsg?.toString() //firstMsg?.toDate(withFormat: "MM-dd-yyyy HH:mm") //formatDate(date: firstMsg)
        print("datt \(dat)")
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "graycolor2")
        lbl.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        lbl.text = "\(dat ?? "")"
        
        

        headerView.addSubview(view)
        headerView.addSubview(lbl)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //view.widthAnchor.constraint(equalToConstant: 60).isActive = true


        lbl.translatesAutoresizingMaskIntoConstraints = false
       // lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        lbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true



        return headerView

    }
    
    func formatDate(date: String) -> String {
       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ssZ"
        
       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .medium
       dateFormatter.timeStyle = .none
       //    dateFormatter.locale = Locale(identifier: "en_US") //uncomment if you don't want to get the system default format.

       let dateObj: Date? = dateFormatterGet.date(from: date)

       return dateFormatter.string(from: dateObj!)
    }
    
}
extension Sequence {
    func groupSort(ascending: Bool = true, byDate dateKey: (Iterator.Element) -> Date) -> [[Iterator.Element]] {
        var categories: [[Iterator.Element]] = []
        for element in self {
            let key = dateKey(element)
            guard let dayIndex = categories.firstIndex(where: { $0.contains(where: { Calendar.current.isDate(dateKey($0), inSameDayAs: key) }) }) else {
                guard let nextIndex = categories.firstIndex(where: { $0.contains(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) }) else {
                    categories.append([element])
                    continue
                }
                categories.insert([element], at: nextIndex)
                continue
            }

            guard let nextIndex = categories[dayIndex].firstIndex(where: { dateKey($0).compare(key) == (ascending ? .orderedDescending : .orderedAscending) }) else {
                categories[dayIndex].append(element)
                continue
            }
            categories[dayIndex].insert(element, at: nextIndex)
        }
        return categories
    }
}

extension Array {
  func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
    let initial: [Date: [Element]] = [:]
    let groupedByDateComponents = reduce(into: initial) { acc, cur in
      let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
      let date = Calendar.current.date(from: components)!
      let existing = acc[date] ?? []
      acc[date] = existing + [cur]
    }

    return groupedByDateComponents
  }
}

extension newChatViewController: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
        cropper.dismiss(animated: true, completion: nil)
        
        if let state = state,
            let image = cropper.originalImage.cropped(withCropperState: state) {
            cropperState = state
//            imageView.image = image
            print(cropper.isCurrentlyInInitialState)
            print(image)
            
//            profileImage.contentMode = .scaleAspectFill
//            profileImage.image = image
            self.profilePicData = (image.jpegData(compressionQuality: 0.1)?.base64EncodedString())!
            NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
//            let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
                // resize our selected image
                let resizedImage = image.convert(toSize:CGSize(width:100.0, height:100.0), scale: UIScreen.main.scale)
            self.profilePicSmallData = (resizedImage.jpegData(compressionQuality: 0.1)?.base64EncodedString())!
            
            
//            self.addUserImgAPI()
            
//            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//            {
                self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
            self.imagedata = (image.jpegData(compressionQuality: 0.1))! // pickedImage.jpegData(compressionQuality: 0.25)!
                
                let time = Date().millisecondsSince1970
                let date = Date(timeIntervalSince1970: Double(time)/1000)
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "dd-MM-yyyy' 'HH:mm:ssZZ"
                       dateFormatter.amSymbol = "am"
                       dateFormatter.pmSymbol = "pm"
                       let dateString = dateFormatter.string(from: date)
                print(dateString)
                let textTimestamp = dateString
                AppUtility?.startLoader(view: self.view)
                ChatDBhandler.shared.sendImage(senderName : self.senderName, senderID: senderID, receiverID: receiverID, image: imagedata, seen: false, time: textTimestamp, type: "image") { (result, url) in
                    if result == true
                    {
                        print("image sent")
                        NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
                        ChatDBhandler.shared.userChatInbox(senderID: self.senderID, receiverID: self.receiverID, image: self.receiverProfile, name: self.receiverName, message: "Send an image...", timestamp: time, date: "\(textTimestamp)", status: "0") { (result) in
                            if result == true
                            {
                                print("user Sent")
    //                            self.sendMsgNoti()
                                AppUtility?.stopLoader(view: self.view)
                                //                            ChatDBhandler.shared.sendPushNotification(to: self.userToken, title: self.currentUserName, body: "Send an Image")
                            }
                        }
                        

                    }
                    
                }
//            }
//            else
//            {
//                print("Error in pick Image")
//            }
            
            
            
        }
    }
    
    func cropperDidCancel(_ cropper: CropperViewController) {
        NotificationCenter.default.post(name: .requestChatImg, object: "requestChatImg", userInfo: [:])
    }
}
