//
//  TotalResultViewController.swift
//  DubiDabi
//
//  Created by Mac on 22/05/2023.
//

import UIKit
import SDWebImage
class TotalResultViewController: UIViewController {
    
    //MARK: - VARS
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
        
        
    }()
    
//    var viewModel = AdViewModel()
    
    var videoID = ""
    var audience = ""
    var startDateTimeString = ""
    var endDateTimeString = ""
    var goal = ""
    var budgeCoin = ""
    var Durationdays = ""
    var img = ""
    var videoViews = ""
    
    var coin = 0
    var totalcoin = 0
    var dayys = 0
    
    
    var destination = ""
    var totalVideoView = ""
    
    
    var actionButton = ""
    var websiteUrl = ""
    
    //MARK: - OUTLET
    
    
    @IBOutlet weak var lblVideoViews: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var lblGoal: UILabel!
    @IBOutlet weak var lblBudgetDura: UILabel!
    @IBOutlet weak var lblAudience: UILabel!
    
    @IBOutlet weak var lblSubtotalCoin: UILabel!
    
    @IBOutlet weak var lblTotalCoins: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    
    @IBOutlet weak var lblFinalTotal: UILabel!
    
    @IBOutlet weak var lblFinalTotalCoin: UILabel!
    
    @IBOutlet weak var btnPay: UIButton!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("goal",goal)
        
        if goal == "More video views"{
            self.destination = "views"
        }else if goal == "More followers"{
            self.destination = "follower"
        }else{
            self.destination = "website"
        }
        setup()


        
    }
    
    //MARK: - FUNCTION
    
    func setup(){
        
        let url = URL(string:(img))
        self.imgVideo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.imgVideo.sd_setImage(with: url, placeholderImage: UIImage(named:"videoPlaceholder"))

        self.lblVideoViews.text = videoViews
        self.lblGoal.text = goal
        self.lblAudience.text = audience
        self.lblBudgetDura.text = budgeCoin + " | " + Durationdays + " days"
        self.lblSubtotalCoin.text = budgeCoin

        
        let videoViewsArr = videoViews.components(separatedBy: " ")

        totalVideoView = videoViewsArr[0]
        print("totalVideoView",totalVideoView)
        
        
        if let parsedInt = stringToInt(UserDefaultsManager.shared.wallet) {
            self.totalcoin = parsedInt
            print("String to Integer: \(totalcoin)")
            
        } else {
            print("Invalid input. Cannot convert string to integer.")
        }
        
        if let parsedCoinInt = stringToInt(budgeCoin) {
            self.coin = parsedCoinInt
            print("String to Integer: \(coin)")
            
        } else {
            print("Invalid input. Cannot convert string to integer.")
        }
        
        if let days = stringToInt(Durationdays) {
            self.dayys = days
            print("String to Integer: \(days)")
            
        } else {
            print("Invalid input. Cannot convert string to integer.")
        }
        
       
        
        
        if coin > totalcoin{
            self.btnPay.setTitle("Recharge", for: .normal)
            self.btnPay.tag = 0
            self.lblTotal.text = "Insufficient coins"
            self.lblTotalCoins.text = budgeCoin
            self.lblFinalTotal.text = "Insufficient coins"
            self.lblFinalTotalCoin.text = budgeCoin
        }else{

            self.btnPay.setTitle("PAY AND START PROMOTION", for: .normal)
            self.btnPay.tag = 1
            self.lblTotal.text = "Total"
            self.lblTotalCoins.text = budgeCoin
            self.lblFinalTotal.text = "Total"
            self.lblFinalTotalCoin.text = budgeCoin


        }
        
        if let dateRange = getDateRangeFrom(days: dayys) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            startDateTimeString = dateFormatter.string(from: dateRange.start)
            endDateTimeString = dateFormatter.string(from: dateRange.end)

            print("Start Date: \(startDateTimeString)")
            print("End Date: \(endDateTimeString)")
        } else {
            print("Invalid input. Please provide a valid number of days.")
        }

        
    }
    
    func addPromotion(){
        
        var userID = UserDefaultsManager.shared.user_id
        
        if websiteUrl == "" && actionButton == ""{
            ApiHandler.sharedInstance.addPromotion(isWebsite:false, user_id: userID, video_id: videoID, destination: destination, coin: budgeCoin, audience_id: "0", start_datetime: startDateTimeString, total_reach: totalVideoView, end_datetime: endDateTimeString,action_button:actionButton,website_url:websiteUrl) { isSuccess, response in
                if isSuccess {
                    if response?.value(forKey: "code") as! NSNumber == 200 {
                        
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: CreatorToolsViewController.self) {
                                _ =  self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        
                        
                    }else{
                        
                    }
                }
                
            }
            
        }else{
            ApiHandler.sharedInstance.addPromotion(isWebsite:true, user_id: userID, video_id: videoID, destination: destination, coin: budgeCoin, audience_id: "0", start_datetime: startDateTimeString, total_reach: totalVideoView, end_datetime: endDateTimeString,action_button:actionButton,website_url:websiteUrl) { isSuccess, response in
                if isSuccess {
                    if response?.value(forKey: "code") as! NSNumber == 200 {
                        
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: CreatorToolsViewController.self) {
                                _ =  self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        
                        
                    }else{
                        
                    }
                }
                
            }
            
        }
        
       
    }
//    func addPromotion() {
//
//        if AppUtility!.connected() == false{
//            return
//        }
//
//        let userID = UserDefaultsManager.shared.user_id
//        var parameters = [String : Any]()
//        parameters = [
//
//            "user_id"        : userID,
//            "video_id"       : videoID,
//            "destination"    : destination,
//            "coin"           : budgeCoin,
//            "audience_id"    : "0",
//            "start_datetime" : startDateTimeString,
//            "end_datetime"   : endDateTimeString,
//            "total_reach"    : totalVideoView
//
//
//        ]
//        print(parameters)
//        self.loader.isHidden = false
////        self.isLoading = true
////        AppUtility?.startLoader(view: self.view)
//        viewModel.addPromotionApi(endPoint: "api/\(Endpoint.addPromotion.rawValue)", parameters: parameters) { state in
//            self.loader.isHidden = true
////            self.isLoading = false
//            switch state {
//            case .success:
////                if response?.value(forKey: "code") as! NSNumber == 200 {
//                print("viewModel.AddPromotionM?.code",self.viewModel.AddPromotionM?.code)
//                if self.viewModel.AddPromotionM?.code == 200 {
//
//                    for controller in self.navigationController!.viewControllers as Array {
//                        if controller.isKind(of: CreatorToolsViewController.self) {
//                            _ =  self.navigationController!.popToViewController(controller, animated: true)
//                            break
//                        }
//                    }
//
//                }else{
//
//
//                }
//            case .failure:
//                print("failure")
//            }
//        }
//    }
    
    // Function to convert a string to an integer
    func stringToInt(_ str: String) -> Int? {
        return Int(str)
    }
    
    func getDateRangeFrom(days: Int) -> (start: Date, end: Date)? {
        // Get the current date
        let currentDate = Date()

        // Create a calendar object to perform date calculations
        let calendar = Calendar.current

        // Define the date components to add to the current date
        var dateComponents = DateComponents()
        dateComponents.day = days

        // Calculate the end date by adding the specified number of days to the current date
        guard let endDate = calendar.date(byAdding: dateComponents, to: currentDate) else {
            return nil
        }

        return (start: currentDate, end: endDate)
    }
    
    
    //MARK: - BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    @IBAction func payButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyWalletViewController")as! MyWalletViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
           addPromotion()
            
        }
    }
    

}
