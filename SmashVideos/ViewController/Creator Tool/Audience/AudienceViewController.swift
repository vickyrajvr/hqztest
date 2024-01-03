//
//  AudienceViewController.swift
//  SmashVideos
//
//  Created by Mac on 12/03/2023.
//

import UIKit

class AudienceViewController: UIViewController {

    //MARK: - VARS
    
    var isAutomatic = true
    
    var goal = ""
    var audience = ""
    
    var tag = 0
    
    
    var actionButton = ""
    var websiteUrl = ""
   
    
    //MARK: - OUTLET
    
    @IBOutlet weak var lblAudienceDescription: UILabel!
    
    @IBOutlet weak var imgAutomatic: UIImageView!
    @IBOutlet weak var btnAutomatic: UIButton!
    
    @IBOutlet weak var imgCustom: UIImageView!
    @IBOutlet weak var btnCustom: UIButton!
   
    
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblAudienceDescription.text = "Define the audience that you'd like to reach with your promotion.\nYour target location is the same as the location you're posting the video from."
        
    }
    
    //MARK: - BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if isAutomatic == true {
            audience = "Automatic (MusicTok chooses for you)"
            let myViewController = CoinViewController(nibName: "CoinViewController", bundle: nil)
            myViewController.audience = audience
            myViewController.goal = goal
            myViewController.tag = self.tag
            myViewController.actionButton = actionButton
            myViewController.websiteUrl = websiteUrl
            self.navigationController?.pushViewController(myViewController, animated: true)
            
        }else{
            
        }
        
    }
    
    
    @IBAction func goalButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            
            imgAutomatic.image = UIImage(named: "red circle")
            
            if imgAutomatic.image == UIImage(named: "red circle"){
                imgAutomatic.tintColor = UIColor(named: "theme")
            }
            
            imgCustom.image = UIImage(named: "gray_circle")
          
            imgCustom.tintColor = .systemGray4
            self.isAutomatic = true
            
           
            
        }else {
            
            imgCustom.image = UIImage(named: "red circle")
            
            
            imgCustom.tintColor = UIColor(named: "theme")
            
            imgAutomatic.image = UIImage(named: "gray_circle")
           
            imgAutomatic.tintColor = .systemGray4
          
            self.isAutomatic = false
            
        }
    }
    

}
