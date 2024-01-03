//
//  SwtichAccountViewController.swift
//  SmashVideos
//
//  Created by Murali karthick Rama Krishnan on 29/12/23.
//

import UIKit

class SwtichAccountViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 15
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        closeBtn.addTarget(self, action: #selector(Closetap), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func Closetap(){
        self.navigationController?.dismiss(animated: true)
    }

}
