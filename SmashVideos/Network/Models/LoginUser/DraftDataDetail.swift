//
//  DraftDataDetail.swift
//  Infotex
//
//  Created by Mac on 22/11/2021.

import Foundation
import UIKit

//class DraftDataDetail{
//
//    var myDaftData: [DraftData]? {didSet {}}
//    static let shared = DraftDataDetail() //  singleton object
//
//
//    func Objresponse(response:[String:Any]){
//
//        let data = DraftData()
//        data.mediaURL =  response["mediaURL"] as! String
//        data.soundID =  response["soundID"] as? String ?? "0"
//        data.videoID =  response["videoID"] as? Int ?? 0
//        data.image = response["image"] as? [UIImage] ?? []
//
//        self.myDaftData = DraftData.readDraftDataFromArchive()
//
//        if myDaftData?.count == 0 || self.myDaftData == nil{
//            self.myDaftData = [data]
//            if DraftData.saveDraftDataToArchive(DraftData: self.myDaftData!) {
//                print("One Object in Draft Directory")
//            }
//        }else{
//            self.myDaftData?.append(data)
//            if DraftData.saveDraftDataToArchive(DraftData: self.myDaftData!) {
//                print("Saved multiple Object in Draft Directory")
//            }
//        }
//    }
//}
   
