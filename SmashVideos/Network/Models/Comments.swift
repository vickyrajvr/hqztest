//
//  Comments.swift
//  Infotex
//
//  Created by Mac on 08/09/2021
//

import Foundation

 struct CommentItem {
   
    var id:String?
    var user_id:String?
    var pic:String?
    var name:String?
    var comment_id: String?
    var comment: String?
    var like:Int?
    var like_count:Int?
    var createDate:String?
    
     init(id:String,user_id:String,name:String,pic:String,comment: String, like:Int,like_count:Int,createDate:String) {
        self.id = id
        self.user_id = user_id
        self.name = name
        self.pic = pic
        self.comment = comment
        self.like = like
        self.like_count = like_count
        self.createDate = createDate
    }
}

 struct Section {
    
    var id:String?
    var user_id:String?
    var name:String?
    var pic:String?
    var video_id:String?
    var comment: String?
    var like:Int?
    var like_count:Int?
    var createDate:String?
    var items: [CommentItem]?
    var collapsed: Bool?
    
    init(id:String,user_id:String,name:String,pic:String,video_id:String,comment: String, like:Int,like_count:Int, items: [CommentItem], collapsed: Bool = true,createDate:String) {
        
        self.id = id
        self.name = name
        self.pic = pic
        self.user_id = user_id
        self.video_id = video_id
        self.comment = comment
        self.like = like
        self.like_count = like_count
        self.items = items
        self.createDate = createDate
        self.collapsed = collapsed
    }
}
