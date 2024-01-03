//
//  TabbarViewController.swift
//  TIK TIK
//
//  Created by Junaid Kamoka on 24/04/2019.
//  Copyright © 2019 Junaid Kamoka. All rights reserved.
//

import UIKit
import FirebaseDatabase
class TabbarViewController: UITabBarController,UITabBarControllerDelegate, UNUserNotificationCenterDelegate {
    
    var isSecondItem = false
    
    
    var myUser: [User]? {didSet {}}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        //tabBar.barTintColor = .clear
        
        self.tabBar.isTranslucent = true
        tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = UIColor.white
        handleSetUpViewControllers()
        setTabBarToTransparent()
        self.isSecondItem = false
        myUser = User.readUserFromArchive()
        
        //        print("myUser: ",myUser![0].username)
        //        print("myUser: ",myUser![0].verified)
        //        if myUser?[0].verified == "1" {
        //            self.addCenterButtonNew(withImage: UIImage(named: "camIcon")!, highlightImage: UIImage(named: "camIcon")!)
        //        }else {
        ////
        //        }
        OnlineUser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestChatImg(notification:)), name: .requestChatImg, object: nil)
        
        
    }
    
    
    @objc func requestChatImg(notification: Notification) {
        //    NotificationCenter.default.post(name: .getAudioPath, object: "myObject", userInfo: [:])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.selectedIndex = 3
        }
    }
    
    let tabBarSeperatorTopLine: CALayer = {
        let tabBarTopLine = CALayer()
        tabBarTopLine.backgroundColor = UIColor(named: "barColor")?.cgColor
        return tabBarTopLine
    }()
    
    
    
    func handleSetUpViewControllers() {
        
        tabBarSeperatorTopLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
        tabBar.layer.addSublayer(tabBarSeperatorTopLine)
        tabBar.clipsToBounds = true
        
        
    }
    
    func OnlineUser(){
        if UserDefaultsManager.shared.user_id == "" {
            return
        }
        self.myUser = User.readUserFromArchive()
        if (myUser?.count == 0) || self.myUser == nil{
            return
        }
        let reference = Database.database().reference()
        let OnlineUser = reference.child("OnlineUsers").child(UserDefaultsManager.shared.user_id)
        
        let ur = (self.myUser?[0].profile_pic)
        let userThumbImgPath = AppUtility?.detectURL(ipString: ur ?? "")
        
        var parameters = [String : Any]()
        parameters = [
            "userId": UserDefaultsManager.shared.user_id,
            "userName":self.myUser?[0].username ?? "",
            "userPic":userThumbImgPath ?? ""
        ]
        OnlineUser.setValue(parameters) { [self](error, ref) in
            if error != nil{
                print(error ?? "")
                return
            }
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        NotificationCenter.default.post(name: .stopSoundPlayNotify, object: "myObject", userInfo: [:])
        let index = -(tabBar.items?.firstIndex(of: item)?.distance(to: 0))!
        item.tag = index
        print("index",index)
        if index == 0 {
            self.isSecondItem = false
            setTabBarToTransparent()
        }else if index == 1 {
            self.isSecondItem = true
            tabBar.backgroundColor = .black
        }else {
            self.isSecondItem = true
            
            self.createLocalNotification(title: "helo", message: "pakistan")
        }
        
        
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
    
    func setTabBarToTransparent() {
        tabBar.isTranslucent = true
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.shadowImage = UIImage() //this removes the tabbar controller's top line
    }
    
    
    
    func removeTab(at index: Int) {
        guard let viewControllers = self.tabBarController?.viewControllers as? NSMutableArray else { return }
        viewControllers.removeObject(at: index)
        self.tabBarController?.viewControllers = (viewControllers as! [UIViewController])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(self.tabBar)
        //        MARK:- JK
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("test")
    }
    
    
    // Tabbar delegate Method
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController == tabBarController.viewControllers?[3] {
            
            let userID = UserDefaultsManager.shared.user_id
            
            if userID != "" {
                return true
            }else{
                if isSecondItem == true{
                    
                }else {
                    setTabBarToTransparent()
                }
                
                newLoginScreenAppear()
                return false
            }
            
        } else if (viewController == tabBarController.viewControllers?[4]) {
            hidesBottomBarWhenPushed = false
            
             let userID = UserDefaultsManager.shared.user_id
            
            if (userID != ""){
                return true
            }else{
                if isSecondItem == true{
                    
                }else {
                    setTabBarToTransparent()
                }
                newLoginScreenAppear()
                return false
            }
            
        }else if (viewController == tabBarController.viewControllers?[2]) {
            hidesBottomBarWhenPushed = false
            
            let userID = UserDefaultsManager.shared.user_id
            
            if (userID != ""){
                let vc1 = storyboard?.instantiateViewController(withIdentifier: "ContentCreatePopupviewcontroller") as! ContentCreatePopupviewcontroller
               
                let nav = UINavigationController(rootViewController: vc1)
                nav.navigationBar.isHidden =  true
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: true, completion: nil)
               
                //                setTabBarToTransparent()
                
                return false
            }else{
                if isSecondItem == true{
                    
                }else {
                    setTabBarToTransparent()
                }
                newLoginScreenAppear()
                return false
            }
            
            
        }else{
            hidesBottomBarWhenPushed = false
            return true
        }
    }
    
    
    
    
    
    func newLoginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        let navController = UINavigationController.init(rootViewController: myViewController)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overFullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
}

