//
//  UpdateEmailViewController.swift
//  SmashVideos
//
//  Created by Mac on 02/11/2022.
//

import UIKit

class UpdateEmailViewController: UIViewController,UITextFieldDelegate {
    var email = ""

    //MARK:- OUTLET
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- VARS
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSetup()
        btnNext.backgroundColor = UIColor(named: "lightGrey")
        btnNext.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
    }
    
    //MARK:- TEXTFIELD PLACEHOLDER
    
    private func textFieldSetup(){
        tfEmail.delegate = self
        
    }
    
    //MARK:- BUTTON ACTION
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if !AppUtility!.isEmail(tfEmail.text!){
            AppUtility?.displayAlert(title: "Alert", messageText: "Enter your valid email", delegate: self)
            return
        }
        email = tfEmail.text!
        self.changeEmailApi()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TEXTFIELD DELEGATE
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if !AppUtility!.isEmail(tfEmail.text!){
            btnNext.backgroundColor = UIColor(named: "lightGrey")
            btnNext.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
            return
        }
        btnNext.backgroundColor = UIColor(named: "theme")
        btnNext.setTitleColor(.white, for: .normal)
      
    }
    
    //MARK:- API
    
    private func changeEmailApi(){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.changeEmailAddress(user_id: UserDefaultsManager.shared.user_id, email: tfEmail.text!, verify: "0") { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    
                    let myViewController = UpdateEmailOtpViewController(nibName: "UpdateEmailOtpViewController", bundle: nil)
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

}
