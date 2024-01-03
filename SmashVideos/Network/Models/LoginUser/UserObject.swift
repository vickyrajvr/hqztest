//
//  UserObject.swift
//
//  Infotex
//
//  Created by Mac on 01/09/2021.
//  Copyright © 2021 Mac. All rights reserved.


import Foundation
import UIKit

class UserObject{
    var myUser: [User]? {didSet {}}

    var mySwitchAccount: [switchAccount]? {didSet {}}

    static let shared = UserObject() //  singleton object
    
    
    func Objresponse(response:[String:Any],isLogin:Bool){
        let UserObj = response["User"] as! NSDictionary
        let UserSubscription = UserObj["subscription"] as? NSDictionary
        let user = User()
        user.id =  UserObj.value(forKey: "id") as! String
        user.first_name =  UserObj.value(forKey: "first_name") as! String
        user.last_name =  UserObj.value(forKey: "last_name") as! String
        user.email =  UserObj.value(forKey: "email") as! String
        user.phone =  UserObj.value(forKey: "phone") as? String
        user.profile_pic =  UserObj.value(forKey: "profile_pic") as? String
        user.role  =  UserObj.value(forKey: "role") as? String
//        userType   =  UserObj.value(forKey: "role") as? String ?? "user"
//        user.device_token =  UserObj.value(forKey: "device_token") as? String
//        user.token =  UserObj.value(forKey: "token") as? String
        user.active =  UserObj.value(forKey: "active") as! String
//        user.country_id =  UserObj.value(forKey: "country_id") as? String
        user.dob =  UserObj.value(forKey: "dob") as? String
        user.gender =  UserObj.value(forKey: "gender") as? String
        user.lat =  UserObj.value(forKey: "lat") as? String
        user.long =  UserObj.value(forKey: "long") as? String
        user.online =  UserObj.value(forKey: "online") as? String
        user.password =  UserObj.value(forKey: "password") as? String
//        user.auth_token =  UserObj.value(forKey: "auth_token") as? String
        user.created  = UserObj.value(forKey:  "created") as? String
        user.device  = UserObj.value(forKey:  "device") as? String
        user.ip  = UserObj.value(forKey:  "ip") as? String
        user.phone  = UserObj.value(forKey:  "phone") as? String
        user.social  = UserObj.value(forKey:  "social") as? String
        user.social_id  = UserObj.value(forKey:  "social_id") as? String
        user.username  = UserObj.value(forKey:  "username") as? String
        user.version  = UserObj.value(forKey:  "version") as? String
        user.wallet  = UserObj.value(forKey:  "wallet") as? String
//        user.approve_account_agency = UserObj.value(forKey:  "approve_account_agency") as? String
//        user.referral_code = UserObj.value(forKey:  "referral_code") as? String
        
//        user.bio =  UserObj.value(forKey: "bio") as? String
        user.website =  UserObj.value(forKey: "website") as? String
        user.verified  = UserObj.value(forKey:  "verified") as? String
        user.city  = UserObj.value(forKey:  "city") as? String
       
        
        AppUtility?.saveObject(obj: "\(UserObj.value(forKey:  "subscribe_package") as? String ?? "0")", forKey: "Package")
        self.myUser = [user]
        if User.saveUserToArchive(user: self.myUser!) {
            print("User Saved in Directory")
            if isLogin == true{
                var isFound =  false
                self.myUser = User.readUserFromArchive()
                self.mySwitchAccount = switchAccount.readswitchAccountFromArchive()
                
                if self.mySwitchAccount != nil && self.mySwitchAccount?.count != 0 {
                    print(self.mySwitchAccount?.count)
                    for var i in 0..<self.mySwitchAccount!.count{
                        var obj = self.mySwitchAccount![i]
                        print(obj.Id)
//                        print(self.myUser?[0].Id)
                        if  obj.Id == self.myUser?[0].id{
                            isFound = true
                            break
                        }
                    }
                    if isFound == false{
                       switchAccountObject.shared.Objresponse(response:   response)
                    }
                    
                }else{
                    switchAccountObject.shared.Objresponse(response:   response)

                }
            }
        }
    }
}

