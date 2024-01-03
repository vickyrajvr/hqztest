//
//  JoinRoomM.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 13/04/2023.
//

import Foundation
// Join Room Model
struct JoinRoomM : Codable {
    
    let code : Int?
    let msg : JoinedRoomsObject?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}

// Leave Room Model
struct LeaveRoomM : Codable {
    
    let code : Int?
    let msg : String?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}

// Delete Room Model
struct DeleteRoomM : Codable {
    
    let code : Int?
    let msg : String?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}


// Add Room Model
struct AddRoomM : Codable {
    
    let code : Int?
    let msg : RoomDetailObj?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}

// roomDetails Object Model
struct ShowRoomDetailM : Codable {
    
    let code : Int?
    let msg : RoomDetailObj?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}
struct RoomDetailObj : Codable {
    
    let room : Room?
    let roomMember : [RoomMember]?
    let topic : Topic?
    
    enum CodingKeys: String, CodingKey {
        case room = "Room"
        case roomMember = "RoomMember"
        case topic = "Topic"
    }
}

// assignModerator Object Model
struct AssignModeratorM : Codable {
    
    let code : Int?
    let msg : AssignModeratorObj?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}

struct AssignModeratorObj : Codable {
    
    let room : Room?
    let roomMember : RoomMember?
    let user : Users?
    
    
    enum CodingKeys: String, CodingKey {
        case room = "Room"
        case roomMember = "RoomMember"
        case user = "User"
    }
}
