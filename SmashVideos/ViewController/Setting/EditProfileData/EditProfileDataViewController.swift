//
//  EditProfileDataViewController.swift
//  SmashVideos
//
//  Created by Mac on 04/11/2022.
//

import UIKit

class EditProfileDataViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    //MARK:- VARS
    
    var type = ""
    
    var name = ""
    var username = ""
    var bio = ""
    var userData = [userMVC]()
    var callback: ((_ username: String,_ bio:String, _ name:String ) -> Void)?
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
    }()
    //MARK:- OUTLET

    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    //name
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblLimitName: UILabel!
    
    
    //username
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var usernameView: UIView!
    
    //bio
    
    
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var lblBioCount: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = type
        name = userData[0].first_name
        username = userData[0].username
        bio = userData[0].bio
        if type == "Name"{
            self.lblLimitName.isHidden = true
            self.bioTextView.isHidden = true
            self.usernameView.isHidden = true
            self.nameView.isHidden = false
            self.tfName.delegate = self
            
            self.tfName.text = name
            self.lblCount.text = "\(Int(name.count))/30"
            
        }else if type == "Username" {
            self.bioTextView.isHidden = true
            self.nameView.isHidden = true
            self.usernameView.isHidden = false
            tfUsername.delegate = self
            self.tfUsername.text = username
        }else {
            self.usernameView.isHidden = true
            self.nameView.isHidden = true
            self.bioView.isHidden = false
            self.bioTextView.delegate = self
            self.bioTextView.text = bio
            self.lblBioCount.text = "\(Int(bio.count))/80"
        }
       
    }
    
    //MARK:- BUTTON ACTION
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if type == "Name"{
            self.addProfileDataAPI()
        }else if type == "Username" {
            self.addProfileDataAPI()
        }else {
            self.addProfileDataAPI()
        }
    }
    
    
    //MARK:- TEXTFIELD DELEGATE

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if type == "Name"{
            let maxLength = 30
            let currentString = (tfName.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            print(tfName.text ?? "")
            print(newString)
           
                return newString.count <= maxLength
            
        }else if type == "Username" {
            
            let maxLength = 24
            let currentString = (tfUsername.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            print(tfUsername.text ?? "")
            print(newString)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            }
            
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
            if newString.rangeOfCharacter(from: characterset.inverted) != nil {
                print("string contains special characters")
                self.lblUsername.isHidden = false
                self.lblUsername.text = "Only Letters, numbers, underscores or periods are allowed."
                self.btnSave.alpha = 0.5
                self.btnSave.isUserInteractionEnabled = false
            }else {
                self.lblUsername.isHidden = true
                if textField == self.tfUsername {
                    self.registerUsernameCheck(username: newString as String)
                    
                   
                    
                }
                
                return newString.count <= maxLength
            }
            
            
        }
       
    return true
       
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxLength = 80
        let currentString = (bioTextView.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: text)
        print(bioTextView.text ?? "")
        print(newString)
       
            return newString.count <= maxLength
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if type == "Name"{
        lblCount.text = "\(Int(tfName.text!.count))/30"
        }else if type == "Username" {
            
        }else {
            
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        lblBioCount.text = "\(Int(bioTextView.text!.count))/80"
    }
    
    
    // MARK: - API CALLING
    func registerUsernameCheck(username: String){
        
        ApiHandler.sharedInstance.registerUsernameCheck(username: username) { (isSuccess, response) in
            
            if isSuccess{
                let msg = response?["msg"] as? String ?? ""
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    if self.tfUsername.text?.count ?? 0 < 3 {
                        self.lblUsername.isHidden = false
                        self.lblUsername.text = "username is too short"
                       
                    }else {
                        
                        self.lblUsername.isHidden = true
                        self.username = username
                        self.btnSave.alpha = 1
                        self.btnSave.isUserInteractionEnabled = true
                    }
                }else{
                    
                    let msg = response?["msg"] as? String ?? ""
                    if msg == "already exist" {
                        self.lblUsername.isHidden = false
                        self.lblUsername.text = "this username is not available try a new one"
                        self.btnSave.alpha = 0.5
                        self.btnSave.isUserInteractionEnabled = false
                        
                    }else {
                        self.lblUsername.isHidden = true
                    }
                    
                }
                
            }else {
                self.username = ""
            }
            
        }
        
    }
    
    func addProfileDataAPI(){
        let userObj = userData[0]
        
        var username = userObj.username
        var firstName = userObj.first_name
        let lastName = ""
        var web = userObj.website
        var bio = userObj.bio
        let gender = userObj.gender
        
        if type == "Name" {
            guard tfName.text! != "" else {
                self.showToast(message: "Invalid Name", font: .systemFont(ofSize: 12))
                return
            }
            firstName = tfName.text!
        }else if type == "Username"{
            username = tfUsername.text!
        }else {
            bio = bioTextView.text!
        }
        

        self.loader.isHidden = false
        
        ApiHandler.sharedInstance.editProfile(isPhoneChange: false, isEditProfile: true, username: username, user_id: UserDefaultsManager.shared.user_id, first_name: firstName, last_name: "", gender: gender, website: web, bio: bio, dob: "", privateKey: "", phone: "") { isSuccess, response in
            self.loader.isHidden = true
                       if isSuccess{
                           if response?.value(forKey: "code") as! NSNumber == 200{
                               self.callback!(username,bio,firstName)
                               isRun = true
                               self.showToast(message: "Porfile Upated", font: .systemFont(ofSize: 12))
                               self.navigationController?.popViewController(animated: true)
           
                           }else{
                               self.showToast(message: "Unable To Update", font: .systemFont(ofSize: 12))
                               print("!200: ",response as Any)
                           }
                       }
        }
  
    }



}
