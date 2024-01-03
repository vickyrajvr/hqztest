//
//  MainLoginViewController.swift
//  Binder
//
//  Created by Naqash Ali on 09/07/2021.
//

import UIKit
import XLPagerTabStrip

class MainLoginViewController: ButtonBarPagerTabStripViewController {
    
    //MARK:- VARS
    
    var mainTitle = ""
    
    //MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = mainTitle
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        buttonBarView.selectedBar.backgroundColor = UIColor(named: "theme")
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15)
        
        self.settings.style.selectedBarHeight = 10
        settings.style.buttonBarMinimumLineSpacing = 0
       
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(named: "black")
            newCell?.label.textColor = UIColor(named: "theme")
        }
     
      
    }
    
    
    //MARK: pagerTabStripController
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailLoginViewController") as! DetailLoginViewController
        
        child1.itemInfo = "Phone"

        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailLoginViewController") as! DetailLoginViewController
       
        child2.itemInfo = "Email"

        return [child1,child2]
    }
    
    //MARK: Button actions
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
