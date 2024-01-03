//
//  CreatorToolsViewController.swift
//  SmashVideos
//
//  Created by Mac on 12/03/2023.
//

import UIKit

class CreatorToolsViewController: UIViewController {
    
    //MARK: - VARS
    
    var creatorArr = [["name":"Analytics","img":"ana"],
                      ["name":"Promote","img":"image-2"]]
    
    var moneArr = [["name":"Promotion History","img":"promo"]]
    
    
    //MARK: - OUTLET
    
    @IBOutlet weak var creatorToolsTableView: UITableView!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorToolsTableView.delegate = self
        creatorToolsTableView.dataSource = self
        
        creatorToolsTableView.register(UINib(nibName: "CreatorToolsTableViewCell", bundle: nil), forCellReuseIdentifier: "CreatorToolsTableViewCell")
        
    }
    
    //MARK: - BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}

//MARK:- EXTENSION TABLE VIEW

extension CreatorToolsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return creatorArr.count
        }else{
            return moneArr.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
   
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatorToolsTableViewCell", for: indexPath)as! CreatorToolsTableViewCell
        
        if indexPath.section == 0 {
            cell.lblCreatorTools.text = creatorArr[indexPath.row]["name"]!
            cell.imgCreatorTools.image = UIImage(named: creatorArr[indexPath.row]["img"]!)
            cell.imgCreatorTools.tintColor = UIColor(named: "darkGrey")
            if indexPath.row == creatorArr.count - 1 {
                cell.lineView.isHidden = false
            }else {
                cell.lineView.isHidden = true
            }
        }else{
            
            cell.lblCreatorTools.text = moneArr[indexPath.row]["name"]!
            cell.imgCreatorTools.image = UIImage(named: moneArr[indexPath.row]["img"]!)
            cell.imgCreatorTools.tintColor = UIColor(named: "darkGrey")
            if indexPath.row == moneArr.count - 1 {
                cell.lineView.isHidden = false
            }else {
                cell.lineView.isHidden = true
            }
            
        }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 1{
                let myViewController = GoalViewController(nibName: "GoalViewController", bundle: nil)
                self.navigationController?.pushViewController(myViewController, animated: true)
            }
        }else{
            
            let myViewController = PromotionsViewController(nibName: "PromotionsViewController", bundle: nil)
            self.navigationController?.pushViewController(myViewController, animated: true)
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // header view
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .white
        
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor(named: "darkGrey")
        } else {
            label.textColor = UIColor(named: "darkGrey")
        }
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        if section == 0{
            label.text = "GENERAL"
        }else{
            label.text = "MONETIZATION"
        }
       
        
        
        
        return headerView
        
        
        
        
    }
    
}
