//
//  ResetPasswordViewController.swift
//  SmashVideos
//
//  Created by Mac on 01/11/2022.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    var password = ""
    var email = ""
    
    //MARK:- OUTLET
    
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnNext: UIButton!
   
    
    //MARK:- VARS
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.backgroundColor = UIColor(named: "lightGrey")
        btnNext.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
        btnNext.isUserInteractionEnabled = false
        tfPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    
    //MARK:- TEXTFIELD PLACEHOLDER
    
   
    
    //MARK:- BUTTON ACTION
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        password = tfPassword.text!
        
        if validatePassword(password) == true{
            self.changePasswordForgetApi()
        }
      
        
       
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:- TEXTFIELD DELEGATE
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = tfPassword.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 8{
            btnNext.backgroundColor = UIColor(named: "theme")
            btnNext.setTitleColor(.white, for: .normal)
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.backgroundColor = UIColor(named: "lightGrey")
            btnNext.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
            btnNext.isUserInteractionEnabled = false
        }
    }
    
    //    MARK:- password regex
    func validatePassword(_ password: String) -> Bool {
        //At least 8 characters
        if password.count < 8 {
            self.showToast(message: "Minimum 8 Character", font: .systemFont(ofSize: 12))
            return false
        }
        
        //At least one digit
        if password.range(of: #"\d+"#, options: .regularExpression) == nil {
            self.showToast(message: "Atleast One Digit", font: .systemFont(ofSize: 12))
            return false
        }
        
        //At least one letter
        if password.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
            
            self.showToast(message: "Alleast one Letter", font: .systemFont(ofSize: 12))
            return false
        }
        
        //No whitespace charcters
        if password.range(of: #"\s+"#, options: .regularExpression) != nil {
            self.showToast(message: "Remove Space", font: .systemFont(ofSize: 12))
            
            return false
        }
        
        return true
    }
    
    //MARK:- CHANGE PASSWORD FORGET API
    
    private func changePasswordForgetApi(){
        self.loader.isHidden = false
        
        ApiHandler.sharedInstance.changePasswordForgot(email: email, password: tfPassword.text!) { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController?.isNavigationBarHidden = true
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
                    
                }else{
                    
                    AppUtility?.displayAlert(title: "Alert", messageText: resp?.value(forKey: "msg")as!String, delegate: self)
                    
                }
                
            }else{
                print(resp as Any)
            }
        }
    }

}
