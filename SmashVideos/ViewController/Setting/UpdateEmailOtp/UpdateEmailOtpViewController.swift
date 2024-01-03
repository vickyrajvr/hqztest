//
//  UpdateEmailOtpViewController.swift
//  SmashVideos
//
//  Created by Mac on 02/11/2022.
//

import UIKit
import DPOTPView
class UpdateEmailOtpViewController: UIViewController {

    
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var lblResendCode: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    
    //MARK:- VARS
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!

    }()
    var email = ""
    var counter = 60
    var timer = Timer()
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
       
        lblCode.text = "Your code was sent to \(email)"
        otpView.dpOTPViewDelegate = self
        btnResendCode.isHidden = true
        timerSetup()
        
    }
    //MARK:- TIMER
    
    private func timerSetup(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        
        if counter !=  0 {
            lblResendCode.text = "Resend Code 00:\(counter)"
            counter -= 1
        }else {
            
            self.counter = 60
            timer.invalidate()
            lblResendCode.isHidden = true
            btnResendCode.isHidden = false
        }
    }
    
    
    //MARK:- BUTTON ACTION
  
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        self.changeEmailApi()
        
    }
    
    //MARK:- API
    
    private func verifyChangeEmailApi(){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.verifyChangeEmailCode(user_id: UserDefaultsManager.shared.user_id, new_email: email, code: otpView.text!) { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    
                    let userObj = resp!["msg"] as! [String:Any]
                    UserObject.shared.Objresponse(response: userObj,isLogin: false)
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ManageAccountViewController.self) {
                            _ =  self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    
                    
                }else{
                    
                    AppUtility?.displayAlert(title: "Alert", messageText: resp?.value(forKey: "msg")as!String, delegate: self)
                }
                
            }else{
                print(resp as Any)
            }
        }
        
        
    }
    
    
    private func changeEmailApi(){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.changeEmailAddress(user_id: UserDefaultsManager.shared.user_id, email: email, verify: "0") { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    
                    self.timerSetup()
                    self.otpView.text! = ""
                    self.btnResendCode.isHidden = true
                    self.lblResendCode.isHidden = false
                    
                    
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

extension UpdateEmailOtpViewController: DPOTPViewDelegate {
    
    func dpOTPViewAddText(_ text: String, at position: Int) {
        
        
        
        if position <= 3 && text.count == 4{
            
            verifyChangeEmailApi()
            otpView.dismissOnLastEntry = true
            
        }else {
           
            otpView.dismissOnLastEntry = true
            
        }
        
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        
        if position <= 3 && text.count == 4{
            
            verifyChangeEmailApi()
            otpView.dismissOnLastEntry = true
            
        }else {
            
            otpView.dismissOnLastEntry = true
            
        }
        
        
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        
        
        
    }
    
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
        
    }
    
    
}