class User:NSObject, NSCoding {

     var startlat:Double!
       var startlong:Double!
       var endLat:Double!
       var endLong:Double!
       
       var id: String!
       var active: String!
       var city: String!
       var country: String!
       var created: String!
       var device: String!
       var dob: String!
       var email: String!
       var fb_id: String!
       var first_name: String!
       var gender: String!
       var last_name: String!
       var ip: String!
       var lat: String!
       var long: String!
       var online: String!
       var password: String!
       var phone: String!
       var profile_pic: String!
       var role: String!
       var social: String!
       var social_id: String!
       var username: String!
       var verified: String!
       var version: String!
       var website: String!
        var wallet: String!
     //  PushNotification
       
       var comments: String!
       var direct_messages: String!
       var likes: String!
       var mentions: String!
       var new_followers: String!
       var video_updates: String!
       
       
    //   PrivacySetting
       var direct_message: String!
       var duet: String!
       var liked_videos: String!
       var video_comment: String!
       var videos_download: String!
       
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder){

        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.active = aDecoder.decodeObject(forKey: "active") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.country = aDecoder.decodeObject(forKey: "country") as? String
        self.created = aDecoder.decodeObject(forKey: "created") as? String
        self.device = aDecoder.decodeObject(forKey: "device") as? String
        self.dob = aDecoder.decodeObject(forKey: "dob") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.fb_id = aDecoder.decodeObject(forKey: "fb_id") as? String
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        
        self.ip = aDecoder.decodeObject(forKey: "ip") as? String
        self.lat = aDecoder.decodeObject(forKey: "lat") as? String
        self.long = aDecoder.decodeObject(forKey: "long") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.online = aDecoder.decodeObject(forKey: "online") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
        self.profile_pic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        self.role = aDecoder.decodeObject(forKey: "role") as? String
        self.social = aDecoder.decodeObject(forKey: "social") as? String
        self.social_id = aDecoder.decodeObject(forKey: "social_id") as? String
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.verified = aDecoder.decodeObject(forKey: "verified") as? String
        self.version = aDecoder.decodeObject(forKey: "version") as? String
        self.website = aDecoder.decodeObject(forKey: "website") as? String
        self.wallet = aDecoder.decodeObject(forKey: "wallet") as? String

        
        self.comments = aDecoder.decodeObject(forKey: "comments") as? String
        self.direct_messages = aDecoder.decodeObject(forKey: "direct_messages") as? String
        self.likes = aDecoder.decodeObject(forKey: "likes") as? String
        self.mentions = aDecoder.decodeObject(forKey: "mentions") as? String
        self.new_followers = aDecoder.decodeObject(forKey: "new_followers") as? String
        self.video_updates = aDecoder.decodeObject(forKey: "video_updates") as? String


       self.direct_message = aDecoder.decodeObject(forKey: "direct_message") as? String
       self.duet = aDecoder.decodeObject(forKey: "duet") as? String
       self.liked_videos = aDecoder.decodeObject(forKey: "liked_videos") as? String
       self.video_comment = aDecoder.decodeObject(forKey: "video_comment") as? String
       self.videos_download = aDecoder.decodeObject(forKey: "videos_download") as? String

    }
    func encode(with acoder: NSCoder) {
        acoder.encode(self.startlat,forKey: "startlat")
        acoder.encode(self.startlong,forKey: "startlong")
        acoder.encode(self.endLat,forKey: "endLat")
        acoder.encode(self.endLong,forKey: "endLong")
        
        
        acoder.encode(self.id,forKey: "id")
        acoder.encode(self.active,forKey: "active")
        acoder.encode(self.city,forKey: "city")
        acoder.encode(self.country,forKey: "country")
        acoder.encode(self.created,forKey: "created")
        acoder.encode(self.device,forKey: "device")
        acoder.encode(self.dob,forKey: "dob")
        acoder.encode(self.email,forKey: "email")
        acoder.encode(self.fb_id,forKey: "fb_id")
        acoder.encode(self.first_name,forKey: "first_name")
        acoder.encode(self.gender,forKey: "gender")
        acoder.encode(self.last_name,forKey: "last_name")
        acoder.encode(self.ip,forKey: "ip")
        acoder.encode(self.lat,forKey: "lat")
        acoder.encode(self.long,forKey: "long")
        acoder.encode(self.online,forKey: "online")
        acoder.encode(self.password,forKey: "password")
        acoder.encode(self.phone,forKey: "phone")
        acoder.encode(self.profile_pic,forKey: "profile_pic")
        acoder.encode(self.role,forKey: "role")
        acoder.encode(self.social,forKey: "social")
        acoder.encode(self.social_id,forKey: "social_id")
        acoder.encode(self.username,forKey: "username")
        acoder.encode(self.verified,forKey: "verified")
        acoder.encode(self.version,forKey: "version")
        acoder.encode(self.website,forKey: "website")
        acoder.encode(self.wallet,forKey: "wallet")
        
        acoder.encode(self.comments,forKey: "comments")
        acoder.encode(self.likes,forKey: "likes")
        acoder.encode(self.direct_messages,forKey: "direct_messages")
        acoder.encode(self.mentions,forKey: "mentions")
        acoder.encode(self.new_followers,forKey: "new_followers")
        acoder.encode(self.video_updates,forKey: "video_updates")
        acoder.encode(self.direct_message,forKey: "direct_message")
        acoder.encode(self.video_comment,forKey: "video_comment")
        acoder.encode(self.videos_download,forKey: "videos_download")
    

    }
    //MARK: Archive Methods
        class func archiveFilePath() -> String {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsDirectory.appendingPathComponent("User.archive").path
        }
        
        class func readUserFromArchive() -> [User]? {
            return NSKeyedUnarchiver.unarchiveObject(withFile: archiveFilePath()) as? [User]
        }
        
        class func saveUserToArchive(user: [User]) -> Bool {
            return NSKeyedArchiver.archiveRootObject(user, toFile: archiveFilePath())
        }
        
    }

