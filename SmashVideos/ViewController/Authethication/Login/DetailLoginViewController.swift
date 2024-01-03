//
//  DetailLoginViewController.swift
//  Binder
//
//  Created by Mac on 09/07/2021.
//

import UIKit
import XLPagerTabStrip

class DetailLoginViewController: UIViewController, IndicatorInfoProvider {

    //MARK:- VARS
    
   
    //MARK: Outlets
    
    @IBOutlet weak var viewConPhone: UIView!
    @IBOutlet weak var viewConEmail: UIView!
    var itemInfo:IndicatorInfo = "View"
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if itemInfo.title == "Phone"{
            print("Phone")
            viewConPhone.isHidden = false
            viewConEmail.isHidden = true
        } else if itemInfo.title == "Email"{
            print("Email")
            viewConPhone.isHidden = true
            viewConEmail.isHidden = false
        }
    }
    
    //MARK: pagerTabStripController
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {

        return itemInfo
    }


}
