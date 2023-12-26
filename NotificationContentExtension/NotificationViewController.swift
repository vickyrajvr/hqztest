//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by Zubair Ahmed on 06/06/2023.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let content = notification.request.content
        
        print(content.userInfo)
        // fetch video url to setup player
//        if let aps = content.userInfo["aps"] as? [String: AnyHashable]
//           let videoUrlString = aps["video_url"] as? String {
//            if let url = URL(string: videoUrlString) {
////                setupVideoPlayer(url: url)
//            }
//        }
        
        
        self.label?.text = notification.request.content.body
    }

}
