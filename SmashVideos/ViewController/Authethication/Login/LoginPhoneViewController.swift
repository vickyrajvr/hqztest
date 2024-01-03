//
//  LoginPhoneViewController.swift
//
//
//  Created by Mac on 09/07/2021.
//

import UIKit
import PhoneNumberKit

class LoginPhoneViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- VARS
    
    var dialCode = "+92"
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    let phoneNumberKit = PhoneNumberKit()
    
    //MARK: Outlets
   
    
    @IBOutlet weak var tfPhoneNumber: PhoneNumberTextField!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var lblCode: UILabel!
    
    
    @IBOutlet weak var phoneSignUpView: UIView!
    
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfPhoneNumber.defaultRegion = "PK"
        if topTitle == "Login" {
            phoneSignUpView.isHidden = true
           
        }else {
            phoneSignUpView.isHidden = false
        }
        tfPhoneNumber.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.countryDataNoti(_:)), name: NSNotification.Name(rawValue: "countryDataNoti"), object: nil)
        
//        tfPhoneNumber.placeholder = "0311 4673838"
        NotificationCenter.default.post(name: Notification.Name("pauseSongNoti"), object: nil)
        
        tfPhoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tfPhoneNumber.isPartialFormatterEnabled = false
        
       
        
        self.tfPhoneNumber.withExamplePlaceholder = true
        self.tfPhoneNumber.withPrefix = false
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.count == 0 && string == "0" {
            
            return false
        }
      
        return true
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
                        self.navigationController?.isNavigationBarHidden = true
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
