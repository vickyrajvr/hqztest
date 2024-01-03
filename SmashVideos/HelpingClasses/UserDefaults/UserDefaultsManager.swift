//
//  UserDefaultsManager.swift
//  ParkSpace
//
//  Created by Zubair Ahmed on 02/03/2022.
//

import Foundation
import UIKit
fileprivate enum UserDefaultsKey : String {
    case user_id            = "user_id"
    case otherUserID            = "otherUserID"
    case auth_token         = "auth_token"
    case device_token       = "device_token"
    case deviceID       = "deviceID"
    case country_id       = "country_id"
    case saveAudioFilePath       = "saveAudioFilePath"
    case wallet =            "wallet"
    case sound_id = "sound_id"
    case spaceRoomId = "spaceRoomId"
    case LiveStreamingId = "LiveStreamingId"
   
}

fileprivate class UserDefault {
    static func _set(value : Any?, key : UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    static func _get(valueForKey  Key: UserDefaultsKey) -> Any? {
        return UserDefaults.standard.value(forKey: Key.rawValue)
    }
}
class UserDefaultsManager
{
    class var shared: UserDefaultsManager {
        struct Static {
            static let instance = UserDefaultsManager()
        }
        return Static.instance
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    var user_id : String {
        set{
            UserDefault._set(value: newValue, key: .user_id)
        } get {
            return UserDefault._get(valueForKey: .user_id) as? String ?? ""
        }
    }
    
    var sound_id : String {
        set{
            UserDefault._set(value: newValue, key: .sound_id)
        } get {
            return UserDefault._get(valueForKey: .sound_id) as? String ?? ""
        }
    }
    
    var wallet : String {
        set{
            UserDefault._set(value: newValue, key: .wallet)
        } get {
            return UserDefault._get(valueForKey: .wallet) as? String ?? ""
        }
    }
    
    var otherUserID : String {
        set{
            UserDefault._set(value: newValue, key: .otherUserID)
        } get {
            return UserDefault._get(valueForKey: .otherUserID) as? String ?? ""
        }
    }
    
    var auth_token : String {
        set{
            UserDefault._set(value: newValue, key: .auth_token)
        } get {
            return UserDefault._get(valueForKey: .auth_token) as? String ?? ""
        }
    }
    
    var device_token : String {
        set{
            UserDefault._set(value: newValue, key: .device_token)
        } get {
            return UserDefault._get(valueForKey: .device_token) as? String ?? ""
        }
    }
    
    var LiveStreamingId : String {
        set{
            UserDefault._set(value: newValue, key: .LiveStreamingId)
        } get {
            return UserDefault._get(valueForKey: .LiveStreamingId) as? String ?? ""
        }
    }
    
    
    var deviceID : String {
        set{
            UserDefault._set(value: newValue, key: .deviceID)
        } get {
            return UserDefault._get(valueForKey: .deviceID) as? String ?? ""
        }
    }
    var country_id : String {
        set{
            UserDefault._set(value: newValue, key: .country_id)
        } get {
            return UserDefault._get(valueForKey: .country_id) as? String ?? ""
        }
    }
    var saveAudioFilePath : String {
        set{
            UserDefault._set(value: newValue, key: .saveAudioFilePath)
        } get {
            return UserDefault._get(valueForKey: .saveAudioFilePath) as? String ?? ""
        }
    }
    var spaceRoomId : String {
        set{
            UserDefault._set(value: newValue, key: .spaceRoomId)
        } get {
            return UserDefault._get(valueForKey: .spaceRoomId) as? String ?? ""
        }
    }
}
