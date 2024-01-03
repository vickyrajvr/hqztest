//
//  NewSuggestionViewController.swift
//  Infotex
//
//  Created by Mac on 31/05/2021.
//

import UIKit

class SuggestionViewController: UIViewController {

    //MARK:- Outlets

    @IBOutlet weak var tblSuggestion: UITableView!
    var myUSer:[User]?{didSet{}}

    var arrSuggestion = [[String:Any]]()
    let spinner = UIActivityIndicatorView(style: .white)
    var pageNumber = 0
    var totalPages = 1
    var isDataLoading:Bool = false
    var isFresher = false
    var reciverId = ""

    lazy var refresher: UIRefreshControl = {

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "theme")
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)

        return refreshControl
    }()
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()


    //MARK:- viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblSuggestion.refreshControl =  refresher
        getSuggestionsApi(numberOfPages: "\(self.pageNumber)")

        //TableView footer spinner
        spinner.color = UIColor(named: "theme")
        spinner.hidesWhenStopped = true
        tblSuggestion.tableFooterView = spinner
    }


    //MARK: -  Functions Section
    @objc func requestData() {
        refreshLoader = true
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {

            self.pageNumber = 0
            self.getSuggestionsApi(numberOfPages: "\(self.pageNumber)")
            refreshLoader = false
            self.refresher.endRefreshing()
        }
    }

    @objc func followUser(sender: UIButton) {
        let uid = UserDefaultsManager.shared.user_id
        let indexPath = IndexPath(row:sender.tag, section:0)
        let cell = self.tblSuggestion.cellForRow(at:indexPath) as! ffsTVC
        if uid == "" || uid == nil{
            loginScreenAppear()
        }else{
            followUserFunc(cellNo: sender.tag)
            //
            if sender.currentTitle == "Following"{
                sender.setTitle("Follow", for: .normal)
                sender.backgroundColor = UIColor(named: "theme")
                sender.setTitleColor(UIColor(named: "theme"), for: .normal)
                sender.setTitleColor(.white, for: .normal)
                cell.closeStackView.isHidden = false
            }else{
               
                sender.setTitle("Following", for: .normal)
                sender.backgroundColor = .white
                sender.layer.borderWidth = 1.0
                sender.layer.borderColor = UIColor.systemGray5.cgColor
                sender.setTitleColor(.black, for: .normal)
                cell.closeStackView.isHidden = true
            }
            
        }

    }
    
    
   
    func followRecomdedUser(rcvrID:String,userID:String){
        
        print("Recid: ",rcvrID)
        print("senderID: ",userID)
        
        
        ApiHandler.sharedInstance.followUser(sender_id: userID, receiver_id: rcvrID) { (isSuccess, response) in
            
            if isSuccess {
                
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                }else{
                    
                    //  self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                }
                
            }else{
                
                //self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
            }
        }
    }
    

    @objc func removeUser(sender: UIButton) {
        self.arrSuggestion.remove(at: sender.tag)
        self.tblSuggestion.reloadData()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.myUSer = User.readUserFromArchive()
    }
    //MARK:- API Handler
    func getSuggestionsApi(numberOfPages:String){
        if refreshLoader == false{
            self.loader.isHidden = false
        }
        print("UserDefaultsManager.shared.country_id",UserDefaultsManager.shared.country_id)
        ApiHandler.sharedInstance.showSuggestedUsers(user_id: UserDefaultsManager.shared.user_id, country_id: UserDefaultsManager.shared.country_id) { (isSucces, resp) in
            if isSucces{
                self.loader.isHidden = true
                let code = resp?.value(forKey: "code") as! NSNumber
                if code == 200{

                    if numberOfPages == "0" {
                        self.arrSuggestion.removeAll()
                    }

                    let msgArr = resp?.value(forKey: "msg") as! NSArray

                    for objMsg in msgArr{
                        let dict = objMsg as! NSDictionary
                        let followerDict = dict.value(forKey: "User") as! [String:Any]


                        self.arrSuggestion.append(followerDict)
                    }
                    self.totalPages = self.totalPages + 1

                    refreshLoader =  false
                    self.tblSuggestion.delegate = self
                    self.tblSuggestion.dataSource =  self
                    self.tblSuggestion.reloadData()
                }else{
                    refreshLoader =  false
                    self.totalPages = self.pageNumber

                    self.spinner.hidesWhenStopped = true
                    self.spinner.stopAnimating()
                }
            }else{
                self.loader.isHidden = true
                print(resp)
            }
        }
    }
    
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
  
    func followUserFunc(cellNo:Int){
        let suggUser = self.arrSuggestion[cellNo]
        
        let rcvrID = suggUser["id"] as! String
        let userID = UserDefaultsManager.shared.user_id
        
        self.followRecomdedUser(rcvrID: rcvrID, userID: userID)
    }
    


}

extension SuggestionViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSuggestion.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ffsTVC", for: indexPath) as! ffsTVC

        
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(followUser(sender:)), for: .touchUpInside)
      

        let obj = arrSuggestion[indexPath.row]
        cell.btnBell.tag = indexPath.row
        cell.btnBell.addTarget(self, action: #selector(removeUser(sender:)), for: .touchUpInside)

       

        cell.lblTitle.text = obj["username"] as? String
        cell.lblDescription.text = "\(obj["first_name"] as! String)" + " \(obj["last_name"] as! String)"

        let url = obj["profile_pic"] as! String
        cell.imgIcon.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "noUserImg"))

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyMain = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyMain.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
        vc.hidesBottomBarWhenPushed = true
        let userObj = arrSuggestion[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        vc.otherUserID = userObj["id"] as? String ?? ""
        vc.user_name = userObj["username"] as? String ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
      
    }

}
extension SuggestionViewController {
    //MARK: ScrollView Delegate

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        print("scrollViewWillBeginDragging")
        self.spinner.stopAnimating()
        isDataLoading = false
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        print("scrollViewDidEndDragging")
        if scrollView == self.tblSuggestion{
            if ((tblSuggestion.contentOffset.y + tblSuggestion.frame.size.height) >= tblSuggestion.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    print("Next page call")
                    if self.pageNumber < self.totalPages{
                        self.pageNumber = self.pageNumber + 1
                        refreshLoader =  true
                        spinner.startAnimating()
                        self.getSuggestionsApi(numberOfPages: "\(self.pageNumber)")
                    }
                }
            }
        }
    }


    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            refreshLoader =  false
            self.spinner.hidesWhenStopped = true
            self.spinner.stopAnimating()
        }
    }
}
