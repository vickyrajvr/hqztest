//
//  CashOutViewController.swift
//  SmashVideos
//
//  Created by Mac on 02/11/2022.
//

import UIKit

class CashOutViewController: UIViewController {

    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    //MARK:- Outlets
    @IBOutlet weak var btnCashOut: UIButton!
    @IBOutlet weak var lblTotalWalletCoins: UILabel!
    @IBOutlet weak var lblTotalCoins: UILabel!
    @IBOutlet weak var lblTotalCash: UILabel!
    
    
    var Wallet:CGFloat = 0.0
    var strprice = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCoinValues()
      
       
        
        self.lblTotalWalletCoins.text! =  UserDefaultsManager.shared.wallet
        self.lblTotalCoins.text! =  UserDefaultsManager.shared.wallet
    }
    
    //MARK:- Button Action
    
  
    
    @IBAction func btnCashOutAction(_ sender: Any) {
        self.Cash_Out_request()
    }
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:-API Handler
    func getCoinValues(){
        
        self.loader.isHidden = false
        
        ApiHandler.sharedInstance.showCoinWorth{ (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                print(response)
                let dic = response as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(code == 200){
                    let res =  dic.value(forKey: "msg") as! [String:Any]
                    let obj = res["CoinWorth"] as! [String:Any]
                    let pr = obj["price"] as! String
                    print("pr",pr)
                    let price = Float((obj["price"] as! String))!
                    let Coinprice = Float(self.lblTotalWalletCoins.text!)
                    print("Coinprice",Coinprice)
                    self.lblTotalCash.text = "$\(price * Coinprice!)"
                    self.strprice = Double(price * Coinprice!)
                    
                    if self.lblTotalCash.text! == "0"{
                        self.btnCashOut.isEnabled =  false
                        self.btnCashOut.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    }else{
                        self.btnCashOut.isEnabled =  true
                        self.btnCashOut.backgroundColor = UIColor(named: "theme")!
                    }
                    
                }else{
                    self.loader.isHidden = true
                    print("failed: ",response as Any)
                }
            }
        }
    }
    //MARK:- Get Wallet
    
    func Cash_Out_request(){
        self.loader.isHidden = false
        
        ApiHandler.sharedInstance.coinWithDrawRequest(user_id:UserDefaultsManager.shared.user_id,amount:Int(self.strprice)){ (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                print(response)
                if response?.value(forKey: "code") as! NSNumber ==  201 {
                    self.alertModule(title:"Error" , msg: response?.value(forKey: "msg") as! String)
                    return 
                }
                UserDefaultsManager.shared.wallet = "0"
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
               
                
            }else{
                self.loader.isHidden = true
                print("failed: ",response as Any)
            }
        }
    }
    
    //MARK:- Alert Controller
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
  
    
}
