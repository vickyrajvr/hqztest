//
//  RequestVerificationViewController.swift
//  SmashVideos
//
//  Created by Mac on 02/11/2022.
//

import UIKit

class RequestVerificationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    let randomInt = Int.random(in: 0..<8)
    
    var user = ""
    var name = ""
    var imgData = ""
    
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var tbnSend: UIButton!
    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var lblApply: UILabel!
    @IBOutlet weak var tfFulName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        tfUsername.text = user
        tfFulName.text = name
    }
    
    @IBAction func btnSelectImageAction(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            //here is the image

            self.imgData = (image.jpegData(compressionQuality: 0.1)?.base64EncodedString())!
            self.lblApply.text = "image \(self.randomInt).png"
            
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        print("pressed")
    }
    @IBAction func btnSend(_ sender: Any) {
        //        self.dismiss(animated: true, completion: nil)
        if imgData != ""{
            verificationAPI()
        }else{
          self.showToast(message: "Photo is Missing", font: .systemFont(ofSize: 12))
        }
    
    }
    
    func verificationAPI(){
        self.loader.isHidden = false

        ApiHandler.sharedInstance.userVerificationRequest(user_id: UserDefaultsManager.shared.user_id, attachment: ["file_data":self.imgData]) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    self.loader.isHidden = true
                    //self.showToast(message: "Request Submitted", font: .systemFont(ofSize: 12))
                    //sleep(1)
                    self.navigationController?.popViewController(animated: true)
                    print("response: ",response)
                }else{
                    self.loader.isHidden = true
                    //self.showToast(message: "Something Went Wrong", font: .systemFont(ofSize: 12))

                    print("response: ",response)
                }

            }
        }
    }

}
