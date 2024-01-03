//
//  ForgetPasswordViewController.swift
//  SmashVideos
//
//  Created by Mac on 01/11/2022.
//

import UIKit

class ForgetPasswordViewController: UIViewController,UITextFieldDelegate {
    var email  = ""
    
    //MARK:- OUTLET
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnReset: UIButton!
   
    
    //MARK:- VARS
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        btnReset.backgroundColor = UIColor(named: "lightGrey")
        btnReset.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
        btnReset.isUserInteractionEnabled = false
        
        tfEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
   
    //MARK:- BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        if !AppUtility!.isEmail(self.tfEmail.text!){
            let alert = UIAlertController(title: "Alert", message: "Your email is not valid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.email = tfEmail.text ?? ""
        forgetPasswordApi()
        
    }
    
    
    //MARK:- TEXTFIELD DELEGATE
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = textField.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 3{
            btnReset.backgroundColor = UIColor(named: "theme")!
            btnReset.setTitleColor(UIColor(named: "white"), for: .normal)
            btnReset.isUserInteractionEnabled = true
        }else{
            btnReset.backgroundColor = UIColor(named: "lightGrey")
            btnReset.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
            btnReset.isUserInteractionEnabled = false
        }
    }
  
    
    //MARK:- FORGET PASSWORD API
    
    private func forgetPasswordApi(){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.forgotPassword(email: tfEmail.text!) { (isSuccess, resp) in
            self.loader.isHidden = true
            if isSuccess {
                if resp?.value(forKey: "code") as! NSNumber == 200{
                    
                    let myViewController = ForgetOtpViewController(nibName: "ForgetOtpViewController", bundle: nil)
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
