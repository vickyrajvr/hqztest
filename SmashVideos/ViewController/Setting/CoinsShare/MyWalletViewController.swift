//
//  MyWalletViewController.swift
//  Vibez
//
//  Created by Mac on 27/10/2020.
//  Copyright © 2020 Dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import StoreKit
import SwiftyStoreKit


class MyWalletViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver{
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    private var models = [SKProduct]()
    //MARK:- Variables

    var Coin_Name = ""
    var Coin = ""
    var Price = ""
    var userData = [userMVC]()
    //MARK:- Outlets
    @IBOutlet weak var tblGetAllCoins: UITableView!
    @IBOutlet weak var lblTotalCoin: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = false
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(UserDefaultsManager.shared.wallet)
        self.lblTotalCoin.text = UserDefaultsManager.shared.wallet
        
   
    }
    
    //MARK:- Button Action
    
    @IBAction func btnCashout(_ sender: Any) {
        let myViewController = CashOutViewController(nibName: "CashOutViewController", bundle: nil)
        
        
        self.navigationController?.pushViewController(myViewController, animated: true)
    

    }
    @IBAction func btnBackAction(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return models.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
     
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CoinShareCell") as! CoinShareTableViewCell
        let product = models[indexPath.row]
        cell.lblCoin.text = ("\(product.localizedTitle)")
        cell.lblCoinPrice.text = ("\(product.priceLocale.currencySymbol ?? "$")\(product.price)")
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let product_ID = self.getAllCoinValue[indexPath.row]["Product_id"] as! String
//        self.Coin_Name = self.getAllCoinValue[indexPath.row]["coin"] as! String
//        self.Price = self.getAllCoinValue[indexPath.row]["Price"] as! String
        let product = models[indexPath.row]
        let objCoin = product.localizedTitle.components(separatedBy: " ")
        self.Coin = objCoin[0]
        self.Coin_Name = product.localizedTitle
        self.Price = ("\(product.priceLocale.currencySymbol ?? "$")\(product.price)")
        print("Coin",Coin)
        print("Coin_Name",Coin_Name)
        print("Price",Price)
        
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment)
        
       
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 80
    
    }
    
    func Add_Coin_My_Wallet(coin:String,name:String,price:String,TID:String){
        
      
     
        ApiHandler.sharedInstance.purchaseCoin(uid: UserDefaultsManager.shared.user_id, coin: coin, title: name, price: price, transaction_id: TID){ (isSuccess, response)  in
           
            if isSuccess{

                let dic = response as! NSDictionary
                let code = dic["code"] as! Int
                
                if code == 200 {
                    let res =  dic.value(forKey: "msg") as! [String : Any]
                    print("res",res)
                    let coinRes = res["PurchaseCoin"] as? [String:Any]
                    let user = res["User"] as? [String:Any]
                    let user_wallet = user?["wallet"] as? String
                    print("user_wallet",user_wallet)
//                    let coinAdd = coinRes?["coin"] as? String
//                    let add = (coinAdd as! NSString).integerValue + (self.lblTotalCoin.text! as! NSString).integerValue
                    UserDefaultsManager.shared.wallet = user_wallet ?? ""
                    self.lblTotalCoin.text! =  user_wallet ?? ""
                }else {
                   
                   //                print("failed: ",response as Any)
                }
        }
            self.loader.isHidden = true
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
    
    
    //Products
    
    enum Product:String,CaseIterable{
        
        case buy100Coins   = "com.yourcompany.appname.buy100Coins"
        case buy500Coins   = "com.yourcompany.appname.buy500Coins"
        case buy2000Coins  = "com.yourcompany.appname.buy2000Coins"
        case buy5000Coins  = "com.yourcompany.appname.buy5000Coins"
        case buy10000Coins = "com.yourcompany.appname.buy10000Coins"
    }
    
    private func fetchProducts(){
        
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
       
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
       
        DispatchQueue.main.async {
            print("Count: \(response.products.count)")
           // self.models = response.products
            let validProducts = response.products
            //var productsArray = [SKProduct]()
            for i in 0 ..< validProducts.count {
                let product = validProducts[i]
                self.models.append(product)
            }
            self.models.sort{(Double(truncating: $0.price) < Double(truncating: $1.price))}
            self.tblGetAllCoins.reloadData()
            self.loader.isHidden = true
        }
       
       
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
           for transaction in transactions {
               if transaction.error != nil {
                   print("error: \(transaction.error?.localizedDescription)")
                   self.alertModule(title:"Purchase Failed", msg:"Please try again")
               }
               switch transaction.transactionState {
               case .purchasing:
                   print("handle purchasing state")
                   break;
               case .purchased:
                   print("handle purchased state")
                   self.loader.isHidden = false
                   SKPaymentQueue.default().finishTransaction(transaction)
                   
                   print("transaction.transactionIdentifier",transaction.transactionIdentifier!)
        
                   self.Add_Coin_My_Wallet(coin: self.Coin, name: self.Coin_Name, price: self.Price, TID: "\(transaction.transactionIdentifier!)")
                   break;
               case .restored:
                   print("handle restored state")
                   break;
               case .failed:
                   print("handle failed state")
                   SKPaymentQueue.default().finishTransaction(transaction)
                   break;
               case .deferred:
                   print("handle deferred state")
                   break;
               @unknown default:
                   print("Fatal Error");
               }
           }
       }
    
   
}

