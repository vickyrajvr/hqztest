//
//  ShowRoomM.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 11/04/2023.
//

import Foundation

struct ShowRoomM : Codable {
    
    let code : Int?
    let msg : [ShowRoomObject]?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}
struct ShowRoomObject : Codable {
    
    let room : Room?
    let roomMember : [RoomMember]?
    let topic : Topic?
    
    
    enum CodingKeys: String, CodingKey {
        case room = "Room"
        case roomMember = "RoomMember"
        case topic = "Topic"
    }
}
    
struct Room : Codable {
    
    let moderators : [Moderator]?
    let created : String?
    let delete : String?
    let id : String?
    let member : Int?
    let memberCount : Int?
    let privacy : String?
    let roomId : String?
    let title : String?
    let topicId : String?
    let userId : String?
    
    
    enum CodingKeys: String, CodingKey {
        case moderators = "Moderators"
        case created = "created"
        case delete = "delete"
        case id = "id"
        case member = "member"
        case memberCount = "member_count"
        case privacy = "privacy"
        case roomId = "room_id"
        case title = "title"
        case topicId = "topic_id"
        case userId = "user_id"
    }
}

struct Moderator : Codable {
    
    let roomMember : RoomMember?
    let user : Users?
    
    
    enum CodingKeys: String, CodingKey {
        case roomMember
        case user
    }
}
struct Topic : Codable {
    
    let created : String?
    let id : String?
    let image : String?
    let title : String?
    let view : String?
    
    
    enum CodingKeys: String, CodingKey {
        case created = "created"
        case id = "id"
        case image = "image"
        case title = "title"
        case view = "view"
    }
}


struct RoomMember : Codable {
    
    let user : Users?
    let created : String?
    let id : String?
    let moderator : String?
    let roomId : String?
    let userId : String?
    
    
    enum CodingKeys: String, CodingKey {
        case user = "User"
        case created = "created"
        case id = "id"
        case moderator = "moderator"
        case roomId = "room_id"
        case userId = "user_id"
    }
}


struct Users : Codable {
    
    let active : String?
    let authToken : String?
    let bio : String?
    let city : String?
    let country : String?
    let countryId : String?
    let created : String?
    let device : String?
    let deviceToken : String?
    let dob : String?
    let email : String?
    let firstName : String?
    let gender : String?
    let id : String?
    let ip : String?
    let lastName : String?
    let lat : String?
    let locationString : String?
    let longField : String?
    let online : String?
    let password : String?
    let paypal : String?
    let phone : String?
    let privateField : String?
    let profileGif : String?
    let profilePic : String?
    let profilePicSmall : String?
    let profileView : String?
    let region : String?
    let resetWalletDatetime : String?
    let role : String?
    let social : String?
    let socialId : String?
    let state : String?
    let token : String?
    let username : String?
    let verified : String?
    let version : String?
    let wallet : String?
    let website : String?
    
    
    enum CodingKeys: String, CodingKey {
        case active = "active"
        case authToken = "auth_token"
        case bio = "bio"
        case city = "city"
        case country = "country"
        case countryId = "country_id"
        case created = "created"
        case device = "device"
        case deviceToken = "device_token"
        case dob = "dob"
        case email = "email"
        case firstName = "first_name"
        case gender = "gender"
        case id = "id"
        case ip = "ip"
        case lastName = "last_name"
        case lat = "lat"
        case locationString = "location_string"
        case longField = "long"
        case online = "online"
        case password = "password"
        case paypal = "paypal"
        case phone = "phone"
        case privateField = "private"
        case profileGif = "profile_gif"
        case profilePic = "profile_pic"
        case profilePicSmall = "profile_pic_small"
        case profileView = "profile_view"
        case region = "region"
        case resetWalletDatetime = "reset_wallet_datetime"
        case role = "role"
        case social = "social"
        case socialId = "social_id"
        case state = "state"
        case token = "token"
        case username = "username"
        case verified = "verified"
        case version = "version"
        case wallet = "wallet"
        case website = "website"
    }
}
