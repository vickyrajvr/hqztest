//
//  EmailSignUpViewController.swift
//  MusicTok
//
//  Created by Mac on 15/10/2022.
//

import UIKit
import ActiveLabel
class EmailSignUpViewController: UIViewController {
    
    //MARK:- OUTLET
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblLogin: ActiveLabel!
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activeSetupLabel()
        
        emailTxtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK:- BUTTON ACTION
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = textField.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 3{
            btnNext.backgroundColor = UIColor(named: "theme")!
            btnNext.setTitleColor(UIColor(named: "white"), for: .normal)
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.backgroundColor = UIColor(named: "lightGrey")
            btnNext.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
            btnNext.isUserInteractionEnabled = false
        }
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
            myViewController.myUrl = "https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
            myViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(myViewController, animated: true)
        }
        lblLogin.handleCustomTap(for: customType1) { element in
            print("Privacy Policy")
            let myViewController =  WebViewController(nibName: "WebViewController", bundle: nil)
            myViewController.linkTitle = "Privacy Policy"
            myViewController.myUrl = "https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
            myViewController.modalPresentationStyle = .fullScreen
            
            self.navigationController?.pushViewController(myViewController, animated: true)
           
        }
        
    }
    
    @IBAction func btnNextFunc(_ sender: Any) {
        
        if !AppUtility!.isEmail(self.emailTxtField.text!){
            let alert = UIAlertController(title: "Alert", message: "Your email is not valid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let myViewController = DobViewController(nibName: "DobViewController", bundle: nil)
        myViewController.email = emailTxtField.text!
        myViewController.social_type = "email"
        self.navigationController?.pushViewController(myViewController, animated: true)
        
        
    }

}
