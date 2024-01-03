//
//  DobViewController.swift
//  SmashVideos
//
//  Created by Mac on 16/10/2022.
//

import UIKit

class DobViewController: UIViewController {
    //MARK:- OUTLET
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- VARS
    var social_type = ""
    var social_id = ""
    var authtoken = ""
    
    var email = ""
    var phoneNoNew = ""
    var username = ""
    var dob = ""
    let minimum_age: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.backgroundColor = UIColor(named: "lightGrey")
        btnNext.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
        btnNext.isUserInteractionEnabled = false
        print("email",email)
        print("phoneNoNew",phoneNoNew)
        print("socail_type",social_type)
        dobSetup()
        
    }
    
    //MARK:- FUNCTION
    
    func dobSetup(){
        dobDatePicker.maximumDate = minimum_age
        dobDatePicker.datePickerMode = .date
        dobDatePicker.addTarget(self, action: #selector(dobDateChanged(_:)), for: .valueChanged)
    }
    
    
    //MARK:- BUTTON ACTION
    
    @objc func dobDateChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        print(dateFormatter.string(from: sender.date))
        dob = dateFormatter.string(from: sender.date)
        
        btnNext.backgroundColor = UIColor(named: "theme")
        btnNext.setTitleColor(.white, for: .normal)
        btnNext.isUserInteractionEnabled = true
        
        print("date: ",sender.date)
    }
    
    @IBAction func btnNext(_ sender: Any) {
        
        if social_type == "phone" {
            
            let vc = UsernameViewController(nibName: "UsernameViewController", bundle: nil)
            vc.dob = self.dob
            vc.phoneNoNew = self.phoneNoNew
            vc.email = self.email
            vc.password = ""
            vc.social_id = social_id
            vc.authtoken = authtoken
            vc.social_type = social_type
            
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            
            
            let vc = CreatePasswordViewController(nibName: "CreatePasswordViewController", bundle: nil)
            vc.dob = self.dob
            vc.phoneNoNew = self.phoneNoNew
            vc.email = self.email
            vc.password = ""
            vc.social_id = social_id
            vc.authtoken = authtoken
            vc.social_type = social_type
            
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
