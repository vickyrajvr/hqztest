//
//  LiveRoomM.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 13/04/2023.
//

import Foundation
struct RootClass : Codable {
    
    let id : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}
