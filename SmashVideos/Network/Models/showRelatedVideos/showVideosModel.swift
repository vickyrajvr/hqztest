//
//  showVideosModel.swift
//  WOOW
//
//  Created by Zubair Ahmed on 24/11/2022.
//

import Foundation

struct showVideosModel : Codable {

    let code : Int?
    let key : Int?
    let msg : [VideosModel]?


    enum CodingKeys: String, CodingKey {
        case code = "code"
        case key = "key"
        case msg = "msg"
    }
}

struct VideoDetailModel : Codable {

    let code : Int?
//    let msg : VideoDetailMsg?
    let next : [String]?
    let previous : [String]?


    enum CodingKeys: String, CodingKey {
        case code = "code"
//        case msg = "msg"
        case next = "next"
        case previous = "previous"
    }
}

//struct VideoDetailMsg : Codable {
//
//    let sound : Sound?
//    let user : AppUser?
//    let video : Video?
//    let videoComment : [VideoComment]?
//
//
//    enum CodingKeys: String, CodingKey {
//        case sound = "Sound"
//        case user = "User"
//        case video = "Video"
//        case videoComment = "VideoComment"
//    }
//}

struct Videoed : Codable {

    let advertise : String?
    let allowComments : String?
    let allowDuet : String?
    let block : String?
    let commentCount : Int?
    let countryId : String?
    let created : String?
    let descriptionField : String?
    let duetVideoId : String?
    let duration : String?
    let favourite : Int?
    let fbId : String?
    let gif : String?
    let height : String?
    let id : String?
    let like : Int?
    let likeCount : String?
    let privacyType : String?
    let promoteButton : Int?
    let repostComment : String?
    let repostCount : String?
    let repostUserId : String?
    let repostVideoId : String?
    let section : String?
    let soundId : String?
    let thum : String?
    let userId : String?
    let video : String?
    let videoRepostCount : String?
    let view : String?
    let viral : String?
    let watermark : String?
    let width : String?
    let promote : Int?
        let promotionId : Int?

    enum CodingKeys: String, CodingKey {
        case advertise = "advertise"
        case allowComments = "allow_comments"
        case allowDuet = "allow_duet"
        case block = "block"
        case commentCount = "comment_count"
        case countryId = "country_id"
        case created = "created"
        case descriptionField = "description"
        case duetVideoId = "duet_video_id"
        case duration = "duration"
        case favourite = "favourite"
        case fbId = "fb_id"
        case gif = "gif"
        case height = "height"
        case id = "id"
        case like = "like"
        case likeCount = "like_count"
        case privacyType = "privacy_type"
        case promoteButton = "promote_button"
        case repostComment = "repost_comment"
        case repostCount = "repost_count"
        case repostUserId = "repost_user_id"
        case repostVideoId = "repost_video_id"
        case section = "section"
        case soundId = "sound_id"
        case thum = "thum"
        case userId = "user_id"
        case video = "video"
        case videoRepostCount = "video_repost_count"
        case view = "view"
        case viral = "viral"
        case watermark = "watermark"
        case width = "width"
        case promote = "promote"
        case promotionId = "promotion_id"
    }
}
struct VideoComment : Codable {

    let user : AppUser?
    let comment : String?
    let created : String?
    let id : String?
    let userId : String?
    let videoId : String?


    enum CodingKeys: String, CodingKey {
        case user = "User"
        case comment = "comment"
        case created = "created"
        case id = "id"
        case userId = "user_id"
        case videoId = "video_id"
    }
    
}

struct VideosModel : Codable {

    let country : Country?
    let sound : VideoSound?
    let user : AppUser?
    let video : Videoed?


    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case sound = "Sound"
        case user = "User"
        case video = "Videoed"
    }
}

struct VideoSound : Codable {
    let audio : String?
    let countryId : String?
    let created : String?
    let deleted : String?
    let descriptionField : String?
    let duration : String?
    let favourite : Int?
    let id : String?
    let name : String?
    let publish : String?
    let soundSectionId : String?
    let thum : String?
    let uploadedBy : String?
    let userId : String?

    enum CodingKeys: String, CodingKey {
        case audio = "audio"
        case countryId = "country_id"
        case created = "created"
        case deleted = "deleted"
        case descriptionField = "description"
        case duration = "duration"
        case favourite = "favourite"
        case id = "id"
        case name = "name"
        case publish = "publish"
        case soundSectionId = "sound_section_id"
        case thum = "thum"
        case uploadedBy = "uploaded_by"
        case userId = "user_id"
    }
}
struct AppUser : Codable {

