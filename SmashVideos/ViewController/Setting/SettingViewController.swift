//
//  SettingViewController.swift
//  SmashVideos
//
//  Created by Mac on 26/10/2022.
//

import UIKit
import GSPlayer
class SettingViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //MARK:- VARS
    var delegate : setUserDefalault?
    var full_name = ""
    var user_name = ""
    var image_url = ""
    var string = ""
    //    let randomInt = Int.random(in: 1..<150)
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
        
        
    }()
    let headerArr = ["ACCOUNT","CONTENT & ACTIVITY","CACHE DATA","ABOUT","LOGIN"]
    
    let accountArr = [["name":"Manage Account","image":"account"],
                      ["name":"Subscription","image":"account"],
                      ["name":"Privacy","image":"privacy"],
                      ["name":"Request Verification","image":"verification"],
                      ["name":"Creator Tools","image":"Creator-tools"],
                      ["name":"Balance","image":"balance"],
                      ["name":"Favorites","image":"he"],
                      ["name":"Block User","image":"setting_14"],
                      ["name":"Qr Code","image":"qrcode"],
                      ["name":"Draft Videos","image":"draftEMail"],
                      ["name":"Share profile","image":"share1"],
                      ["name":"Referral code","image":"referral"]]
    //                      ["name":"Draft","image":"email"],]
    
    let contentArr = [["name":"Push Notification","image":"notifications"],
                      ["name":"Language","image":"lang"]]
    //                      ["name":"Dark Mode","image":"mode"]]
    
    let cacheArr = [["name":"Clear Cache","image":"cache"]]
    
    let aboutArr = [["name":"Terms of Service","image":"terms"],
                    ["name":"Privacy Policy","image":"policy"]]
    
    let loginArr = [/*["name":"Switch account","image":"switch"],*/
        ["name":"Log out","image":"logout"]]
    
    //MARK:- OUTLET
    
    @IBOutlet weak var settingTableView: UITableView!
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
        
        let bytes = VideoCacheManager.calculateCachedSize() // assume this is the number of bytes
        let megabytes = Double(bytes) / 1000000
        print("\(megabytes) MB")
        string = String(format: "%.2f", megabytes)
        print(string)
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
        
    }
    
    
    
    
    //MARK:-BUTTON ACTION
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:-FUNCTION
    
    
    
    func logoutUserApi(){
        
        self.loader.isHidden = false
        ApiHandler.sharedInstance.logout(user_id: UserDefaultsManager.shared.user_id) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    print(response?.value(forKey: "msg") as Any)
                    isRun = true
                    UserDefaultsManager.shared.user_id = ""
                    
                }else{
                    
                }
            }else{
                self.loader.isHidden = true
                
            }
        }
    }
    //MARK:-TEXTFIELD DELEGATE
    //MARK:-SCROLL VIEW
    
    
    
}
//MARK:- EXTENSION TABLE VIEW

extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        headerArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return accountArr.count
        }else if section == 1 {
            return contentArr.count
        }else if section == 2 {
            return cacheArr.count
        }else if section == 3 {
            return aboutArr.count
        }else {
            return loginArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath)as! SettingTableViewCell
        
        if indexPath.section == 0 {
            cell.lblSetting.text = accountArr[indexPath.row]["name"]!
            cell.imgSetting.image = UIImage(named: accountArr[indexPath.row]["image"]!)
            
        }else if indexPath.section == 1 {
            cell.lblSetting.text = contentArr[indexPath.row]["name"]!
            cell.imgSetting.image = UIImage(named: contentArr[indexPath.row]["image"]!)
            
            if indexPath.row == 1 {
                cell.lblCache.isHidden = false
                cell.lblCache.text = "English"
                cell.imgArrow.isHidden = true
            }
            
        }else if indexPath.section == 2 {
            
            cell.lblSetting.text = cacheArr[indexPath.row]["name"]!
            cell.imgSetting.image = UIImage(named: cacheArr[indexPath.row]["image"]!)
            cell.lblCache.isHidden = false
            cell.lblCache.text = "\(string) MB"
            cell.imgArrow.isHidden = true
        }else if indexPath.section == 3 {
            cell.lblCache.isHidden = true
            cell.imgArrow.isHidden = false
            cell.lblSetting.text = aboutArr[indexPath.row]["name"]!
            cell.imgSetting.image = UIImage(named: aboutArr[indexPath.row]["image"]!)
        }else {
            cell.lblCache.isHidden = true
            cell.imgArrow.isHidden = false
            cell.lblSetting.text = loginArr[indexPath.row]["name"]!
            cell.imgSetting.image = UIImage(named: loginArr[indexPath.row]["image"]!)
        }
        cell.imgSetting.tintColor = .black
        
        
        return cell
    }
    func createLocalNotification(title: String, message : String) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge,.sound,.alert]) { granted, error in
            if error == nil {
                print("User permission is granted : \(granted)")
            }
        }
        //        Step-2 Create the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        //        Step-3 Create the notification trigger
        let date = Date().addingTimeInterval(1)
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        //       Step-4 Create a request
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        //      Step-5 Register with Notification Center
        center.add(request) { error in
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = settingTableView.cellForRow(at: indexPath) as! SettingTableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
            
                
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManageAccountViewController") as! ManageAccountViewController
                self.navigationController?.pushViewController(viewController, animated: true)
              
                
                
            }else if indexPath.row == 1 {
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoEditorViewController") as! VideoEditorViewController
                self.navigationController?.pushViewController(viewController, animated: true)
//                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "privacySettingViewController") as! privacySettingViewController
//                self.navigationController?.pushViewController(viewController, animated: true)
            }else if indexPath.row == 5 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "favMainVC")as! favMainViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2 {
                
                let myViewController = RequestVerificationViewController(nibName: "RequestVerificationViewController", bundle: nil)
                
                myViewController.name = self.full_name
                myViewController.user = self.user_name
                
                self.navigationController?.pushViewController(myViewController, animated: true)
                
            }else if indexPath.row == 4 {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyWalletViewController")as! MyWalletViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 6 {
                let myViewController = BlockUserViewController(nibName: "BlockUserViewController", bundle: nil)
                self.navigationController?.pushViewController(myViewController, animated: true)
            }else if indexPath.row == 3 {
                
                let myViewController = CreatorToolsViewController(nibName: "CreatorToolsViewController", bundle: nil)
                self.navigationController?.pushViewController(myViewController, animated: true)
                
            }else {
                let myViewController = QRCodeViewController(nibName: "QRCodeViewController", bundle: nil)
                myViewController.full_name = self.full_name
                myViewController.image_url = self.image_url
                myViewController.user_name = self.user_name
                self.navigationController?.pushViewController(myViewController, animated: true)
            }
        }else if indexPath.section == 1  {
            if indexPath.row == 0 {
                let myViewController = PushNotificationViewController(nibName: "PushNotificationViewController", bundle: nil)
                self.navigationController?.pushViewController(myViewController, animated: true)
            }
        }else if indexPath.section == 2 {
            self.loader.isHidden = false
            
            
            
            do {
                try VideoCacheManager.cleanAllCache()
                let bytes = VideoCacheManager.calculateCachedSize() // assume this is the number of bytes
                let megabytes = Double(bytes) / 1000000
                print("\(megabytes) MB")
                string = String(format: "%.0f", megabytes)
                print(string)
            } catch {
                print("Error cleaning cache: \(error)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loader.isHidden = true
                
                cell.lblCache.text = "\(self.string) MB"
            }
            
        }else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                
                let myViewController =  WebViewController(nibName: "WebViewController", bundle: nil)
                myViewController.linkTitle = "Terms of Service"
                myViewController.myUrl = "https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
                myViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(myViewController, animated: true)
                
            }else {
                
                let myViewController =  WebViewController(nibName: "WebViewController", bundle: nil)
                myViewController.linkTitle = "Privacy Policy"
                myViewController.myUrl = "https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
                myViewController.modalPresentationStyle = .fullScreen
                
                self.navigationController?.pushViewController(myViewController, animated: true)
                
            }
            
        }else {
            
            
            let alertController = UIAlertController(title: NSLocalizedString("LOGOUT", comment: ""), message: "Would you like to LOGOUT?", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                self.tabBarController?.selectedIndex = 0
                //
                //                self.tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                //                self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
                var myUser: [User]? {didSet {}}
                myUser = User.readUserFromArchive()
                myUser?.removeAll()
                
                //
                //                 UserDefaultsManager.shared.user_id = ""
                //                 self.delegate?.userLogin(isLogin: false)
                
                
                //
                self.logoutUserApi()
                self.navigationController?.popViewController(animated: true)
                
            }
            alertController.addAction(OKAction)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // header view
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .white
        
        
        // label view
        
        let label = UILabel()
        //        label.frame = CGRect.init(x: 35, y: headerView.frame.midY, width: headerView.frame.width-10, height: headerView.frame.height)
        
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor(named: "darkGrey")
        } else {
            label.textColor = UIColor(named: "darkGrey")
        }
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.text = headerArr[section]
        
        
        
        return headerView
        
        
        
        
    }
}
