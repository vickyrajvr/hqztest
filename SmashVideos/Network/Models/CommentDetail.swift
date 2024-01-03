//
//  CommentDetail.swift
//  Infotex
//
//  Created by Mac on 12/09/2021.
//

import Foundation
import UIKit

class userComments {
    
    static let shared = userComments()
    
    var sections = [Section]()
    var sectionItems = [CommentItem]()
    
    func userCommentDetail(obj:[String:Any])->Section{
                    
            let objComment = obj["VideoComment"] as! [String:Any]
            let objCommentUser = obj["User"] as! [String:Any]
            let objReplyComment = obj["VideoCommentReply"] as! [[String:Any]]
            
            //comments reply
            
            self.sectionItems.removeAll()
            for reply in objReplyComment{
                var name = ""
                var picUrl = ""
                if let user = reply["User"] as? NSDictionary {
                    name = user["username"] as? String ?? " "
                }
                if let objReplyCommentUser = reply["User"] as? [String:Any] {
                    if let username = objReplyCommentUser["username"] as? String {
                        name = username
                        picUrl = objReplyCommentUser["profile_pic"] as? String ?? ""
                    }else {
                        name = "this user does not exits"
                        picUrl = ""
                    }
                }
                
                let items = CommentItem(id: reply["id"] as! String, user_id: reply["user_id"] as! String,name: name,pic: picUrl, comment: reply["comment"] as! String, like: reply["like"] as! Int, like_count: reply["like_count"] as! Int, createDate: reply["created"] as! String)
                
                self.sectionItems.append(items)
            }
            
            self.sections.removeAll()
        let commentSection =  Section(id: objComment["id"] as! String, user_id: objComment["user_id"] as! String,name:objCommentUser["username"] as? String ?? "this user does not exits",pic: objCommentUser["profile_pic"] as? String ?? "", video_id: objComment["video_id"] as? String ?? "0", comment: objComment["comment"] as? String ?? "0", like: objComment["like"] as? Int ?? 0, like_count: objComment["like_count"] as? Int ?? 0,items:self.sectionItems,collapsed: true, createDate: objComment["created"] as! String)
                self.sections.append(commentSection)
        
               return commentSection
    }
}
