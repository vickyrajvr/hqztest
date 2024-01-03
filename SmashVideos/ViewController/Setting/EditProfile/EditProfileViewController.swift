//
//  EditProfileViewController.swift
//  SmashVideos
//
//  Created by Mac on 04/11/2022.
//

import UIKit
import SDWebImage
import QCropper
import Alamofire
import AVFoundation

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var originalImage: UIImage?
        var cropperState: CropperState?

        lazy var startButton: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - 200, width: view.frame.size.width, height: 40))
            button.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
            button.setTitle("Start", for: .normal)
            return button
        }()

        lazy var reeditButton: UIButton = {
            let button = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - 160, width: view.frame.size.width, height: 40))
            button.addTarget(self, action: #selector(reeditButtonPressed(_:)), for: .touchUpInside)
            button.setTitle("Re-edit", for: .normal)
            return button
        }()
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
    }()
    
    var exportSession: AVAssetExportSession!

    var DOBString: String?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var DOBBtn: UIButton!
    @IBOutlet weak var pronouneBtn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnUsername: UIButton!
    @IBOutlet weak var btnCopyLink: UIButton!
    @IBOutlet weak var btnBio: UIButton!
    
    @IBOutlet weak var vidoeProfileImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var userData = [userMVC]()
    var profilePicData = ""
    var videoURL : URL!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.setup()
    }
    
    func setup(){
       
        let name = (userData[0].first_name)
        self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.profileImage.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: userData[0].userProfile_pic))!), placeholderImage: UIImage(named:"noUserImg"))
        self.btnName.setTitle(name, for: .normal)
        self.btnUsername.setTitle(userData[0].username, for: .normal)
        self.btnCopyLink.setTitle("musictok.com/"+userData[0].username, for: .normal)
        self.btnBio.setTitle(userData[0].bio, for: .normal)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        view.addSubview(startButton)
        view.addSubview(reeditButton)
        
    }

    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
        func startButtonPressed(_: UIButton) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }

        @objc
        func reeditButtonPressed(_: UIButton) {
            if let image = originalImage, let state = cropperState {
                let cropper = CropperViewController(originalImage: image, initialState: state)
                cropper.delegate = self
                present(cropper, animated: true, completion: nil)
            }
        }
    
    @IBAction func btnNameAction(_ sender: Any) {
        let myViewController = EditProfileDataViewController(nibName: "EditProfileDataViewController", bundle: nil)
        myViewController.type = "Name"
        myViewController.userData = self.userData
        myViewController.callback = { (username,bio,name) -> Void in
            print("username",username)
            print("bio",bio)
            print("name",name)
            self.btnUsername.setTitle(username, for: .normal)
            self.btnCopyLink.setTitle("musictok.com/"+username, for: .normal)
            self.btnBio.setTitle(bio, for: .normal)
            self.btnName.setTitle(name, for: .normal)
            
           
        }
        self.navigationController?.pushViewController(myViewController, animated: true)
        
    }
    @IBAction func btnUsernameAction(_ sender: Any) {
        let myViewController = EditProfileDataViewController(nibName: "EditProfileDataViewController", bundle: nil)
        myViewController.type = "Username"
        myViewController.userData = self.userData
        myViewController.callback = { (username,bio,name) -> Void in
            print("username",username)
            print("bio",bio)
            print("name",name)
            self.btnUsername.setTitle(username, for: .normal)
            self.btnCopyLink.setTitle("musictok.com/"+username, for: .normal)
            self.btnBio.setTitle(bio, for: .normal)
            self.btnName.setTitle(name, for: .normal)
           
        }
        self.navigationController?.pushViewController(myViewController, animated: true)
      
    }
    @IBAction func btnCopyLinkAction(_ sender: Any) {
        copyLink()
    }
    
    func copyLink(){
        
        var link = btnCopyLink.titleLabel?.text
        UIPasteboard.general.string = link
        if UIPasteboard.general.string != nil {
            //            alertModule(title: "Copy", msg: "Url Copied to Pasteboard")
           
            showToast(message: "URL Copied", font: .systemFont(ofSize: 12))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
            
        }

        
    }
    @IBAction func btnBioAction(_ sender: Any) {
        let myViewController = EditProfileDataViewController(nibName: "EditProfileDataViewController", bundle: nil)
        myViewController.type = "Bio"
        myViewController.userData = self.userData
        
        myViewController.callback = { (username,bio,name) -> Void in
            print("username",username)
            print("bio",bio)
            print("name",name)
            self.btnUsername.setTitle(username, for: .normal)
            self.btnCopyLink.setTitle("musictok.com/"+username, for: .normal)
            self.btnBio.setTitle(bio, for: .normal)
            self.btnName.setTitle(name, for: .normal)
           
        }
        self.navigationController?.pushViewController(myViewController, animated: true)
      
    }
   
    @IBAction func btnImageAction(_ sender: Any) {
        // Your action
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    
        
    }
    
    // MARK: - ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            dismiss(animated: true, completion: nil)
            print("mediaURL",mediaURL)
            
            
            self.loader.isHidden = false
            let headers: HTTPHeaders = [
                "Api-Key":API_KEY
            ]
            let parameter :[String:Any] = ["user_id"       : UserDefaultsManager.shared.user_id,
                                           "extension": "mp4"
            ]

            let url : String = ApiHandler.sharedInstance.baseApiPath+"addUserImage"

            print("parameter",parameter)
            print("url",url)
            print("headers",headers)
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
                MultipartFormData.append(mediaURL, withName: "file", fileName: mediaURL.lastPathComponent, mimeType: "video/mp4")
              


            }, to: url, method: .post, headers: headers)

            .uploadProgress(closure: { (progress) in

                print("Upload Progress: \(progress.fractionCompleted)")

            })

                .responseJSON { (response) in

                    switch response.result{

                    case .success(let value):

                        let json = value
                        let dic = json as! NSDictionary

                        print("response:- ",response)
                        if(dic["code"] as! NSNumber == 200){

                            let msgDict = dic.value(forKey: "msg") as! NSDictionary
                            let userDict = msgDict.value(forKey: "User") as! NSDictionary
                            let profImgUrl = userDict.value(forKey: "profile_pic") as! String

                            self.vidoeProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            self.vidoeProfileImage.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: profImgUrl))!), placeholderImage: UIImage(named:"noUserImg"))
                            isRun = true
                            self.loader.isHidden = true
                        }else{
                            self.loader.isHidden = true
                            self.showToast(message: "Error Occur", font: .systemFont(ofSize: 12))
                        }
                    case .failure(let error):
                        print("error",error.localizedDescription)
                        self.loader.isHidden = true
                        self.showToast(message: "Error Occur", font: .systemFont(ofSize: 12))

                   }
                    
            }
        
         

        }
        

        guard let image = (info[.originalImage] as? UIImage) else { return }
        
        originalImage = image
        let cropper = CropperViewController(originalImage: image)

        cropper.delegate = self
        
        picker.dismiss(animated: true) {
              self.present(cropper, animated: true, completion: nil)
        }
        
               
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func btnVideoAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
  
    
}

