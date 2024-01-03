//
//  ShowSoundModel.swift
//  WOOW
//
//  Created by Zubair Ahmed on 07/10/2022.
//

import Foundation

struct ShowSoundModel : Codable {

    let trending : [Trending]?
    let viral : [Trending]?
    let code : Int?
    let msg : [SoundMsgArray]?


    enum CodingKeys: String, CodingKey {
        case trending = "Trending"
        case viral = "Viral"
        case code = "code"
        case msg = "msg"
    }
}
struct SoundMsgArray : Codable {

    let sound : [Sounds]?
    let soundSection : SoundSections?


    enum CodingKeys: String, CodingKey {
        case sound = "Sound"
        case soundSection = "SoundSection"
    }
}

struct SoundSections : Codable {

    let id : String?
    let name : String?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct Trending : Codable {

    let sound : Sounds?


    enum CodingKeys: String, CodingKey {
        case sound = "Sound"
    }
}

struct Sounds : Codable {

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
    let soundExtractedFromVideo : String?
    let soundSectionId : String?
    let thum : String?
    let totalVideos : Int?
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
        case soundExtractedFromVideo = "sound_extracted_from_video"
        case soundSectionId = "sound_section_id"
        case thum = "thum"
        case totalVideos = "total_videos"
        case uploadedBy = "uploaded_by"
        case userId = "user_id"
    }
}

// ShowSoundsAgainest section

struct SoundSectionModel : Codable {

    let code : Int?
    let msg : [SoundSectionArray]?


    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}
struct SoundSectionArray : Codable {

    let sound : Sounds?


    enum CodingKeys: String, CodingKey {
        case sound = "Sound"
    }
}
