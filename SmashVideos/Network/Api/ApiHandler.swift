//
//  ApiHandler.swift
//  Tik Tik
//
//  Created by Junaid Kamoka on 2020/10/3.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

var BASE_URL =  "http://app.hqz.gg/mobileapp_api/"

let API_KEY = "156c4675-9608-4591-1111-00000"
var SHARE_BASE_URL = "http://app.hqz.gg/"
var SHARE_PROFILE_URL = "http://app.hqz.gg/"

let API_BASE_URL = BASE_URL+"api/"
private let SharedInstance = ApiHandler()

enum Endpoint : String {
    case liveStream = "liveStream"
    case registerUser            = "registerUser" // verified
    case login                   = "login" // verified
    case verifyPhoneNo           = "verifyPhoneNo" // verified
    case checkUsername           = "checkUsername" // verified
    case addDeviceData           = "addDeviceData"  // 1 verified
    case forgotPassword          = "forgotPassword" // 1 verified
    
    case showProfileVisitors     = "showProfileVisitors"
    
    case showAddSettings = "showAddSettings"
    case registerDevice          = "registerDevice" // verified
    case showDeviceDetail        = "showDeviceDetail"
    case postVideo               = "postVideo"
    case showVideoDetailAd       = "showVideoDetailAd" // verified
    case showRelatedVideos       = "showRelatedVideos" // verified
    case showFollowingVideos     = "showFollowingVideos"
    case showVideosAgainstUserID = "showVideosAgainstUserID" // verified
    case showSuggestedUsers    = "showSuggestedUsers" // verified
    case showUserDetail          = "showUserDetail" // verified
    case showBlockedUsers          = "showBlockedUsers" // verified
    case showUserSounds          = "showUserSounds" // verified
    case likeVideo               = "likeVideo" // verified
    case watchVideo              = "watchVideo" // verified
    case repostVideo              = "repostVideo" // verified
    
    
    case showSounds              = "showSounds" // Verified
    case showSoundsAgainstSection   = "showSoundsAgainstSection"
    case addSoundFavourite       = "addSoundFavourite" // verified
    case showFavouriteSounds     = "showFavouriteSounds"
    case showUserLikedVideos     = "showUserLikedVideos" // Verified
    case followUser              = "followUser" // Verified
    case followerNotification    = "followerNotification" // Verified
    case showDiscoverySections   = "showDiscoverySections" // Verified
    case showVideoComments       = "showVideoComments" // Verified
    case postCommentOnVideo      = "postCommentOnVideo" // Verified
    case editProfile             = "editProfile"
    case showFollowers           = "showFollowers" // Verified
    case showFollowing           = "showFollowing" // Verified
    case showVideosAgainstHashtag = "showVideosAgainstHashtag" // Verified
    case sendMessageNotification = "sendMessageNotification"
    case addUserImage            = "addUserImage"
    case deleteVideo             = "deleteVideo"
    case search                  = "search" // Verified
    case showVideoDetail         = "showVideoDetail" // Verified
    case showAllNotifications    = "showAllNotifications" // Verified
    case userVerificationRequest = "userVerificationRequest" // Verified
    case downloadVideo           = "downloadVideo" // Verified
    case deleteWaterMarkVideo    = "deleteWaterMarkVideo" // Verified
    case showAppSlider           = "showAppSlider" // Verified
    case logout                  = "logout"
    case showVideosAgainstSound  = "showVideosAgainstSound" // verified
    case showReportReasons       = "showReportReasons" // verified
    case DeleteAccount            = "deleteUserAccount" // verified
    case NotInterestedVideo      = "NotInterestedVideo"
    case addVideoFavourite       = "addVideoFavourite"
    case showFavouriteVideos     = "showFavouriteVideos"
    case updatePushNotificationSettings  = "updatePushNotificationSettings" // verified
    case addHashtagFavourite     =  "addHashtagFavourite" // Verified
    case showFavouriteHashtags   = "showFavouriteHashtags"
    case reportUser              = "reportUser"
    case addPrivacySetting       = "addPrivacySetting"
    case reportVideo             = "reportVideo"
    case blockUser               = "blockUser" // Verified
    case verifyforgotPasswordCode = "verifyforgotPasswordCode"
    
    
    case purchaseCoin             = "purchaseCoin"
    case coinWorth                = "showCoinWorth"
    case coinWithDrawRequest      = "withdrawRequest"
    case addPayOut                = "addPayout"
    case showGifts                = "showGifts"
    case sendGift                 = "sendGift"
    case changePasswordForgot = "changePasswordForgot"
        // case showSuggestedUsers       = "showSuggestedUsers"
    case changeEmailAddress       = "changeEmailAddress"
    