extension EditProfileViewController: CropperViewControllerDelegate {
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)

        if let state = state,
            let image = cropper.originalImage.cropped(withCropperState: state) {
            cropperState = state
//            imageView.image = image
            print(cropper.isCurrentlyInInitialState)
            print(image)
            
            profileImage.contentMode = .scaleAspectFill
           // profileImage.image = image
            
            self.loader.isHidden = false
            
            self.profilePicData = (image.jpegData(compressionQuality: 0.1)?.base64EncodedString())!
            
            
            let imageData = image.pngData()!
            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp_image.png")
            do {
                try imageData.write(to: tempURL, options: .atomic)
                let parameters: [String: Any] = [
                    "user_id"       : UserDefaultsManager.shared.user_id,
                    "extension": "png"
                ]
               
                let url : String = ApiHandler.sharedInstance.baseApiPath+"addUserImage"
                let headers: HTTPHeaders = [
                    "Api-Key":API_KEY
                ]
                print("tempURL",tempURL)
                
                   
                AF.upload(multipartFormData: { multipartFormData in
                       for key in parameters.keys{
                           let name = String(key)
                           if let val = parameters[name] as? String{
                               multipartFormData.append(val.data(using: .utf8)!, withName: name)
                           }
                       }
                       multipartFormData.append(imageData, withName: "file", fileName: "temp_image.png", mimeType: "image/png")
                    
                    
                    
                   }, to: url, method: .post, headers: headers).validate().responseJSON { response in
                       switch response.result {
                       case .success(let value):
                           print("Upload success: \(value)")
                           let json = value
                           let dic = json as! NSDictionary
                           let msgDict = dic.value(forKey: "msg") as! NSDictionary
                           let userDict = msgDict.value(forKey: "User") as! NSDictionary
                           let profImgUrl = userDict.value(forKey: "profile_pic") as! String
                           
                           self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                           self.profileImage.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: profImgUrl))!), placeholderImage: UIImage(named:"noUserImg"))
                           isRun = true
                           self.loader.isHidden = true
                       case .failure(let error):
                           print("Upload failed: \(error)")
                           self.loader.isHidden = true
                           // handle upload error here
                       }
                   }
                
               
            } catch {
                print(error)
            }
          
  
          
            
        }
    }
    
    
    //Datepicker
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            DOBString = "\(day) \(month) \(year)"
            print("date of birth \(DOBString)")
        }
    }
}

