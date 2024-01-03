//
//  ShowRegisteredContacts.swift
//  WOOW
//
//  Created by Zubair Ahmed on 30/03/2023.
//

import Foundation
struct ShowRegisteredContactsM : Codable {
    
    let code : Int?
    let msg : [RegisteredContacts]?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}
struct RegisteredContacts : Codable {
    
    let user : Users?
    let video : [Videoed]?
    let videoComment : [VideoComment]?
    let videoCommentReply : [VideoCommentReply]?
    
    let notification : [NotificationM]?
    let privacySetting : PrivacySetting?
    let pushNotification : PushNotification?
    
    //    let videoCommentReply : [String]?
    let videoLike : [VideoLike]?
    
    
    enum CodingKeys: String, CodingKey {
        case notification = "Notification"
        case privacySetting = "PrivacySetting"
        case pushNotification = "PushNotification"
        case user = "User"
        case video = "Video"
        case videoComment = "VideoComment"
        case videoCommentReply = "VideoCommentReply"
        case videoLike = "VideoLike"
    }
}

struct NotificationM : Codable {
    
    let created : String?
    let id : String?
    let read : String?
    let receiverId : String?
    let senderId : String?
    let string : String?
    let type : String?
    let videoId : String?
    
    
    enum CodingKeys: String, CodingKey {
        case created = "created"
        case id = "id"
        case read = "read"
        case receiverId = "receiver_id"
        case senderId = "sender_id"
        case string = "string"
        case type = "type"
        case videoId = "video_id"
    }
}
struct PushNotification : Codable {
    
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

struct PrivacySetting : Codable {
    
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
struct VideoLike : Codable {
    
    let created : String?
    let id : String?
    let userId : String?
    let videoId : String?
    
    
    enum CodingKeys: String, CodingKey {
        case created = "created"
        case id = "id"
        case userId = "user_id"
        case videoId = "video_id"
    }
}
struct VideoCommentReply : Codable {
    
    let user : Users?
    let comment : String?
    let commentId : String?
    let created : String?
    let id : String?
    let like : Int?
    let likeCount : Int?
    let userId : String?
    let videoId : String?
    
    
    enum CodingKeys: String, CodingKey {
        case user = "User"
        case comment = "comment"
        case commentId = "comment_id"
        case created = "created"
        case id = "id"
        case like = "like"
        case likeCount = "like_count"
        case userId = "user_id"
        case videoId = "video_id"
    }
}
