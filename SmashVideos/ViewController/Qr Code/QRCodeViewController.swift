//
//  QRCodeViewController.swift
//  SmashVideos
//
//  Created by Mac on 23/01/2023.
//

import UIKit
import CoreImage
import SDWebImage
import MessageUI
import Photos
import FBSDKShareKit
class QRCodeViewController: UIViewController,MFMessageComposeViewControllerDelegate,SharingDelegate, UIDocumentInteractionControllerDelegate {
    
    //MARK: - VARS
    
    var full_name = ""
    var image_url = ""
    var user_name = ""
    let shareToArr = ["download 1","wa","insta","fb","sms","other"]
    var documentInteractionController: UIDocumentInteractionController = UIDocumentInteractionController()
    
    var isSave = false
    
    //MARK: - OUTLET
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var backView :UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    
    @IBOutlet weak var lblChangeColor: UILabel!
    
    @IBOutlet weak var shareToView: UIView!
    @IBOutlet weak var btnScan: UIButton!
    
    @IBOutlet weak var shareToCollectionView: UICollectionView!
    
    
    @IBOutlet weak var lblFullName: UILabel!
    
    @IBOutlet weak var circularContainer: UIImageView!
    @IBOutlet weak var circularView: UIView!
    
    
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if full_name == "" {
            self.lblFullName.text = user_name
        }else {
            self.lblFullName.text = full_name
        }
        
        self.circularContainer.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.circularContainer.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: image_url ?? ""))!), placeholderImage: UIImage(named:"noUserImg"))
        
        self.circleImage()
        self.qrCodeGeneration()
        backView.backgroundColor = .systemBlue
        // Add tap gesture to view
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
//        backView.addGestureRecognizer(tapGesture)
        
        
        
        shareToCollectionView.delegate = self
        shareToCollectionView.dataSource = self
        shareToCollectionView.register(UINib(nibName: "ShareToCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShareToCollectionViewCell")
        
    }
    
    
    
    //MARK: - BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        let myViewController = ScannerViewController(nibName: "ScannerViewController", bundle: nil)
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    
   
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        if let theme = UserDefaults.standard.string(forKey: "theme") {
            if theme == "dark" {
                self.overrideUserInterfaceStyle = .dark
            } else {
                self.overrideUserInterfaceStyle = .light
            }
        }
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    func saveTapped() {
        print("save")
        self.isSave = true
        self.takeScreenshot()
        
        
    }
    
    
    //MARK: - FUNCTION
    
    func circleImage(){
        // Set circular view corner radius
        circularView.layer.cornerRadius = circularView.frame.size.width/2
        circularView.center = circularContainer.center
        
        
        circularContainer.contentMode = .scaleAspectFill
        circularContainer.layer.cornerRadius = circularContainer.frame.size.width/2
        circularContainer.clipsToBounds = true
        
        // Add subviews
        circularView.addSubview(circularContainer)
    }
    
    func qrCodeGeneration(){
        // Data to be encoded in the QR code
        let data = SHARE_BASE_URL + "profile/" + UserDefaultsManager.shared.user_id
        print(data)
        
        // Create QR code filter
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(data.data(using: .utf8), forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        // Get QR code image
        guard let qrImage = qrFilter?.outputImage else { return }
        
        // Scale QR code to desired size
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        // Assign QR code to image outlet
        qrImageView.image = UIImage(ciImage: scaledQrImage)
    }
    
    func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        self.shareToView.isHidden = true
        self.btnScan.isHidden = true
        self.lblChangeColor.isHidden = true
        self.btnBack.isHidden = true
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if self.isSave == true {
            if let image = screenshotImage, shouldSave {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            self.showToast(message: "Saved", font: .systemFont(ofSize: 12))
        }else {
            
        }
        
        
        self.shareToView.isHidden = false
        self.btnScan.isHidden = false
        //self.lblChangeColor.isHidden = false
        self.btnBack.isHidden = false
        
        return screenshotImage
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
            self.isSave = false
            let image = self.takeScreenshot()
            let imageToShare = [image]
            let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
            self.present(activityViewController, animated: true, completion: nil)
        }
    
    
    func shareOnSMS(){
        self.isSave = false
        let image = self.takeScreenshot()
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            //controller.body = "Check out this image!"
            if let image = image, let imageData = image.pngData() {
                controller.addAttachmentData(imageData, typeIdentifier: "image/png", filename: "image.png")
            }
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            print("SMS services are not available")
            self.alertModule(title: "SMS", msg: "SMS services are not available")
        }
        
        
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func otherFunc(){
        self.isSave = false
        let image = self.takeScreenshot()
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.saveToCameraRoll]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func shareImageOnFaceBook() {
        self.isSave = false
    
        let image = self.takeScreenshot()
        let photo = SharePhoto(image: image!, isUserGenerated: true)
        let content = SharePhotoContent()
        content.photos = [photo]
        let shareDialog = ShareDialog(viewController: self, content: content, delegate: self)
        shareDialog.show()
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
    
    
    func shareImageOnIns(){
        self.isSave = false
        let image = self.takeScreenshot()
        let instagramURL = URL(string: "instagram://app")

        if UIApplication.shared.canOpenURL(instagramURL!) {
            let imageData = image!.jpegData(compressionQuality: 1.0)
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")

            do {
                try imageData?.write(to: URL(fileURLWithPath: writePath), options: .atomic)
            } catch {
                print(error)
            }

            let fileURL = URL(fileURLWithPath: writePath)
            self.documentInteractionController = UIDocumentInteractionController(url: fileURL)
            self.documentInteractionController.delegate = self
            self.documentInteractionController.uti = "com.instagram.exclusivegram"
            self.documentInteractionController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
        } else {
            print("Instagram not installed on device")
        
            self.alertModule(title: "Instagram", msg: "Instagram not installed on device")
        }
    }
    
    
    
}


//MARK:- EXTENSION FOR COLLECTION VIEW

extension QRCodeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareToArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareToCollectionViewCell", for: indexPath)as! ShareToCollectionViewCell
        cell.imgShareto.image = UIImage(named: shareToArr[indexPath.row])
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.shareToCollectionView.frame.width / 5.4, height: 80.0)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch shareToArr[indexPath.row] {
        case "download 1":
            print("download 1")
            saveTapped()
        case "wa":
            print("Whatsapp Tapped")
            shareOnWhatsapp()
            
            
        case "insta":
            print("insta Tapped")
            
            shareImageOnIns()
        case "fb":
            print("fb Tapped")
            shareImageOnFaceBook()
        case "sms":
            shareOnSMS()
            
            print("sms Tapped")
        case "other":
            print("other Tapped")
            otherFunc()
        default:
            print("DEFAULT")
        }
    }
    
    
    
}