    //MARK:- Comments
    case verifyChangeEmailCode = "verifyChangeEmailCode"
    
    case likeComment             = "likeComment"
    case likeCommentReply        = "likeCommentReply"
  
    case postCommentReply        = "postCommentReply"
    
    case changePhoneNo = "changePhoneNo"
  
    
    // Spaces Apis
    case showRooms = "showRooms"
    case joinRoom = "joinRoom"
    case assignModerator = "assignModerator"
    case leaveRoom = "leaveRoom"
    case deleteRoom = "deleteRoom"
    case showRoomDetail = "showRoomDetail"
    case showUserJoinedRooms = "showUserJoinedRooms"
    case addRoom = "addRoom"
    
    // Ads
    case addPromotion = "addPromotion"
    
}
class ApiHandler:NSObject{
    var baseApiPath:String!
    //    var API_KEY = API_KEY
    class var sharedInstance : ApiHandler {
        return SharedInstance
    }
    
    override init() {
        self.baseApiPath = API_BASE_URL
    }
    
    
    
    //MARK:- Verify Phone number
    func verifyPhoneNo1(phone:String,verify:String,code:String,IsVerfied:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        if IsVerfied == "0"{
            parameters = [
                
                "phone" : phone,
                "verify": verify
                
                
            ]
        }else{
            parameters = [
                
                "phone" : phone,
                "verify": verify,
                "code"  : code
                
                
            ]
        }
        
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.verifyPhoneNo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:showProfileVisitors
    func showProfileVisitors(user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"         : user_id,
            "starting_point"  : starting_point
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showProfileVisitors.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict as Any)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:showProfileVisitors
    func showAddSettings(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"         : user_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showAddSettings.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict as Any)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:showProfileVisitors
    func addPromotion(isWebsite:Bool,user_id:String,video_id:String,destination:String,coin:String,audience_id:String,start_datetime:String,total_reach:String,end_datetime:String,action_button:String,website_url:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        
        
        var parameters = [String : String]()
        
        if isWebsite == true {
            
            parameters = [
            
                "user_id"        : user_id,
                "video_id"       : video_id,
                "destination"    : destination,
                "coin"           : coin,
                "audience_id"    : audience_id,
                "start_datetime" : start_datetime,
                "end_datetime"   : end_datetime,
                "total_reach"    : total_reach,
                "action_button"  : action_button,
                "website_url"    : website_url
                
            
            ]
            
            
        }else{
            
            parameters = [
            
                "user_id"        : user_id,
                "video_id"       : video_id,
                "destination"    : destination,
                "coin"           : coin,
                "audience_id"    : audience_id,
                "start_datetime" : start_datetime,
                "end_datetime"   : end_datetime,
                "total_reach"    : total_reach,
                "action_button"  : action_button,
                "website_url"    : website_url
                
                
            
            ]
            
        }
        
        
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addPromotion.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict as Any)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:ChangePhonenumber
    func changePhoneNumber(user_id:String,phone:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"         : user_id,
            "phone"           : phone,
            "verify"          : "0"
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.changePhoneNo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict as Any)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //    MARK:- verifyChangeEmailCode
    
    func verifyChangeEmailCode(user_id:String,new_email:String,code:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            
            "user_id"         : user_id,
            "new_email"         : new_email,
            "code"             : code
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.verifyChangeEmailCode.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //    MARK:- changeEmailAddress
    
    func changeEmailAddress(user_id:String,email:String,verify:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            
            "user_id"         : user_id,
            "email"         : email,
            "verify"             : verify
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.changeEmailAddress.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                      
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //    MARK:- changePasswordForgot
    
    func changePasswordForgot(email:String,password:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            
            "email"         : email,
            "password"         : password
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.changePasswordForgot.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
          
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                    
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                       
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:- Login
    func login(email:String,password:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY,
            "User_Id":"",
            "Auth_token" : ""
        ]
        var parameters = [String : String]()
        parameters = [
            
            "email"   : email,
            "password": password,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.login.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- Verify Phone number
    func verifyPhoneNo(phone:String,verify:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            
            "phone" : phone,
            "verify": verify,
            // "code"  : code,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.verifyPhoneNo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //OTP VERIFY
    func verifyOTP(phone:String,verify:String,code:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            
            "phone" : phone,
            "verify": verify,
            "code"  : code
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.verifyPhoneNo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //register Phone no check
    func registerUsernameCheck(username:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "username"         : username
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.checkUsername.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-likeReplycomments
    
    func likeReplyComments(user_id:String,comment_reply_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "comment_reply_id"    : comment_reply_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.likeCommentReply.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
      
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                   
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //register Phone no check
    func registerPhoneCheck(phone:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "phone"         : phone
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- postCommentReply
    func postCommentReply(user_id:String,comment:String,comment_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?,_ err:String)->Void){
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.postCommentReply.rawValue)"
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "comment_id" : comment_id,
            "comment"    : comment,
            "user_id"    : user_id
        ]
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        completionHandler(true, dict, "")
                        
                    } catch {
                        completionHandler(false, nil, "")
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict, error.localizedDescription)
                        
                    } catch {
                        completionHandler(false, nil, error.localizedDescription)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- Check register Social account
    func checkRegisterSocial(auth_token:String,socail_type:String,social_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : Any]()
        if socail_type == "email" {
        }else if socail_type == "phone" {
        }else {
            parameters["social_id"] = social_id
            parameters["social"] = socail_type
            parameters["auth_token"] = auth_token
        }
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:- register Phone
    func registerPhone(phone:String,dob:String,username:String,email:String,gender:String ,referral_code:String,first_name:String,last_name:String,auth_token:String,device_token:String,ip:String,profile_pic:Any,socail_type:String,social_id:String,password:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : Any]()
        parameters = [
            "dob"           : dob,
            "username"      : username,
            "first_name"    : first_name,
            "last_name"     : last_name,
            "gender"        : gender,
            "ip"            : ip,
            "referral_code" : referral_code,
            "device_token"  : device_token,
            "profile_pic"   : profile_pic
        ]
        
        if socail_type == "email" {
            parameters["email"] = email
            parameters["password"] = password
        }else if socail_type == "phone" {
            parameters["phone"] = phone
        }else {
            parameters["email"] = email
            parameters["social_id"] = social_id
            parameters["social"] = socail_type
            parameters["auth_token"] = auth_token
        }
        
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- Delete Account
    func DeleteAccount(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"         : user_id,
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.DeleteAccount.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //    MARK:- login with EMAIL
    func loginEmail(email:String,password:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "email"         : email,
            "password"         : password
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.login.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //    MARK:- verifyforgotPasswordCode
    
    func verifyforgotPasswordCode(email:String,code:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            
            "email"         : email,
            "code"         : code
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.verifyforgotPasswordCode.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
          
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                       
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- Forgot email
    func forgotPassword(email:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY,
            "User_Id":"",
            "Auth_token" : ""
        ]
        var parameters = [String : String]()
        parameters = [
            
            "email"   : email,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.forgotPassword.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- Add Device Data
    
    func addDeviceData(user_id:String,device:String,version:String,ip:String,device_token:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"      : user_id,
            "device"       : device,
            "version"      : version,
            "ip"           : ip,
            "device_token" : device_token,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addDeviceData.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- registerDevice
    
    func registerDevice(key:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "key":key
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.registerDevice.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- showDeviceDetail
    
    func showDeviceDetails(key:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "key"      : key
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showDeviceDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- postVideo
    
    //    IN POST VIEW CONTROLLER CODE MULTIPART
    func postVideo(User_id :String ,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY,
            "User-Id":User_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.postVideo.rawValue)"
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-showVideoDetailAd
    func showVideoDetailAd(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideoDetailAd.rawValue)"
        
        print("finalURL",finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default
                   , headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
                    print("response: related vid",response.value)
                    
                    switch response.result {
                    
                    case .success(_):
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    case .failure(let error):
                        print("Failure")
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    }
                   }
    }
    
    //MARK:-showRelatedVideos
    func showRelatedVideos(device_id:String,user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "device_id"      : device_id,
            "starting_point" : starting_point
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showRelatedVideos.rawValue)"
        
        print("finalURL",finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default
                   , headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
                    print("response: related vid",response.value)
                    
                    switch response.result {
                    
                    case .success(_):
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    case .failure(let error):
                        print("Failure")
                        if let json = response.value
                        {
                            do {
                                let dict = json as? NSDictionary
                                print(dict)
                                completionHandler(true, dict)
                                
                            } catch {
                                completionHandler(false, nil)
                            }
                        }
                        break
                    }
                   }
    }
    //MARK:-showFollowingVideos
    func showFollowingVideos(user_id:String,device_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY,
            "User_Id":user_id,
            //            "Auth_token" : UserDefaults.standard.string(forKey: "authToken")!
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "device_id"      : device_id,
            "starting_point" : starting_point
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFollowingVideos.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:-showVideosAgainstUserID
    func showVideosAgainstUserID(user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "starting_point"   : starting_point
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideosAgainstUserID.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print("showVideosAgainstUserID ",dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-like comments
    func likeComments(user_id:String,comment_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "comment_id"    : comment_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.likeComment.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                   
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    

    //MARK:-showRecommendedUsers
    func showSuggestedUsers(user_id:String,country_id : String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "country_id"     :  country_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showSuggestedUsers.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-showOtherUserDetail
    func showOtherUserDetail(user_id:String,other_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "other_user_id"  : other_user_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showUserDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            print(response.response?.statusCode)
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-showUserSounds
    func showUserSounds(user_id:String,other_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "other_user_id"  : other_user_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showUserSounds.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:-showOwnDetail
    func showOwnDetail(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showUserDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        
//                        guard let data = response.data else {
//                              return
//                            }
//
//                        if let json1 = try? JSONSerialization
//                              .jsonObject(with: data, options: .mutableContainers) {
//                                print(json1)
//                            }
//
                        
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-showBlockedUsers
    func showBlockedUsers(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showBlockedUsers.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-LikeVideo
    func likeVideo(user_id:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "video_id"       : video_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.likeVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-WatchVideo
    func watchVideo(device_id:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "device_id"        : device_id,
            "video_id"         : video_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.watchVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-rePostVideo
    func rePostVideo(repost_user_id:String,video_id:String,repost_comment:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "repost_user_id"        : repost_user_id,
            "video_id"         : video_id,
            "repost_comment" : repost_comment
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.repostVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- downloadVideo
    func downloadVideo(video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key" : API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id" : video_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.downloadVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- deleteWaterMarkVideo
    func deleteWaterMarkVideo(video_url:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "video_url" : video_url
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.deleteWaterMarkVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-showSounds
    func showSounds(user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
//            "user_id"          : user_id,
            "starting_point"   : starting_point,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showSounds.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-addSoundFavourite
    func addSoundFavourite(user_id:String,sound_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "sound_id"   : sound_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addSoundFavourite.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-showSounds
    func showSoundsAgainstSection(user_id:String,starting_point:String,sectionID:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "starting_point"   : starting_point,
            "sound_section_id"   : sectionID
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showSoundsAgainstSection.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:-showFavouriteSounds
    func showFavouriteSounds(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFavouriteSounds.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-showUserLikedVideos
    func showUserLikedVideos(user_id:String,starting_point : String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "starting_point" : starting_point
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showUserLikedVideos.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-followUser
    func followUser(sender_id:String,receiver_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "sender_id"    : sender_id,
            "receiver_id"  : receiver_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.followUser.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-followerNotification
    func followerNotification(sender_id:String,receiver_id:String,notification:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "sender_id"    : sender_id,
            "receiver_id"  : receiver_id,
            "notification"  : notification
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.followerNotification.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- showDiscoverySections
    
    func showDiscoverySections(user_id : String, country_id : String,starting_point : String, completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showDiscoverySections.rawValue)"
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
        ]
       
        
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "country_id"     :  country_id,
            "starting_point"     :  starting_point
        ]
        
        
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                      //  print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-showVideoComments
    func showVideoComments(video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id"    : video_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideoComments.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- postCommentOnVideo
    func postCommentOnVideo(user_id:String,comment:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.postCommentOnVideo.rawValue)"
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id"    : video_id,
            "comment"    : comment,
            "user_id"    : user_id
        ]
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:-showVideoComments
    func showVideoComments(video_id:String,user_id:String,starting_point:Int,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : Any]()
        parameters = [
            "video_id"          : video_id,
            "user_id"           : user_id,
            "starting_point"    : starting_point
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideoComments.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
         
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- editProfile
    func editProfile(isPhoneChange:Bool,isEditProfile:Bool,username:String,user_id:String,first_name:String,last_name:String,gender:String,website:String,bio:String,dob:String,privateKey:String,phone:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.editProfile.rawValue)"
        
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        
        
       
        var parameteres = [String:String]()
        
        
        if isEditProfile == false {
            
            parameteres = [
                
                "user_id":user_id,
                "private": privateKey
            ]
            
        }else {
            
            if isPhoneChange == false {
                parameteres = [
                    "username":username,
                    "user_id":user_id,
                    "first_name":first_name,
                    "last_name":last_name,
                    "gender":gender,
                    "website":website,
                    "bio":bio,
                    "dob" : dob
                ]
                
            }else {
                
                
                parameteres = [
                   
                    "user_id":user_id,
                    "phone":phone
                    
                ]
                
            }
            
        
        }
       
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameteres, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- showFollowers
    func showFollowers(user_id:String,other_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "other_user_id"    : other_user_id,
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFollowers.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- ShowFollowing
    func showFollowing(Followers: String ,user_id:String,other_user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        print("isOtherUserVisit",isOtherUserVisit)
        if isOtherUserVisit == true {
            print("user_id",user_id)
            if user_id == "" {
                parameters = [
                    "user_id"          : user_id,
                    "starting_point"  : starting_point
                ]
                
                
            }else {
                parameters = [
                    "user_id"          : user_id,
                    "other_user_id"    : other_user_id,
                    "starting_point"  : starting_point
                ]
 
            }
            
        }else {
            
            parameters = [
                "user_id"          : user_id,
                "starting_point"  : starting_point
            ]
            
        }
        
        var finalUrl = ""
        if Followers == "Followers" {
            finalUrl = "\(self.baseApiPath!)\(Endpoint.showFollowers.rawValue)"
        }else {
            finalUrl = "\(self.baseApiPath!)\(Endpoint.showFollowing.rawValue)"
        }
       
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    
    
    //MARK:- showVideosAgainstHashtag
    func showVideosAgainstHashtag(user_id:String,hashtag:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "hashtag"    : hashtag,
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideosAgainstHashtag.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:- Block User
    func blockUser(user_id:String,block_user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.blockUser.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id" : user_id,
            "block_user_id" : block_user_id
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- sendMessageNotification
    
    func sendMessageNotification(senderID:String,receiverID:String,msg:String,title:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "sender_id": senderID,
            "receiver_id": receiverID,
            "message": msg,
            "title": title
           // "video_id": video_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.sendMessageNotification.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- Add User Image
    func addUserImage(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
      
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addUserImage.rawValue)"
        
        print(finalUrl)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- admin/deleteVideo
    
    func deleteVideo(video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "video_id"    : video_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.deleteVideo.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- Search
    func Search(user_id:String,type:String,keyword:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
//            "user_id"        : user_id,
            "type"           : type,
            "keyword"        : keyword,
            "starting_point" : starting_point
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.search.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- showVideoDetail
    func showVideoDetail(user_id:String,video_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"    : user_id,
            "video_id"   : video_id
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideoDetail.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:- showAllNotifications
    func showAllNotifications(user_id:String,starting_point:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id":user_id,
            "starting_point":starting_point
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showAllNotifications.rawValue)"
        
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- userVerificationRequest
    func userVerificationRequest(user_id:String,attachment:Any,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : Any]()
        parameters = [
            "user_id"      : user_id,
            "attachment"   : attachment
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.userVerificationRequest.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
   
    //MARK:- showAppSlider
    func showAppSlider(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "" : ""
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showAppSlider.rawValue)"
        
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                       // print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- logout
    func logout(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY,
            "User_Id":user_id
            //            "Auth_token" : UserDefaults.standard.string(forKey: "authToken")!
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.logout.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id
        ]
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- showVideosAgainstSound
    
    func showVideosAgainstSound(user_id:String,sound_id:String,starting_point:String,device_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "sound_id"   : sound_id,
            "starting_point"   : starting_point,
            "device_id"  : device_id,
            
            
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showVideosAgainstSound.rawValue)"
        print(finalUrl)
        print(parameters)
        
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-showReportReasons
    func showReportReasons(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        
        var parameters = [String : String]()
        parameters = [
            "":""
            
        ]
        
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showReportReasons.rawValue)"
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-reportVideo
    func reportVideo(user_id:String,video_id:String,report_reason_id:String,description:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.reportVideo.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"           : user_id,
            "video_id"          : video_id,
            "report_reason_id"  : report_reason_id,
            "description"       : description,
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- NotInterestedVideo
    func NotInterestedVideo(video_id:String,user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.NotInterestedVideo.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "video_id"  : video_id,
            "user_id"   : user_id,
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- addVideoFavourite
    func addVideoFavourite(video_id:String,user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addVideoFavourite.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "video_id"   : video_id,
            "user_id"    : user_id,
            
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    
    //MARK:- showFavouriteVideos
    func showFavouriteVideos(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFavouriteVideos.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- updatePushNotificationSettings
    func updatePushNotificationSettings(user_id:String,comments:String,new_followers:String,mentions:String,likes:String,direct_messages:String,video_updates:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.updatePushNotificationSettings.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "likes"          : likes,
            "comments"       : comments,
            "new_followers"  : new_followers,
            "mentions"       : mentions,
            "video_updates"  : video_updates,
            "direct_messages"  : direct_messages,
            "user_id"        : user_id
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    //MARK:- addHashtagFavourite
    func addHashtagFavourite(user_id:String,hashtag_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addHashtagFavourite.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "hashtag_id"    : hashtag_id,
            "user_id"       : user_id,
            
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:- showFavouriteHashtags
    func showFavouriteHashtags(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showFavouriteHashtags.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"       : user_id,
            
        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:-liveStream
    func liveStream(user_id : String, started_at : String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"        : user_id,
            "started_at"     :  started_at
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.liveStream.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                         
                        completionHandler(true, dict)
                        
                    }
                }
                break
            case .failure(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                         
                        completionHandler(true, dict)
                        
                    }
                }
                break
            }
        }
    }
    
    func reportUser(user_id:String,report_user_id:String,report_reason_id:String,description:String,live_streaming_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.reportUser.rawValue)"
        var parameters = [String : String]()
        parameters = [
            "user_id"          : user_id,
            "report_user_id"   : report_user_id,
            "report_reason_id" : report_reason_id,
            "description"      : description
            
        ]
        if live_streaming_id != ""{
            parameters["live_streaming_id"] = live_streaming_id
        }
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                         
                        completionHandler(true, dict)
                        
                    }
                }
                break
            case .failure(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                         
                        completionHandler(true, dict)
                        
                    }
                }
                break
            }
        }
    }
    
    //MARK:- addPrivacySetting
    func addPrivacySetting(params : [String : String],completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key": API_KEY
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addPrivacySetting.rawValue)"
        var parameters = [String : String]()
        parameters =  params
//        parameters = [
//            "videos_download" : videos_download,
//            "direct_message"  : direct_message,
//            "duet"            : duet,
//            "liked_videos"    : liked_videos,
//            "video_comment"   : video_comment,
//            "user_id"         : user_id,
//            "private"         : privatekey,
//
//
//        ]
        print(finalUrl)
        print(parameters)
        
        print(finalUrl)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK: - search hashtags
    func getAllHashtags(uid:String,starting_point:String, completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?, _ userObj:Hashtag?)->Void){
        
        //        self.ldr.activityStartAnimating()
        
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : String]()
        parameters = [
            "keyword": "",
            "type": "hashtag",
            "starting_point": starting_point,
            "user_id": uid
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.search.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            //            self.ldr.activityStopAnimating()
            //            let obj = response.data?.getDecodedObject(from: Hashtag.self)
            
            let obj = try? JSONDecoder().decode(Hashtag.self, from: response.data!)
            
            
            print(obj?.code)
            print(obj?.msg)
            
            
            
            switch response.result {
            
            case .success(_):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict, obj)
                        
                    } catch {
                        completionHandler(false, nil,nil)
                    }
                }
                break
            case .failure(let error):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict, obj)
                        
                    } catch {
                        completionHandler(false, nil,nil)
                    }
                }
                break
            }
        }
    }
    
    
    
    
    
    //MARK:- Coins Purchase
    func purchaseCoin(uid:String,coin:String, title:String, price:String,transaction_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id":uid,
            "coin":coin,
            "title":title,
            "price":price,
            "transaction_id":transaction_id,
            "device":"ios"
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.purchaseCoin.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            let obj = try? JSONDecoder().decode(Hashtag.self, from: response.data!)
            
            
            print(obj?.code)
            print(obj?.msg)
            
            
            
            switch response.result {
            
            case .success(_):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    func showCoinWorth(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : Any]()
        parameters = ["":""]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.coinWorth.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            let obj = try? JSONDecoder().decode(Hashtag.self, from: response.data!)
            
            
            print(obj?.code)
            print(obj?.msg)
            
            
            
            switch response.result {
            
            case .success(_):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    func coinWithDrawRequest(user_id:String,amount:Int,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : Any]()
        
        parameters = ["user_id":user_id,
                      "amount":amount]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.coinWithDrawRequest.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            let obj = try? JSONDecoder().decode(Hashtag.self, from: response.data!)
            print(obj?.code)
            print(obj?.msg)
            switch response.result {
            
            case .success(_):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict )
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    func addPayout(user_id:String,email:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : Any]()
        
        parameters = ["user_id":user_id,
                      "email":email]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.addPayOut.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            let obj = try? JSONDecoder().decode(Hashtag.self, from: response.data!)
            print(obj?.code)
            print(obj?.msg)
            switch response.result {
            
            case .success(_):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    func sendGifts(sender_id:String,receiver_id:String,gift_id:String,gift_count:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : Any]()
        
        parameters = ["sender_id":sender_id,
                      "receiver_id":receiver_id,
                      "gift_id":gift_id,
                      "gift_count": gift_count,
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.sendGift.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            let obj = try? JSONDecoder().decode(Hashtag.self, from: response.data!)
            print(obj?.code)
            print(obj?.msg)
            switch response.result {
            
            case .success(_):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    func showGifts(completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : Any]()
        
        parameters = ["":""]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showGifts.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            let obj = try? JSONDecoder().decode(Hashtag.self, from: response.data!)
            print(obj?.code)
            print(obj?.msg)
            switch response.result {
            
            case .success(_):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
    //MARK:Suggested
    func suggestedPeople(user_id:String,completionHandler:@escaping( _ result:Bool, _ responseObject:NSDictionary?)->Void){
        let headers: HTTPHeaders = [
            "Api-Key":API_KEY
            
        ]
        var parameters = [String : String]()
        parameters = [
            "user_id"         : user_id
        ]
        let finalUrl = "\(self.baseApiPath!)\(Endpoint.showSuggestedUsers.rawValue)"
        
        print(finalUrl)
        print(parameters)
        AF.request(URL.init(string: finalUrl)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers,requestModifier: { $0.timeoutInterval = 60 }).responseJSON { (response) in
            print(response.result)
            
            switch response.result {
            
            case .success(_):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict as Any)
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            case .failure(let error):
                if let json = response.value
                {
                    do {
                        let dict = json as? NSDictionary
                        print(dict)
                        
                        completionHandler(true, dict)
                        
                    } catch {
                        completionHandler(false, nil)
                    }
                }
                break
            }
        }
    }
    
}
