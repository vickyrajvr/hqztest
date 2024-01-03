//
//  GoalViewController.swift
//  SmashVideos
//
//  Created by Mac on 12/03/2023.
//

import UIKit

class GoalViewController: UIViewController {
    
    //MARK: - VARS
    
    var goal = "engagement"
   
    var goalDes = ""
    
    //MARK: - OUTLET
    
    
    @IBOutlet weak var imgEngagement: UIImageView!
    @IBOutlet weak var btnEngagement: UIButton!
    
    @IBOutlet weak var imgWebsite: UIImageView!
    @IBOutlet weak var btnWebsite: UIButton!
    
    @IBOutlet weak var imgfollowers: UIImageView!
    @IBOutlet weak var btnfollowers: UIButton!
    
    
    
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - BUTTON ACTION
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if goal == "engagement"{
            goalDes = "More video views"
            let myViewController = AudienceViewController(nibName: "AudienceViewController", bundle: nil)
            myViewController.goal = goalDes
            myViewController.tag = 0
            self.navigationController?.pushViewController(myViewController, animated: true)
        }else if goal == "website"{
            
            goalDes = "More website visits"
            let myViewController = LandingPageViewController(nibName: "LandingPageViewController", bundle: nil)
            myViewController.goal = goalDes
            myViewController.tag = 1
            self.navigationController?.pushViewController(myViewController, animated: true)
            
        }else {
            goalDes = "More followers"
            let myViewController = AudienceViewController(nibName: "AudienceViewController", bundle: nil)
            myViewController.goal = goalDes
            myViewController.tag = 2
            self.navigationController?.pushViewController(myViewController, animated: true)
        }
        
      
        
     
    }
    
    @IBAction func goalButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            
            imgEngagement.image = UIImage(named: "red circle")
            
            if imgEngagement.image == UIImage(named: "red circle"){
                imgEngagement.tintColor = UIColor(named: "theme")
            }
            
            imgWebsite.image = UIImage(named: "gray_circle")
            imgfollowers.image = UIImage(named: "gray_circle")
            imgWebsite.tintColor = .systemGray4
            imgfollowers.tintColor = .systemGray4
            goal = "engagement"
            
        }else if sender.tag == 1{
            
            imgWebsite.image = UIImage(named: "red circle")
            
            goal = "website"
            imgWebsite.tintColor = UIColor(named: "theme")
            
            imgEngagement.image = UIImage(named: "gray_circle")
            imgfollowers.image = UIImage(named: "gray_circle")
            imgEngagement.tintColor = .systemGray4
            imgfollowers.tintColor = .systemGray4
            
            
        }else {
            imgfollowers.image = UIImage(named: "red circle")
            
            goal = "followers"
            imgfollowers.tintColor = UIColor(named: "theme")
            
            
            imgEngagement.image = UIImage(named: "gray_circle")
            imgWebsite.image = UIImage(named: "gray_circle")
            imgEngagement.tintColor = .systemGray4
            imgWebsite.tintColor = .systemGray4
            
        }
    }
    
    
    
}
