//
//  ForgetOtpViewController.swift
//  SmashVideos
//
//  Created by Mac on 01/11/2022.
//

import UIKit
import DPOTPView
class ForgetOtpViewController: UIViewController {
    
    var email = ""
    
    //MARK:- OUTLET
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewOtp: DPOTPView!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    
    //MARK:- VARS
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    var counter = 60
    var timer = Timer()

    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        lblEmail.text = "Your code was sent to \(email)"
        viewOtp.dpOTPViewDelegate = self
        btnResend.isHidden = true
        timerSetup()
       
    }
    
    //MARK:- TIMER
    
    private func timerSetup(){
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
       
        if counter !=  0 {
            lblTimer.text = "Resend Code 00:\(counter)"
            counter -= 1
        }else {
           
            self.counter = 60
            timer.invalidate()
            lblTimer.isHidden = true
            btnResend.isHidden = false
        }
    }
    
    
    
    //MARK:- BUTTON ACTION
    
    @IBAction func resendCodeButtonPressed(_ sender: UIButton) {
        self.forgetPasswordApi()
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- VERIFY CHNAGE PASSWORD API
    
    private func verifyChangePasswordApi(){
        self.loader.isHidden = false
       
        ApiHandler.sharedInstance.verifyforgotPasswordCode(email: email, code: viewOtp.text!) { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    
                    let myViewController = ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle: nil)
                    
                    myViewController.email = self.email
                    self.navigationController?.pushViewController(myViewController, animated: true)
               
                }else{
                    
                    AppUtility?.displayAlert(title: "Alert", messageText: resp?.value(forKey: "msg")as!String, delegate: self)
                    
                }
                
            }else{
                print(resp as Any)
            }
        }
        
    }
    
    //MARK:- FORGET PASSWORD API
    
    private func forgetPasswordApi(){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.forgotPassword(email: email) { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    self.timerSetup()
                    self.viewOtp.text = ""
                    self.btnResend.isHidden = true
                    self.lblTimer.isHidden = false
                  
                   
                    
                }else{
                    
                    AppUtility?.displayAlert(title: "Alert", messageText: resp?.value(forKey: "msg")as!String, delegate: self)
                    
                }
                
            }else{
                print(resp as Any)
            }
        }
        
    }

}


//MARK:- Textfield Delegate

extension ForgetOtpViewController: DPOTPViewDelegate {
    
    func dpOTPViewAddText(_ text: String, at position: Int) {
       
       
        if position <= 3 && text.count == 4{
           
            self.verifyChangePasswordApi()
            viewOtp.dismissOnLastEntry = true
        }else {
            
        }
        
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        
        if position <= 3 && text.count == 4{
           
            self.verifyChangePasswordApi()
            viewOtp.dismissOnLastEntry = true
        }else {
            
        }
        
        
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        
        
        
    }
    
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
        
    }
}
