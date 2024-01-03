//
//  LandingPageViewController.swift
//  SmashVideos
//
//  Created by Mac on 28/07/2023.
//

import UIKit

class LandingPageViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: - vars
    var goal = ""
    var tag = 0
    var actionButton = ""
    var userItem = [["title":"Learn More","isSelected":"true"],["title":"Shop now","isSelected":"false"],["title":"Sign up","isSelected":"false"],["title":"Contact us","isSelected":"false"],["title":"Apply now","isSelected":"false"],["title":"Book now","isSelected":"false"]]
    
    
    //MARK: - OUTLET
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var tfUrl: UITextField!
    @IBOutlet var actionCollectionView: UICollectionView!
    
    @IBOutlet var lblError: UILabel!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        actionCollectionView.delegate = self
        actionCollectionView.dataSource = self
        tfUrl.delegate = self
        actionCollectionView.register(UINib(nibName: "LandingPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LandingPageCollectionViewCell")
        
    }
    
    
    //MARK: - FUNCTION
    
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if isValidUrl(url: textField.text!) == true{
            self.lblError.isHidden = true
            self.btnNext.alpha = 1
        }else{
            self.lblError.isHidden = false
            self.lblError.text = "Enter the website URL"
        }
        
    
    }
    
    
    
    //MARK: - BUTTON ACTION
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        
        if tfUrl.text == ""{
            self.showToast(message: "Enter the website URL", font: .systemFont(ofSize: 12.0))
        }else{
            
            let myViewController = AudienceViewController(nibName: "AudienceViewController", bundle: nil)
            myViewController.goal = goal
            myViewController.tag = tag
            myViewController.actionButton = actionButton
            myViewController.websiteUrl = tfUrl.text!
            self.navigationController?.pushViewController(myViewController, animated: true)
            
    
        }
        
    }
    
   
}

//MARK:- EXTENSION FOR COLLECTION VIEW

extension LandingPageViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageCollectionViewCell", for: indexPath)as! LandingPageCollectionViewCell
        cell.lblAction.text = userItem[indexPath.row]["title"]as! String
        
        if indexPath.row == 0 {
            if self.userItem[indexPath.row]["isSelected"] == "false"{
                cell.lblSelected.image = UIImage(named: "gray_circle")
                cell.lblSelected.tintColor = .systemGray4
            }else{
                cell.lblSelected.image = UIImage(named: "red circle")
                cell.lblSelected.tintColor = UIColor(named: "theme")
            }
        }
        
        if indexPath.row == 1 {
            if self.userItem[indexPath.row]["isSelected"] == "false"{
                cell.lblSelected.tintColor = .systemGray4
                cell.lblSelected.image = UIImage(named: "gray_circle")
            }else{
                cell.lblSelected.image = UIImage(named: "red circle")
                cell.lblSelected.tintColor = UIColor(named: "theme")
            }
        }
        if indexPath.row == 2 {
            if self.userItem[indexPath.row]["isSelected"] == "false"{
                cell.lblSelected.tintColor = .systemGray4
                cell.lblSelected.image = UIImage(named: "gray_circle")
            }else{
                cell.lblSelected.image = UIImage(named: "red circle")
                cell.lblSelected.tintColor = UIColor(named: "theme")
            }
        }
        if indexPath.row == 3 {
            if self.userItem[indexPath.row]["isSelected"] == "false"{
                cell.lblSelected.tintColor = .systemGray4
                cell.lblSelected.image = UIImage(named: "gray_circle")
            }else{
                cell.lblSelected.image = UIImage(named: "red circle")
                cell.lblSelected.tintColor = UIColor(named: "theme")
            }
        }
        if indexPath.row == 4 {
            if self.userItem[indexPath.row]["isSelected"] == "false"{
                cell.lblSelected.tintColor = .systemGray4
                cell.lblSelected.image = UIImage(named: "gray_circle")
            }else{
                cell.lblSelected.image = UIImage(named: "red circle")
                cell.lblSelected.tintColor = UIColor(named: "theme")
            }
        }
        
        if indexPath.row == 5 {
            if self.userItem[indexPath.row]["isSelected"] == "false"{
                cell.lblSelected.tintColor = .systemGray4
                cell.lblSelected.image = UIImage(named: "gray_circle")
            }else{
                cell.lblSelected.image = UIImage(named: "red circle")
                cell.lblSelected.tintColor = UIColor(named: "theme")
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.row, section: 0))as! LandingPageCollectionViewCell
        for i in 0..<self.userItem.count {
            var obj  = self.userItem[i]
            obj.updateValue("false", forKey: "isSelected")
            self.userItem.remove(at: i)
            self.userItem.insert(obj, at: i)
            
        }
        
        var obj  =  self.userItem[indexPath.row]
        obj.updateValue("true", forKey: "isSelected")
        self.userItem.remove(at: indexPath.row)
        self.userItem.insert(obj, at: indexPath.row)
        
        self.actionButton = userItem[indexPath.row]["title"]as! String
        print("actionButton",actionButton)
        
        actionCollectionView.reloadData()
        
        
    }
    
    
}

