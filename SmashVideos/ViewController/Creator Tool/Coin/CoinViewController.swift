//
//  CoinViewController.swift
//  DubiDabi
//
//  Created by Mac on 17/05/2023.
//

import UIKit

class CoinViewController: UIViewController {
    
    //MARK: - VARS
    var audience = ""
    var goal = ""
    var budgeCoin = ""
    var Durationdays = ""
    var videoViews = ""
    var price_ = 0.0
    
    var days = 0
    var price = 0
    var totalPrice = 0.0
    var label: UILabel!
    var label1: UILabel!
    var video_views = 0.0
    var imageView: UIImageView!
    
    var tag = 0
    
    
    var actionButton = ""
    var websiteUrl = ""
    
    //MARK: - OUTLET
    
    @IBOutlet var lblEsti: UILabel!
    
    
    @IBOutlet weak var lblSpend: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var budgetslider: UISlider!
    
    @IBOutlet weak var durationSlider: UISlider!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAddData()
        
        label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label.textAlignment = .center
        view.addSubview(label)
        label1 = UILabel()
        label1.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        label1.textAlignment = .center
        view.addSubview(label1)
        
        imageView = UIImageView(image: UIImage(named: "ic_coin"))
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        if self.tag == 0 {
            self.lblEsti.text = "Estimated video views"
        }else if self.tag == 1{
            self.lblEsti.text = "Estimated website visits"
        }else{
            self.lblEsti.text = "Estimated followers"
        }
        
        
    }
   
    
    
    //MARK: - API
    
    func showAddData(){
        
        ApiHandler.sharedInstance.showAddSettings(user_id: UserDefaultsManager.shared.user_id) { (isSuccess, response) in
            if isSuccess{
                
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let msg = response?.value(forKey: "msg") as! NSDictionary
                    
                    if self.tag == 0{
                        let videoView = msg.value(forKey: "video_views") as! NSNumber
                      
                        self.video_views = videoView.doubleValue
                       
                    }else if self.tag == 1 {
                        
                        let videoView = msg.value(forKey: "website_visits") as! NSNumber
                      
                        self.video_views = videoView.doubleValue
                        
                    }else{
                        
                        let videoView = msg.value(forKey: "followers") as! NSNumber

                        self.video_views = videoView.doubleValue
                        
                    }
                   
                    
                  
                    
                   
                }else{
                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    
                }
            }else{
                
            }
            
        }
        
    }
    

    //MARK: - SLIDER ACTION
    @IBAction func budgetDuraSliderValueChanged(_ sender: UISlider) {
        print("view_view",video_views)
        if sender.tag == 0{
            self.price = Int(sender.value)
            self.totalPrice = Double(price * days)
            self.price_ = totalPrice
            if price == 0  {
                self.lblSpend.text = "\(Int(self.totalPrice)) coin spent over \(days) days"
            }else if days == 0 {
                self.lblSpend.text = "\(Int(self.totalPrice)) coins spent over \(days) day"
            }else{
                self.lblSpend.text = "\(Int(self.totalPrice)) coins spent over \(days) days"
            }
            
            let thumbRect = budgetslider.thumbRect(forBounds: budgetslider.bounds, trackRect: budgetslider.trackRect(forBounds: budgetslider.bounds), value: budgetslider.value)
            let labelOrigin = CGPoint(x: thumbRect.origin.x + budgetslider.frame.origin.x, y: budgetslider.frame.origin.y + 65)
            label.frame.origin = labelOrigin
            
            let imageOrigin = CGPoint(x: thumbRect.origin.x + budgetslider.frame.origin.x - 17 , y: budgetslider.frame.origin.y + 70)
            imageView.frame.origin = imageOrigin
            
            
            label.text = "\(price) per day"
            
            self.totalPrice *= video_views
            
            self.lblPrice.text = "\(Int(self.totalPrice)) +"
            
            self.budgeCoin = "\(sender.value)"
           
            self.videoViews = self.lblPrice.text!
           
        }else{
            
            self.days = Int(sender.value)
            self.totalPrice = Double(price * days)
            self.price_ = totalPrice
            if price == 0  {
                self.lblSpend.text = "\(Int(self.totalPrice)) coin spent over \(days) days"
            }else if days == 0 {
                self.lblSpend.text = "\(Int(self.totalPrice)) coins spent over \(days) day"
            }else{
                self.lblSpend.text = "\(Int(self.totalPrice)) coins spent over \(days) days"
            }
            
            let thumbRect = durationSlider.thumbRect(forBounds: durationSlider.bounds, trackRect: durationSlider.trackRect(forBounds: durationSlider.bounds), value: durationSlider.value)
            let labelOrigin = CGPoint(x: thumbRect.origin.x + durationSlider.frame.origin.x, y: durationSlider.frame.origin.y + 65)
            label1.frame.origin = labelOrigin
            
            label1.text = "\(days) days"
            
            self.totalPrice *= video_views
            self.lblPrice.text = "\(Int(self.totalPrice)) +"
            self.videoViews = self.lblPrice.text!
        }
        
        self.Durationdays = "\(sender.value)"
        
        if days == 0 || price == 0{
            self.btnNext.alpha = 0.5
            
        }else{
            self.btnNext.alpha = 1
           
        }
    }
    
    
    //MARK: - BUTTON ACTION
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if days == 0 || price == 0{
            
        }else{
            print("price_",Int(self.price_))
             let myViewController = SelectVideoViewController(nibName: "SelectVideoViewController", bundle: nil)
             myViewController.goal = goal
             myViewController.Durationdays = "\(days)"
             myViewController.budgeCoin = "\(Int(price_))"
             myViewController.audience = audience
             myViewController.videoViews = videoViews
            myViewController.actionButton = actionButton
            myViewController.websiteUrl = websiteUrl

             self.navigationController?.pushViewController(myViewController, animated: true)
            
        }
       
            
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