//class User: NSObject, NSCoding {
//
//    var Id:String?
//    var first_name :String?
//    var last_name :String?
//    var email :String?
//    var phone :String?
//    var image :String?
//    var smallImage :String?
//    var device_token :String?
//    var role : String?
//    var token : String?
//    var active :String?
//    var country_id:String?
//    var admin_per_order_commission:String?
//    var rider_fee_per_order:String?
//    var lat:String?
//    var long:String?
//    var online:String?
//    var password:String?
//
//    var auth_token:String?
//    var created:String?
//    var device:String?
//    var dob:String?
//    var gender:String?
//    var ip:String?
//    var social: String?
//    var social_id:String?
//    var username:String?
//    var version:String?
//    var wallet:String?
//    var approve_account_agency: String?
//    var referral_code: String?
//    var bio: String?
//    var website:String?
//    var white_diamonds: Int?
//    var red_diamonds:Int?
//    var blue_diamonds:Int?
//    var verified:String?
//    var city:String?
//    var country: String?
//    var city_Id:String?
//    var state_id:String?
//    var coins_from_subscription:String?
//    var coins_from_gift:String?
//    var paypal:String?
//    var referral_used_user_id: String?
//    var live_streaming:String?
//    var subscribe_package:String?
//    var subscribe_date:String?
//    var month:String?
//    var package:String?
//    var infotex_auth_token:String?
//    var booking_coins_per_hour:String?
//    var influencer_fee:String?
//    var transaction_id:String?
//    var subscriptionData:[String:Any]?
//
//    override init() {
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//
//        self.Id = aDecoder.decodeObject(forKey: "id") as? String
//        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String
//        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String
//        self.email = aDecoder.decodeObject(forKey: "email") as? String
//        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
//        self.image = aDecoder.decodeObject(forKey: "image") as? String
//        self.device_token = aDecoder.decodeObject(forKey: "device_token") as? String
//        self.role = aDecoder.decodeObject(forKey: "role") as? String
//        self.token = aDecoder.decodeObject(forKey: "token") as? String
//        self.active = aDecoder.decodeObject(forKey: "active") as? String
//        self.country_id = aDecoder.decodeObject(forKey: "country_id") as? String
//        self.admin_per_order_commission = aDecoder.decodeObject(forKey: "admin_per_order_commission") as? String
//        self.rider_fee_per_order = aDecoder.decodeObject(forKey: "rider_fee_per_order") as? String
//        self.lat = aDecoder.decodeObject(forKey: "lat") as? String
//        self.long = aDecoder.decodeObject(forKey: "long") as? String
//        self.online = aDecoder.decodeObject(forKey: "online") as? String
//        self.password = aDecoder.decodeObject(forKey: "password") as? String
//
//        self.auth_token = aDecoder.decodeObject(forKey: "auth_token") as? String
//        self.created = aDecoder.decodeObject(forKey: "created") as? String
//        self.device = aDecoder.decodeObject(forKey: "device") as? String
//        self.dob = aDecoder.decodeObject(forKey: "dob") as? String
//        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
//        self.ip = aDecoder.decodeObject(forKey: "ip") as? String
//        self.social = aDecoder.decodeObject(forKey: "social") as? String
//        self.social_id = aDecoder.decodeObject(forKey: "social_id") as? String
//        self.username = aDecoder.decodeObject(forKey: "username") as? String
//        self.version = aDecoder.decodeObject(forKey: "version") as? String
//        self.wallet = aDecoder.decodeObject(forKey: "wallet") as? String
//        self.approve_account_agency = aDecoder.decodeObject(forKey: "approve_account_agency") as? String
//        self.referral_code = aDecoder.decodeObject(forKey: "referral_code") as? String
//
//        self.bio = aDecoder.decodeObject(forKey: "bio") as? String
//        self.website = aDecoder.decodeObject(forKey: "website") as? String
//        self.white_diamonds = aDecoder.decodeObject(forKey: "white_diamonds") as? Int
//        self.red_diamonds = aDecoder.decodeObject(forKey: "red_diamonds") as? Int
//        self.blue_diamonds = aDecoder.decodeObject(forKey: "blue_diamonds") as? Int
//        self.verified = aDecoder.decodeObject(forKey: "verified") as? String
//        self.city = aDecoder.decodeObject(forKey: "city") as? String
//        self.city_Id = aDecoder.decodeObject(forKey: "country") as? String
//        self.state_id = aDecoder.decodeObject(forKey: "state_id") as? String
//        self.coins_from_subscription = aDecoder.decodeObject(forKey: "coins_from_subscription") as? String
//        self.coins_from_gift = aDecoder.decodeObject(forKey: "coins_from_gift") as? String
//        self.referral_used_user_id = aDecoder.decodeObject(forKey: "referral_used_user_id") as? String
//
//        self.live_streaming = aDecoder.decodeObject(forKey: "live_streaming") as? String
//        self.subscribe_package = aDecoder.decodeObject(forKey: "subscribe_package") as? String
//        self.subscribe_date = aDecoder.decodeObject(forKey: "subscribe_date") as? String
//        self.month = aDecoder.decodeObject(forKey: "month") as? String
//        self.package = aDecoder.decodeObject(forKey: "package") as? String
//        self.infotex_auth_token = aDecoder.decodeObject(forKey: "infotex_auth_token") as? String
//        self.booking_coins_per_hour = aDecoder.decodeObject(forKey: "booking_coins_per_hour") as? String
//        self.influencer_fee = aDecoder.decodeObject(forKey: "influencer_fee") as? String
//        self.transaction_id = aDecoder.decodeObject(forKey: "transaction_id") as? String
//        self.smallImage = aDecoder.decodeObject(forKey: "profile_pic_small") as? String
//        self.subscriptionData = aDecoder.decodeObject(forKey: "subscriptionData") as? [String:Any]
//    }
//
//    func encode(with aCoder: NSCoder) {
//
//        aCoder.encode(self.Id, forKey: "id")
//        aCoder.encode(self.first_name, forKey: "first_name")
//        aCoder.encode(self.last_name, forKey: "last_name")
//        aCoder.encode(self.email, forKey: "email")
//        aCoder.encode(self.phone, forKey: "phone")
//        aCoder.encode(self.image, forKey: "image")
//        aCoder.encode(self.device_token, forKey: "device_token")
//        aCoder.encode(self.role, forKey: "role")
//        aCoder.encode(self.token, forKey: "token")
//        aCoder.encode(self.active, forKey: "active")
//        aCoder.encode(self.country_id, forKey: "country_id")
//        aCoder.encode(self.admin_per_order_commission, forKey: "admin_per_order_commission")
//        aCoder.encode(self.rider_fee_per_order, forKey: "rider_fee_per_order")
//        aCoder.encode(self.lat, forKey: "lat")
//        aCoder.encode(self.long, forKey: "long")
//        aCoder.encode(self.online, forKey: "online")
//        aCoder.encode(self.password, forKey: "password")
//
//        aCoder.encode(self.auth_token, forKey: "auth_token")
//        aCoder.encode(self.created, forKey: "created")
//        aCoder.encode(self.device, forKey: "device")
//        aCoder.encode(self.dob, forKey: "dob")
//        aCoder.encode(self.gender, forKey: "gender")
//        aCoder.encode(self.ip, forKey: "ip")
//        aCoder.encode(self.social, forKey: "social")
//        aCoder.encode(self.social_id, forKey: "social_id")
//
//        aCoder.encode(self.username, forKey: "username")
//        aCoder.encode(self.version, forKey: "version")
//        aCoder.encode(self.wallet, forKey: "wallet")
//        aCoder.encode(self.approve_account_agency, forKey: "approve_account_agency")
//        aCoder.encode(self.referral_code, forKey: "referral_code")
//
//        aCoder.encode(self.bio, forKey: "bio")
//        aCoder.encode(self.website, forKey: "website")
//        aCoder.encode(self.white_diamonds, forKey: "white_diamonds")
//        aCoder.encode(self.red_diamonds, forKey: "red_diamonds")
//        aCoder.encode(self.blue_diamonds, forKey: "blue_diamonds")
//        aCoder.encode(self.verified, forKey: "verified")
//        aCoder.encode(self.city, forKey: "city")
//        aCoder.encode(self.city_Id, forKey: "city_Id")
//
//        aCoder.encode(self.state_id, forKey: "state_id")
//        aCoder.encode(self.coins_from_subscription, forKey: "coins_from_subscription")
//        aCoder.encode(self.coins_from_gift, forKey: "coins_from_gift")
//        aCoder.encode(self.referral_used_user_id, forKey: "referral_used_user_id")
//        aCoder.encode(self.referral_code, forKey: "referral_code")
//
//        aCoder.encode(self.live_streaming, forKey: "live_streaming")
//        aCoder.encode(self.subscribe_package, forKey: "subscribe_package")
//        aCoder.encode(self.subscribe_date, forKey: "subscribe_date")
//        aCoder.encode(self.month, forKey: "month")
//        aCoder.encode(self.package, forKey: "package")
//        aCoder.encode(self.infotex_auth_token, forKey: "infotex_auth_token")
//        aCoder.encode(self.booking_coins_per_hour, forKey: "booking_coins_per_hour")
//        aCoder.encode(self.influencer_fee, forKey: "influencer_fee")
//
//        aCoder.encode(self.transaction_id, forKey: "transaction_id")
//        aCoder.encode(self.smallImage, forKey: "smallImage")
//        aCoder.encode(self.subscriptionData, forKey: "subscriptionData")
//
//    }
//    //MARK: Archive Methods
//    class func archiveFilePath() -> String {
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        return documentsDirectory.appendingPathComponent("user.archive").path
//    }
//
//    class func readUserFromArchive() -> [User]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: archiveFilePath()) as? [User]
//    }
//
//    class func saveUserToArchive(user: [User]) -> Bool {
//        return NSKeyedArchiver.archiveRootObject(user, toFile: archiveFilePath())
//    }
//}