    let privacySetting : PrivacySettingModel?
    let pushNotification : PushNotificationModel?
    let active : String?
    let authToken : String?
    let bio : String?
    let button : String?
    let city : String?
    let cityId : String?
    let country : String?
    let countryId : String?
    let created : String?
    let device : String?
    let deviceToken : String?
    let dob : String?
    let email : String?
    let firstName : String?
    let followersCount : Int?
    let gender : String?
    let id : String?
    let ip : String?
    let lastName : String?
    let lastWallet : String?
    let lat : String?
    let longField : String?
    let online : String?
    let password : String?
    let phone : String?
    let postVideoNotification : String?
    let privateField : String?
    let profilePic : String?
    let profilePicSmall : String?
    let referralCode : String?
    let region : String?
    let resetWalletDatetime : String?
    let role : String?
    let salt : String?
    let social : String?
    let socialId : String?
    let stateId : String?
    let token : String?
    let username : String?
    let verified : String?
    let version : String?
    let wallet : String?
    let website : String?


    enum CodingKeys: String, CodingKey {
        case privacySetting = "PrivacySetting"
        case pushNotification = "PushNotification"
        case active = "active"
        case authToken = "auth_token"
        case bio = "bio"
        case button = "button"
        case city = "city"
        case cityId = "city_id"
        case country = "country"
        case countryId = "country_id"
        case created = "created"
        case device = "device"
        case deviceToken = "device_token"
        case dob = "dob"
        case email = "email"
        case firstName = "first_name"
        case followersCount = "followers_count"
        case gender = "gender"
        case id = "id"
        case ip = "ip"
        case lastName = "last_name"
        case lastWallet = "last_wallet"
        case lat = "lat"
        case longField = "long"
        case online = "online"
        case password = "password"
        case phone = "phone"
        case postVideoNotification = "post_video_notification"
        case privateField = "private"
        case profilePic = "profile_pic"
        case profilePicSmall = "profile_pic_small"
        case referralCode = "referral_code"
        case region = "region"
        case resetWalletDatetime = "reset_wallet_datetime"
        case role = "role"
        case salt = "salt"
        case social = "social"
        case socialId = "social_id"
        case stateId = "state_id"
        case token = "token"
        case username = "username"
        case verified = "verified"
        case version = "version"
        case wallet = "wallet"
        case website = "website"
    }
}
struct Country : Codable {

    let active : String?
    let capital : String?
    let createdAt : String?
    let currency : String?
    let emoji : String?
    let emojiU : String?
    let flag : Bool?
    let id : String?
    let iso3 : String?
    let name : String?
    let nativeField : String?
    let phonecode : String?
    let referralReward : String?
    let region : String?
    let shortName : String?
    let subregion : String?
    let updatedAt : String?
    let wikiDataId : String?


    enum CodingKeys: String, CodingKey {
        case active = "active"
        case capital = "capital"
        case createdAt = "created_at"
        case currency = "currency"
        case emoji = "emoji"
        case emojiU = "emojiU"
        case flag = "flag"
        case id = "id"
        case iso3 = "iso3"
        case name = "name"
        case nativeField = "native"
        case phonecode = "phonecode"
        case referralReward = "referral_reward"
        case region = "region"
        case shortName = "short_name"
        case subregion = "subregion"
        case updatedAt = "updated_at"
        case wikiDataId = "wikiDataId"
    }
}

struct PushNotificationModel : Codable {

    let comments : String?
    let directMessages : String?
    let id : String?
    let likes : String?
    let mentions : String?
    let newFollowers : String?
    let videoUpdates : String?


    enum CodingKeys: String, CodingKey {
        case comments = "comments"
        case directMessages = "direct_messages"
        case id = "id"
        case likes = "likes"
        case mentions = "mentions"
        case newFollowers = "new_followers"
        case videoUpdates = "video_updates"
    }
}


struct PrivacySettingModel : Codable {

    let directMessage : String?
    let duet : String?
    let id : String?
    let likedVideos : String?
    let videoComment : String?
    let videosDownload : String?


    enum CodingKeys: String, CodingKey {
        case directMessage = "direct_message"
        case duet = "duet"
        case id = "id"
        case likedVideos = "liked_videos"
        case videoComment = "video_comment"
        case videosDownload = "videos_download"
    }
}
