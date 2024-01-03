//
//  AddPromotionM.swift
//  SmashVideos
//
//  Created by Mac on 28/07/2023.
//

import Foundation


// MARK: - AddPromotionM
struct AddPromotionM: Codable {
    let code: Int?
    let msg: AddPromotionObject?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}

// MARK: - Msg
struct AddPromotionObject: Codable {
    let promotion: Promotion?
    let user: Users?
    let video: Videoed?
    let audience: Audience?

    enum CodingKeys: String, CodingKey {
        case promotion = "Promotion"
        case user = "User"
        case video = "Video"
        case audience = "Audience"
    }
}

// MARK: - Audience
struct Audience: Codable {
    let id, userID, name, country: String?
    let minAge, maxAge, gender, created: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userID = "user_id"
        case name = "name"
        case country = "country"
        case minAge = "min_age"
        case maxAge = "max_age"
        case gender = "gender"
        case created = "created"
    }
}

// MARK: - Promotion
struct Promotion: Codable {
    let id, userID, websiteURL, startDatetime: String?
    let endDatetime, coin, active, destination: String?
    let actionButton, destinationTap, followers, reach: String?
    let totalReach, clicks, audienceID, paymentCardID: String?
    let created, videoID: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userID = "user_id"
        case websiteURL = "website_url"
        case startDatetime = "start_datetime"
        case endDatetime = "end_datetime"
        case coin = "coin"
        case active = "active"
        case destination = "destination"
        case actionButton = "action_button"
        case destinationTap = "destination_tap"
        case followers = "followers"
        case reach = "reach"
        case totalReach = "total_reach"
        case clicks = "clicks"
        case audienceID = "audience_id"
        case paymentCardID = "payment_card_id"
        case created = "created"
        case videoID = "video_id"
    }
}

