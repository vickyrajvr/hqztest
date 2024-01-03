//
//  SharePopViewController.swift
//  SmashVideos
//
//  Created by Mac on 31/10/2022.
//

import UIKit
import FBSDKShareKit
import MessageUI
import Photos
import SDWebImage

class SharePopViewController: UIViewController,MFMessageComposeViewControllerDelegate {
    
    //MARK:- VARS
    
    let shareToArr = ["copy","wa","sms","twitter","waStatus","fb","other"]
    var objToShare = [String]()
    var shareUrl = ""
    var profileID = ""
    
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    var img_Url = ""
    
    //MARK:- OUTLET
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var shareCollectionView: UICollectionView!

    @IBOutlet weak var imgProfile: CustomImageView!
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgProfile.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: img_Url))!), placeholderImage: UIImage(named:"noUserImg"))
        
        shareCollectionView.delegate = self
        shareCollectionView.dataSource = self
        
        objToShare.removeAll()
        shareUrl = BASE_URL+"?"+randomString(length: 3)+profileID+randomString(length: 3)
        objToShare.append(shareUrl)
        
        shareCollectionView.register(UINib(nibName: "ShareToCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShareToCollectionViewCell")

    }
    
    
    //MARK:- FUNCTION
    func copyLink(){
        
        
        UIPasteboard.general.string = self.shareUrl
        if UIPasteboard.general.string != nil {
            //            alertModule(title: "Copy", msg: "Url Copied to Pasteboard")
           
            showToast(message: "URL Copied", font: .systemFont(ofSize: 12))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
            
        }

        
    }
    
   
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func shareOnWhatsapp(){
        
         let msg = self.shareUrl
         let urlWhats = "whatsapp://send?text=\(shareUrl)"
         if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
               if let whatsappURL = NSURL(string: urlString) {
                     if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                          UIApplication.shared.open(whatsappURL as URL)
                      }
                      else {
                          print("please install watsapp")
                           alertModule(title: "Whatsapp", msg: "Please install Whatsapp")
                      }
               }
         }
        
       
    }
    
    
    func shareOnSMS(){
        
        let msg = self.shareUrl
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = msg
            //                controller.recipients = [phoneNumberTextField.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
        print("SMS SENT")
    }
    
    func shareOnTwitter(){
        let tweetText = "MUSICTOK APP\n"
        let tweetUrl = self.shareUrl
        
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        let url = URL(string: escapedShareString)
        
        // open in safari
        //        UIApplication.shared.openURL(url!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    
    func shareTextOnFaceBook() {
        let shareContent = ShareLinkContent()
        //        shareContent.contentURL = URL.init(string: "https://developers.facebook.com")!
        shareContent.contentURL = URL.init(string: self.shareUrl)!//your link
        shareContent.quote = "MUSICTOK APP"
        
        ShareDialog(viewController: self, content: shareContent, delegate: self as? SharingDelegate).show()
    }
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent?.pageID != nil {
            print("FBShare: Success")
        }
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("FBShare: Fail")
    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("FBShare: Cancel")
    }
    
    func otherFunc(){
        let activityViewController = UIActivityViewController(activityItems: objToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.saveToCameraRoll]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- BUTTON ACTION
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.backView {
            dismiss(animated: false, completion: nil)
            
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    
    
}


//MARK:- EXTENSION FOR COLLECTION VIEW

extension SharePopViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return shareToArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareToCollectionViewCell", for: indexPath)as! ShareToCollectionViewCell
        cell.imgShareto.image = UIImage(named: shareToArr[indexPath.row])
        return cell
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.shareCollectionView.frame.width / 5.1, height: 80.0)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch shareToArr[indexPath.row] {
        case "copy":
            print("copy")
            copyLink()
        case "wa":
            print("Whatsapp Tapped")
            shareOnWhatsapp()
        case "sms":
            shareOnSMS()
            print("sms Tapped")
        case "twitter":
            print("twitter Tapped")
            shareOnTwitter()
        case "waStatus":
            print("waStatus Tapped")
            shareOnWhatsapp()
        case "fb":
            print("fb Tapped")
            shareTextOnFaceBook()
        case "other":
            print("other Tapped")
            otherFunc()
        default:
            print("DEFAULT")
            
        }
        
    }
    
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
