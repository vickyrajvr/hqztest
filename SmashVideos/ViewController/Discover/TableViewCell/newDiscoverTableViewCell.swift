//
//  newDiscoverTableViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 26/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage
import UIView_Shimmer
@available(iOS 13.0, *)
class newDiscoverTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ShimmeringViewProtocol{
    
    //MARK:- Outlets & VARS
    var arrData = ["night3","night2","night3","night3","night2","night3"]
    @IBOutlet weak var discoverCollectionView: UICollectionView!
    
    @IBOutlet weak var hashName : UILabel!
    @IBOutlet weak var hashNameSub : UILabel!
    @IBOutlet weak var lblVideoCount: UILabel!
    @IBOutlet weak var btnHashtag: UIButton!
    var index = 0
    var hashTagIndexPath: IndexPath?
    var shimmeringAnimatedItems: [UIView] {
            [
                hashName,
                hashNameSub,
                lblVideoCount,
                btnHashtag,
                discoverCollectionView
            ]
        }
    
    var hashtagDataArr = [[String:Any]]()
    var videosObj = [videoMainMVC]()
    
  
    //MARK: CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(5, videosObj.count)
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"newDiscoverCVC" , for: indexPath) as! newDiscoverCollectionViewCell
        
        let vidObj = videosObj[indexPath.row]
        //        cell.img.sd_setImage(with: URL(string:vidObj.videoGIF), placeholderImage: UIImage(named: "videoPlaceholder"))
        cell.lbl.isHidden = true
        cell.img.isHidden = false
        let gifURL : String = (AppUtility?.detectURL(ipString: vidObj.videoGIF))!
        //        let imageURL = UIImage.gifImageWithURL(gifURL)
        //        cell.img.image = imageURL
        
        cell.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img.sd_setImage(with: URL(string:(gifURL)), placeholderImage: UIImage(named:"videoPlaceholder"))
        
        if indexPath.row > 3 {
            
            cell.lbl.isHidden = false
            cell.img.isHidden = true
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          
          return CGSize(width: self.discoverCollectionView.frame.size.width/4, height: 130)

      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(index)
        if indexPath.row == 4 {
          
            if let rootViewController = UIApplication.topViewController() {
                let vc = hashtagsVideoViewController(nibName: "hashtagsVideoViewController", bundle: nil)
                vc.hashtag = hashtagDataArr[hashTagIndexPath!.row]["hashName"] as! String
                vc.hidesBottomBarWhenPushed = true
                rootViewController.navigationController?.isNavigationBarHidden = true
                rootViewController.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            
            if let rootViewController = UIApplication.topViewController() {
                let storyMain = UIStoryboard(name: "Main", bundle: nil)
                let vc =  storyMain.instantiateViewController(withIdentifier: "ProfileHomeScreenViewController") as! ProfileHomeScreenViewController
                vc.discoverVideoArr = videosObj
                vc.indexAt = indexPath
                vc.hidesBottomBarWhenPushed = true
                rootViewController.navigationController?.isNavigationBarHidden = true
                rootViewController.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        print("videosObj.count",videosObj.count)
        print(indexPath.row)
        
    }
   

}
