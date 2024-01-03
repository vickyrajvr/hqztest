//
//  FFsDetailViewController.swift
//  Infotex
//
//  Created by Mac on 31/05/2021.
//

import UIKit
import XLPagerTabStrip

class FFsDetailViewController: UIViewController,IndicatorInfoProvider {

    //MARK:- Outlets
    
    @IBOutlet weak var viewFollowing: UIView!
    @IBOutlet weak var viewFollowers: UIView!
    @IBOutlet weak var viewSuggestion: UIView!
    var infoItem:IndicatorInfo = "view"
    var selectedIndex =  1
    
    var userData = [userMVC]()

    
    //MARK:- API Handler
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:-ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        if infoItem.title == "Suggestion" {
            
            if infoItem.title == "Following"{
                print("Following")
                
                viewFollowing.isHidden = false
                viewFollowers.isHidden = true
                viewSuggestion.isHidden =  true
                
            } else if infoItem.title == "Followers"{
                print("Followers")
                viewFollowing.isHidden = true
                viewFollowers.isHidden = false
                viewSuggestion.isHidden =  true
               
            }else if infoItem.title == "Suggestion"{
                viewFollowing.isHidden = true
                viewFollowers.isHidden = true
                viewSuggestion.isHidden =  false
               
            }
            
        }else{
            
            if infoItem.title == "Following" || infoItem.title == "Following \(userData[0].following)" {
                print("Following")
                
                viewFollowing.isHidden = false
                viewFollowers.isHidden = true
                viewSuggestion.isHidden =  true
                
            } else if infoItem.title == "Followers" || infoItem.title == "Followers \(userData[0].followers)"{
                print("Followers")
                viewFollowing.isHidden = true
                viewFollowers.isHidden = false
                viewSuggestion.isHidden =  true
               
            }else if infoItem.title == "Suggestion"{
                viewFollowing.isHidden = true
                viewFollowers.isHidden = true
                viewSuggestion.isHidden =  false
               
            }
            
        }

           
    }
   
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        
        if infoItem.title == "Following"{
            print("Following")
            infoItem.title = "Following \(userData[0].following)"

        } else if infoItem.title == "Followers"{
            print("Followers")
            infoItem.title = "Followers \(userData[0].followers)"

        }else if infoItem.title == "Suggestion"{
            print("Suggestion")
            infoItem.title = "Suggestion"

        }
        return infoItem
    }
    
    

}
