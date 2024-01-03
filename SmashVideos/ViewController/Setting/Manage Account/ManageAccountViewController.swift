//
//  ManageAccountViewController.swift
//  MusicTok
//
//  Created by Mac on 14/07/2021.
//  Copyright © 2021 Mac. All rights reserved.
//

import UIKit

class ManageAccountViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    //MARK:- VARS
    
    var arrAccount = [["account":"Email"],
                      ["account":"Phone Number"]]
    
    
    
    var userData = [userMVC]()
    
    var myUser: [User]? {didSet {}}
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tbl.sectionHeaderTopPadding = 5
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.myUser = User.readUserFromArchive()
        tbl.reloadData()
    }
    
    
    //MARK:- BUTTON ACTION
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: UIButton){
        let myViewController = DeleteAccountViewController(nibName: "DeleteAccountViewController", bundle: nil)
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    
    //MARK:- UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrAccount.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageAccountTableViewCell", for: indexPath) as! ManageAccountTableViewCell
       
        if indexPath.section == 0 {
            cell.lblAccount.text = arrAccount[indexPath.row]["account"]
           
            if indexPath.row == 0 {
               cell.lblData.text = (self.myUser?[0].email)!
            }else if indexPath.row == 1 {
                cell.lblData.text = (self.myUser?[0].phone)!
            }else {
                cell.lblData.isHidden = true
            }
          
        }else {
            
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                let myViewController = UpdateEmailViewController(nibName: "UpdateEmailViewController", bundle: nil)
                self.navigationController?.pushViewController(myViewController, animated: true)
                
            }else if indexPath.row == 1 {
                
                let myViewController = ChangePhoneNoViewController(nibName: "ChangePhoneNoViewController", bundle: nil)
                
                
                self.navigationController?.pushViewController(myViewController, animated: true)
                
              
            }else {
                
//                let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController")as! ChangePasswordViewController
//                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
        if #available(iOS 13.0, *) {
            headerView.backgroundColor = .white
        } else {
            headerView.backgroundColor =  .white
        }
        
//
//        let view1 = UIView()
//
//        if #available(iOS 13.0, *) {
//            view1.backgroundColor = .white
//        } else {
//            view1.backgroundColor = .white
//        }
        
        let label = UILabel()
//        label.frame = CGRect.init(x: 20, y: 20, width: headerView.frame.width-10, height: headerView.frame.height)
//
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        if #available(iOS 13.0, *) {
            label.textColor = .darkGray
        } else {
            label.textColor = .darkGray
        }
//        view1.layer.cornerRadius = 5.0
//        headerView.addSubview(view1)
        headerView.addSubview(label)
      
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
       
        
        if section == 0 {
            label.text = "Account Information"
           
            
        }else{
            label.text = "Account Control"
           
        }
        return headerView
    }
    
    
    
}
