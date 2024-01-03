//
//  CreatePasswordViewController.swift
//  SmashVideos
//
//  Created by Mac on 20/10/2022.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var social_type = ""
    var social_id = ""
    var authtoken = ""
    
    var email = ""
    var phoneNoNew = ""
    var username = ""
    var dob = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.backgroundColor = UIColor(named: "lightGrey")
        btnNext.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
        btnNext.isUserInteractionEnabled = false
        passTxtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = passTxtField.text?.count
        
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
    
    
    @IBAction func btnNextFunc(_ sender: Any) {
        
        password = passTxtField.text!
        
        print("email \(email) pass: \(password)")
        if validatePassword(password) == true{
            let vc = UsernameViewController(nibName: "UsernameViewController", bundle: nil)
            vc.password = password
            vc.dob = self.dob
            vc.phoneNoNew = self.phoneNoNew
            vc.email = self.email
            vc.social_id = social_id
            vc.authtoken = authtoken
            vc.social_type = social_type
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

}
