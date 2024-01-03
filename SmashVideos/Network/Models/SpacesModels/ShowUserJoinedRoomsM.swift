//
//  ShowUserJoinedRoomsM.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 13/04/2023.
//

import Foundation
struct ShowUserJoinedRoomsM : Codable {
    let code : Int?
    let msg : [JoinedRoomsObject]?


    enum CodingKeys: String, CodingKey {
        case code = "code"
        case msg = "msg"
    }
}
struct JoinedRoomsObject : Codable {
    
    let room : Room?
    let roomMember : RoomMember?
    let user : Users?
    
    
    enum CodingKeys: String, CodingKey {
        case room = "Room"
        case roomMember = "RoomMember"
        case user = "User"
    }
}
