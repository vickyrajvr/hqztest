//
//  SpacesListeners.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 13/04/2023.
//

import Foundation

import Foundation
import UIKit
import Firebase

class SpacesListeners
{
    static let shared = SpacesListeners()
    
    
    func joinRoom(uid: String, roomId: String, completionHandler: @escaping (_ result: Bool) -> Void)
    {
        let Joined  = Database.database().reference().child("Joined").child(uid)
        let value = ["roomId": "\(roomId)"] as [String : Any]
        
        Joined.updateChildValues(value) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
        }
    }
    
    func LeaveRoom(uid: String, completionHandler: @escaping (_ result: Bool) -> Void)
    {
        let Joined  = Database.database().reference().child("Joined").child(uid).removeValue()
       
//
//        Joined.updateChildValues(value) { (error, Ref) in
//            if error != nil
//            {
//                print("error in send message fromId: ", error!.localizedDescription)
//                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
//                completionHandler(false)
//            }
            completionHandler(true)
//        }
    }
    
    func DeleteRoom(roomID: String, completionHandler: @escaping (_ result: Bool) -> Void)
    {
//        let Joined  = Database.database().reference().child("Joined").child(uid).removeValue()
       
        Database.database().reference().child("LiveRoom").child(roomID).removeValue()
        
//
//        Joined.updateChildValues(value) { (error, Ref) in
//            if error != nil
//            {
//                print("error in send message fromId: ", error!.localizedDescription)
//                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
//                completionHandler(false)
//            }
            completionHandler(true)
//        }
    }
    
    //MARK:- LiveRoom message
    func LiveRoom(completionHandler: @escaping (_ result: Bool, _ messages: [String : Any]) -> Void)
    {
        let messages = Database.database().reference().child("LiveRoom")
        messages.observe(.value, with: { (dataSnapshot) in
            
            if let dict = dataSnapshot.value as? [String: Any]
            {
                completionHandler(true, dict)
            }
            
        }, withCancel: nil)
    }
    
    //MARK:- AddLiveRoom message
    func AddLiveRoom(roomID: String, values : Any, Users : Any, userModel : Any , completionHandler: @escaping (_ result: Bool) -> Void)
    {
        
        let Joined = Database.database().reference().child("LiveRoom").child(roomID)
        let UsersNode = Joined.child("Users").child(UserDefaultsManager.shared.user_id)
        let UserModelNode = UsersNode.child("userModel")
        
        let value = values as! [String : Any]
        
        let User = Users as! [String : Any]
        
        let userMod = userModel as! [String : Any]
        
        Joined.updateChildValues(value) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
            
        }
        
        UsersNode.updateChildValues(User) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
            
        }
        
        UserModelNode.updateChildValues(userMod) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
            
        }
        
        
        
    }
    //MARK:- JoinModeratorLiveRoom message
    func JoinModeratorLiveRoom(roomID: String, user_id : String, userRoleType : String, completionHandler: @escaping (_ result: Bool) -> Void)
    {
        let Joined = Database.database().reference().child("LiveRoom").child(roomID)
        let UsersNode = Joined.child("Users").child(user_id)
        var Users = [String : Any]()
        Users = [
            "userRoleType"      : userRoleType
        ]
        UsersNode.updateChildValues(Users) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
            
        }
    }
    //MARK:- JoinUserLiveRoom message
    func JoinUserLiveRoom(roomID: String, user_id : String, Users : Any, userModel : Any , completionHandler: @escaping (_ result: Bool) -> Void)
    {
        
        let Joined = Database.database().reference().child("LiveRoom").child(roomID)
        let UsersNode = Joined.child("Users").child(user_id)
//        let UserModelNode = UsersNode.child("userModel")
        let User = Users as! [String : Any]
        
//        var Users1 = [String : Any]()
//        Users1 = [
//            "mice"        : "0",
//            "online"        : "1",
//            "riseHand"        : "0",
//            "userRoleType"      : "0",
//            "userModel"      : userModel
//        ]
        
//        UsersNode.setValue(Users1)
        
//        let userMod = userModel as! [String : Any]
        UsersNode.updateChildValues(User) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)

        }
        
//        UserModelNode.updateChildValues(userMod) { (error, Ref) in
//            if error != nil
//            {
//                print("error in send message fromId: ", error!.localizedDescription)
//                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
//                completionHandler(false)
//            }
//            completionHandler(true)
//
//        }
    }
    
    //MARK:- UpdateRaisehandUserLiveRoom message
    func UpdateRaisehandUserLiveRoom(roomID: String, userid : String, raishand : String , completionHandler: @escaping (_ result: Bool) -> Void)
    {
        
        let Joined = Database.database().reference().child("LiveRoom").child(roomID)
        let UsersNode = Joined.child("Users").child(userid)
        
        let value = ["riseHand": "\(raishand)"] as [String : Any]
        
        UsersNode.updateChildValues(value) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
        }
    }
    
    //MARK:- RoomInvitation message
    func RoomInvitation(roomID: String, userid : String, userModel : Any , completionHandler: @escaping (_ result: Bool) -> Void)
    {
        
        let RoomInvitation = Database.database().reference().child("LiveRoom").child(roomID).child("RoomInvitation")
        let UsersNode = RoomInvitation.child(userid)
        
        let userMod = userModel as! [String : Any]
        print(userMod)
        
        UsersNode.updateChildValues(userMod) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
            
        }
    }

    
    //MARK:- LeaveUserLiveRoom message
    func LeaveUserLiveRoom(roomID: String, values : Any, Users : Any, userModel : Any , completionHandler: @escaping (_ result: Bool) -> Void)
    {
        
        let Joined = Database.database().reference().child("LiveRoom").child(roomID)
        let UsersNode = Joined.child("Users").child(UserDefaultsManager.shared.user_id)
        
        UsersNode.child("userModel").removeValue()
        UsersNode.child("mice").removeValue()
        UsersNode.child("riseHand").removeValue()
        UsersNode.child("userRoleType").removeValue()
        
        let User = Users as! [String : Any]
        let userMod = userModel as! [String : Any]
        UsersNode.updateChildValues(User) { (error, Ref) in
            if error != nil
            {
                print("error in send message fromId: ", error!.localizedDescription)
                AppUtility!.displayAlert(title: "customChat", message: error!.localizedDescription)
                completionHandler(false)
            }
            completionHandler(true)
            
        }
    }
    
    //MARK:- getSpaceRoomInvitation
    func getSpaceRoomInvitation(roomID: String,completionHandler: @escaping (_ result: Bool, _ messages: [String : Any]) -> Void)
    {
        let RoomInvitation = Database.database().reference().child("LiveRoom").child(roomID).child("RoomInvitation")
        
        
        RoomInvitation.observe(.value, with: { (dataSnapshot) in
            
            if let dict = dataSnapshot.value as? [String: Any]
            {
                completionHandler(true, dict)
            }
            
        }, withCancel: nil)
    }
    
    
    
}
