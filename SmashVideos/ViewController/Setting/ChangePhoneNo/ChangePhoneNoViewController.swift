//
//  ChangePhoneNoViewController.swift
//  SmashVideos
//
//  Created by Mac on 03/11/2022.
//

import UIKit
import ActiveLabel
import PhoneNumberKit
class ChangePhoneNoViewController: UIViewController,UITextFieldDelegate {

    //MARK:- VARS
    var dialCode = "+92"
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!

    }()
    let phoneNumberKit = PhoneNumberKit()
    
    //MARK:- OUTLET

    
    @IBOutlet weak var tfPhoneNumber: PhoneNumberTextField!
    @IBOutlet weak var btnSendCode: UIButton!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var lblCode: UILabel!
    
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.countryDataNoti(_:)), name: NSNotification.Name(rawValue: "countryDataNoti"), object: nil)
        
        tfPhoneNumber.delegate = self
        tfPhoneNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tfPhoneNumber.isPartialFormatterEnabled = false
        
        
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
    
   
    
    //MARK:- BUTTON ACTION
    
    @IBAction func btnSendCodeAction(_ sender: Any) {
        
        if (AppUtility?.isEmpty(self.tfPhoneNumber.text))!{
            let alert = UIAlertController(title: "Alert", message: "Enter your valid Phone number", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        if self.tfPhoneNumber.isValidNumber {
            self.phoneNumberApi()
        }else{
            let alert = UIAlertController(title: "Alert", message: "Phone number is not valid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    @IBAction func btnCountryCode(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "countryCodeVC") as! countryCodeViewController
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func countryDataNoti(_ notification: NSNotification) {
        let newDialCode = notification.userInfo?["dial_code"] as! String
        let code = notification.userInfo?["code"] as! String
        print("code",code)
        self.tfPhoneNumber.placeholder = phoneNumberKit.metadata(for: code)?.mobile?.exampleNumber
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- API
    
    private func phoneNumberApi(){
        let phoneNo = self.dialCode+tfPhoneNumber.text!
        print("phoneNo: ",phoneNo)
        self.loader.isHidden = false
        ApiHandler.sharedInstance.changePhoneNumber(user_id: UserDefaultsManager.shared.user_id, phone: phoneNo) { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    
                    let myViewController = ChangePhoneNoOtpViewController(nibName: "ChangePhoneNoOtpViewController", bundle: nil)
                    myViewController.phone = phoneNo
                    
                    self.navigationController?.pushViewController(myViewController, animated: true)
                    
                }else{
                    
                    AppUtility?.displayAlert(title: "Alert", messageText: resp?.value(forKey: "msg")as!String, delegate: self)
                }
                
            }else{
                print(resp as Any)
            }
            
        }
        
    }
    
    
    

}
