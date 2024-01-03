//
//  SpacesCollectionViewCell.swift
//  SmashVideos
//
//  Created by Mac on 06/04/2023.
//

import UIKit
import Lottie
class SpacesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - VARS
    var musicAnimationView : LottieAnimationView!
    
    //MARK: - OUTLET
    
    @IBOutlet weak var animationView: UIView!
    
    @IBOutlet weak var lblMainLive: UILabel!
    
    @IBOutlet weak var lblListener: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    
    @IBOutlet weak var imgProfile: CustomImageView!
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var imgHost: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    //MARK: - AWAKE FROM NIB
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    //MARK: - FUNCTION
    func music(){
        
        musicAnimationView = .init(name: "music")
        
        musicAnimationView.animationSpeed = 0.5
        
        musicAnimationView.contentMode = .scaleAspectFit
        musicAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView.addSubview(musicAnimationView)
        
        musicAnimationView.centerXAnchor.constraint(equalTo: animationView.centerXAnchor).isActive = true
        musicAnimationView.centerYAnchor.constraint(equalTo: animationView.centerYAnchor).isActive = true
        musicAnimationView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        musicAnimationView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        musicAnimationView?.play(fromFrame: 0, toFrame: 60, loopMode: .loop, completion: { (bol) in
        })
       
        
    }

}
