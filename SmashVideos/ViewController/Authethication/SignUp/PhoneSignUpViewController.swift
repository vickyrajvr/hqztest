//
//  PhoneSignUpViewController.swift
//  MusicTok
//
//  Created by Mac on 15/10/2022.
//

import UIKit
import ActiveLabel
import PhoneNumberKit
class PhoneSignUpViewController: UIViewController,UITextFieldDelegate{
    
    //MARK:- VARS
    var dialCode = "+92"
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    let phoneNumberKit = PhoneNumberKit()
    
    //MARK:- OUTLET
    @IBOutlet weak var lblLogin: ActiveLabel!
    
    @IBOutlet weak var tfPhoneNumber: PhoneNumberTextField!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var lblCode: UILabel!
    
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.countryDataNoti(_:)), name: NSNotification.Name(rawValue: "countryDataNoti"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("pauseSongNoti"), object: nil)
        self.activeSetupLabel()
        tfPhoneNumber.delegate = self
//        tfPhoneNumber.placeholder = "0311 4673838"
        tfPhoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tfPhoneNumber.isPartialFormatterEnabled = false
//
//
        self.tfPhoneNumber.defaultRegion = "PK"
        self.tfPhoneNumber.withExamplePlaceholder = true
        self.tfPhoneNumber.withPrefix = false
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.count == 0 && string == "0" {
            
            return false
        }
      
        return true
    }
    
    //MARK:-FUNCTION
    func activeSetupLabel(){
        let customType = ActiveType.custom(pattern: "Terms of Use")
        let customType1 = ActiveType.custom(pattern: "Privacy Policy")
        lblLogin.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        lblLogin.textAlignment = .center
        lblLogin.enabledTypes = [.mention, .hashtag, .url, customType,customType1]
        lblLogin.text = "By signing up,you can confirm to agree our Terms of Use and Privacy Policy"
        lblLogin.textColor = UIColor(named: "black")
        lblLogin.customColor[customType] = UIColor(named: "theme")
        lblLogin.customSelectedColor[customType] = UIColor(named: "theme")
        lblLogin.customColor[customType1] = UIColor(named: "theme")
        lblLogin.customSelectedColor[customType1] = UIColor(named: "theme")
        
        lblLogin.handleCustomTap(for: customType) { element in
            print("Terms of Use")
            let myViewController =  WebViewController(nibName: "WebViewController", bundle: nil)
            myViewController.linkTitle = "Terms of Service"
            myViewController.myUrl = "‌https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
            myViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(myViewController, animated: true)
        }
        lblLogin.handleCustomTap(for: customType1) { element in
            print("Privacy Policy")
            let myViewController =  WebViewController(nibName: "WebViewController", bundle: nil)
            myViewController.linkTitle = "Privacy Policy"
            myViewController.myUrl = "‌https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
            myViewController.modalPresentationStyle = .fullScreen
            
            self.navigationController?.pushViewController(myViewController, animated: true)
            
        }
        
    }
    
    //MARK:- BUTTON ACTION
    
    @IBAction func btnSendCodeAction(_ sender: Any) {
        
        if (AppUtility?.isEmpty(self.tfPhoneNumber.text))!{
            let alert = UIAlertController(title: "Alert", message: "Enter your valid Phone number", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if self.tfPhoneNumber.isValidNumber {
            self.verifyPhoneFunc()
        }else{
            let alert = UIAlertController(title: "Alert", message: "Phone number is not valid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    @IBAction func btnCountryCode(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "countryCodeVC") as! countryCodeViewController
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func countryDataNoti(_ notification: NSNotification) {
        let newDialCode = notification.userInfo?["dial_code"] as! String
        let code = notification.userInfo?["code"] as! String
        print("code",code)
        self.tfPhoneNumber.placeholder = phoneNumberKit.metadata(for: code)?.mobile?.exampleNumber
        self.tfPhoneNumber.defaultRegion = code
        self.dialCode = newDialCode
        self.lblCode.text = "\(code) \(newDialCode)"
    }
    
    //MARK:- FUNCTION
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = textField.text?.count
        
        print("change textCount: ",textCount)
        if textCount! > 0{
            btnSendCode.backgroundColor = UIColor(named: "theme")!
            btnSendCode.setTitleColor(UIColor(named: "white"), for: .normal)
            btnSendCode.isUserInteractionEnabled = true
        }else{
            btnSendCode.backgroundColor = UIColor(named: "lightGrey")
            btnSendCode.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
            btnSendCode.isUserInteractionEnabled = false
        }
    }
    
    func verifyPhoneFunc(){
        
        let phoneNo = self.dialCode+tfPhoneNumber.text!
        
        print("phoneNo: ",phoneNo)
        self.loader.isHidden = false
        ApiHandler.sharedInstance.verifyPhoneNo(phone: phoneNo, verify: "0") { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    
                    print("respone: ",response?.value(forKey: "msg") as! String)
                    if #available(iOS 12.0, *) {
                        let myViewController = PhoneOtpLoginViewController(nibName: "PhoneOtpLoginViewController", bundle: nil)
                        myViewController.phoneNumber = phoneNo
                        self.navigationController?.pushViewController(myViewController, animated: true)
                    } else {
                        
                        print("iOS is not 12.0, *")
                    }
                    
                }else{
                    
                    let alert = UIAlertController(title: "Alert", message: response?.value(forKey: "msg") as? String, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                
                let alert = UIAlertController(title: "Alert", message: response?.value(forKey: "msg") as? String, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}
