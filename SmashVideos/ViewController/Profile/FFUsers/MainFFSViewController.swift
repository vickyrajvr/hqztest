//
//  MainFFSViewController.swift
//Infotex
//
//  Created by Mac on 31/05/2021.
//

import UIKit
import XLPagerTabStrip

class MainFFSViewController: ButtonBarPagerTabStripViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    var userData = [userMVC]()
    var SelectedIndex = 0
    var data = ""
    
 //MARK:- ViewDidLoad
    override func viewDidLoad() {
        
        self.settings.style.selectedBarHeight = 3
        self.settings.style.selectedBarBackgroundColor = UIColor(named: "theme")!
        self.settings.style.buttonBarBackgroundColor = .clear
        self.settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        super.viewDidLoad()
        print("data",data)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
        }
       
        self.lblNavigationTitle.text = "@\(userData[0].username)"
//        settings.style.buttonBarBackgroundColor = .white
//        settings.style.buttonBarItemBackgroundColor = .white
//        buttonBarView.selectedBar.backgroundColor = UIColor(named: "theme")
//        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15)
//        settings.style.selectedBarHeight = 2.0
//        self.settings.style.selectedBarHeight = 10
//        settings.style.buttonBarMinimumLineSpacing = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(named: "darkGrey")
            newCell?.label.textColor = UIColor(named: "theme")
        }
    }
   
    //MARK:- pagerTabStripController
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FFsDetailViewController") as! FFsDetailViewController
        child1.infoItem = "Following"
        child1.userData =  self.userData

        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FFsDetailViewController") as! FFsDetailViewController
        child2.infoItem = "Followers"
        child2.userData =  self.userData
        
        let child3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FFsDetailViewController") as! FFsDetailViewController
        child3.infoItem = "Suggestion"
       

        return [child1,child2,child3]
    }

   
    //MARK:- Button actions
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
