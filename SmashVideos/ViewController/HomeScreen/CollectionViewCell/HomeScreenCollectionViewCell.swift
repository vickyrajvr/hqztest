//
//  HomeScreenCollectionViewCell.swift
//  WOOW
//
//  Created by Wasiq Tayyab on 05/06/2022.
//

import UIKit
import GSPlayer
import MarqueeLabel
import DSGradientProgressView
import Lottie
import SnapKit
import SDWebImage
import AVFoundation

class HomeScreenCollectionViewCell: UICollectionViewCell,UITextViewDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var rightView: UIStackView!
    
    @IBOutlet weak var giftView: UIStackView!
    @IBOutlet weak var giftBtn: UIButton!
    
    
    @IBOutlet weak var voteStack: UIStackView!
    @IBOutlet weak var btnLearn: UIButton!
    @IBOutlet weak var btnThumbUp: UIButton!
    @IBOutlet weak var btnDownThumb: UIButton!
    @IBOutlet weak var btnVote: UIButton!
    
    
    @IBOutlet weak var paidStackVie: UIStackView!
    @IBOutlet weak var btnPaidad: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    
    
    
    @IBOutlet weak var saveLabel: UILabel!
    
    @IBOutlet weak var replayLabel: UILabel!
    
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblVideoCount: UILabel!
    
    @IBOutlet weak var btnUsername: UIButton!
    @IBOutlet weak var btnLrike: UIButton!
    @IBOutlet weak var btnLike: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnHashtag: UIImageView!
    @IBOutlet weak var repost_count: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var musicName: MarqueeLabel!
    //    @IBOutlet weak var musicName: MarqueeLabel!
    
//    @IBOutlet weak var musicName: MarqueeLabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var txtDesc: AttrTextView!
    @IBOutlet weak var imgDiscProfile: UIImageView!
    
    
    @IBOutlet weak var videoView: VideoPlayerView!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var imgStar: UIImageView!
    
    @IBOutlet weak var verifiedUserImg: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var heartStackView: UIStackView!
    @IBOutlet weak var commentStackView: UIStackView!
    @IBOutlet weak var shareStackView: UIStackView!
    @IBOutlet weak var retrakeStackView: UIStackView!
    @IBOutlet weak var saveStackView: UIStackView!
    
    @IBOutlet weak var showSoundBtn: UIButton!
    
    
    @IBOutlet weak var btnPlayImg: UIImageView!
    @IBOutlet weak var progressView: DSGradientProgressView!
    @IBOutlet weak var playerCD: UIImageView!
    
    @IBOutlet weak var blackDiskCd: UIImageView!
    
    
    @IBOutlet weak var bottomViewConstant: NSLayoutConstraint!
    
    @IBOutlet weak var progressViewBottomConstr: NSLayoutConstraint!
    

    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet var descriptionStackView: UIStackView!
    
    //ads
    
    @IBOutlet var btnAdsUsername: UIButton!
    @IBOutlet var lblAdsUsername: UILabel!
    
    @IBOutlet var adsDescriptionStackView: UIStackView!
    @IBOutlet var adsBtnStack: UIStackView!
    
    @IBOutlet var adsStackView: UIStackView!
    @IBOutlet var btnAds: UIButton!
    
    @IBOutlet var txtDescAds: AttrTextView!
    
    
    @IBOutlet var verifiedAdsUserImage: UIImageView!
    
    //ads back view
    
    @IBOutlet var adsBackView: UIView!
    @IBOutlet var adsBackImageView: UIImageView!
    
    @IBOutlet var lblAdsName: UILabel!
    
    @IBOutlet var adsTextView: UITextView!
    
    @IBOutlet var adsStackViewUrl: UIStackView!
    
    @IBOutlet var adsBtnUrl: UIButton!
    
    @IBOutlet var btnReplay: UIButton!
    
    private var url: URL!
    
    var heartAnimationView : LottieAnimationView!
    
    var isLiked = false
    var hashtagView : LottieAnimationView!
    var isFavourite = false
    
    var thumImage = ""
   
    private var timeObserver: Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showSoundBtn.setTitle("", for: .normal)
//        self.lblDesc.textContainerInset = UIEdgeInsets.zero
//        self.lblDesc.textContainer.lineFragmentPadding = 0
        txtDesc.delegate = self
        
        btnPlayImg.isHidden = true
        btnProfile.setTitle("", for: .normal)
        videoView.contentMode = .scaleAspectFill
        
        imgUserProfile.makeRounded()
        blackDiskCd.makeRounded()
        
        
        videoView.stateDidChanged = { state in
            switch state {
            case .none:
                print("none")
            case .error(let error):
                
                print("error - \(error.localizedDescription)")
                self.progressView.wait()
                self.progressView.isHidden = false
                
                NotificationCenter.default.post(name: Notification.Name("errInPlay"), object: nil, userInfo: ["err":error.localizedDescription])
                
            case .loading:
                print("loading")
                
                self.progressView.wait()
                self.progressView.isHidden = false
               
            case .paused(let playing, let buffering):
                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
            
                
                self.progressView.signal()
                self.btnPlayImg.isHidden = false
                self.progressView.isHidden = true
                self.playerCD.stopRotating()
                self.blackDiskCd.stopRotating()
          
                
            case .playing:
                
                self.btnPlayImg.isHidden = true
                self.progressView.isHidden = true
                self.playerCD.startRotating()
                self.blackDiskCd.startRotating()
                
                print("playing")
                
            }
        }
        
        print("video Pause Reason: ",videoView.pausedReason )
        
        
        
        
        
    }
    
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoView.isHidden = true
    
    }
    
    
    
    
    func set(url: URL) {
        self.url = url
    }
    
  
    
    func play() {
        videoView.play(for: url )
        
        videoView.isHidden = false
        
        
    }
    
    func pause() {
        videoView.pause(reason: .hidden)
    }
    
    func like(){
        //heartAnimationView.backgroundColor = .clear
        heartAnimationView = .init(name: "heart1")
        //                heartAnimationView?.frame = btnLike.frame
        heartAnimationView.animationSpeed = 1
       
        heartAnimationView.contentMode = .scaleAspectFit
        heartAnimationView.translatesAutoresizingMaskIntoConstraints = false
        self.btnLike.addSubview(heartAnimationView)

        heartAnimationView.centerXAnchor.constraint(equalTo: btnLike.centerXAnchor).isActive = true
        heartAnimationView.centerYAnchor.constraint(equalTo: btnLike.centerYAnchor).isActive = true
        heartAnimationView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        heartAnimationView.widthAnchor.constraint(equalToConstant: 70).isActive = true


        heartAnimationView?.play(fromFrame: 0, toFrame: 60, loopMode: .none, completion: { (bol) in
        })
               
        isLiked = true
        
    }
    func unlike(){
        heartAnimationView?.backgroundColor = .clear
        
        heartAnimationView?.play(fromFrame: 60, toFrame: 0, loopMode: .none, completion: { (bol) in
            self.heartAnimationView?.removeFromSuperview()
        })
        isLiked = false
        
    }
    
    func likeTap(){
       
    }
    
  
    func alreadyLiked(){
        
        heartAnimationView?.removeFromSuperview()
        heartAnimationView?.backgroundColor = .clear
        heartAnimationView = .init(name: "heart1")
        //        heartAnimationView?.frame = btnLike.frame
        
        //        heartAnimationView?.loopMode = .loop
        heartAnimationView?.sizeToFit()
        btnLike.addSubview(heartAnimationView!)
        
        heartAnimationView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnLike)
        })
        //self.heartAnimationView?.removeFromSuperview()
        self.heartAnimationView?.currentFrame = 60
        isLiked = true
        
    }
    
    
    func favourite(){
        //heartAnimationView.backgroundColor = .clear
        hashtagView = .init(name: "bookmark")
        //                heartAnimationView?.frame = btnLike.frame
        hashtagView?.animationSpeed = 1
       
        hashtagView.contentMode = .scaleAspectFit
        hashtagView.translatesAutoresizingMaskIntoConstraints = false
        self.btnHashtag.addSubview(hashtagView)

        hashtagView.centerXAnchor.constraint(equalTo: btnHashtag.centerXAnchor).isActive = true
        hashtagView.centerYAnchor.constraint(equalTo: btnHashtag.centerYAnchor).isActive = true
        hashtagView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hashtagView.widthAnchor.constraint(equalToConstant: 40).isActive = true


        hashtagView?.play(fromFrame: 0, toFrame: 57, loopMode: .none, completion: { (bol) in
        })
               
        isFavourite = true
        
    }
    func unFavourite(){
        hashtagView?.backgroundColor = .clear
        
        hashtagView?.play(fromFrame: 57, toFrame: 0, loopMode: .none, completion: { (bol) in
            self.hashtagView?.removeFromSuperview()
        })
        isFavourite = false
        
    }
    
    func alreadyFavourite(){
        
        hashtagView?.removeFromSuperview()
        hashtagView?.backgroundColor = .clear
        hashtagView = .init(name: "bookmark")
        //        heartAnimationView?.frame = btnLike.frame
        
        //        heartAnimationView?.loopMode = .loop
        hashtagView?.sizeToFit()
        btnHashtag.addSubview(hashtagView!)
        
        hashtagView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnHashtag)
        })
        //self.heartAnimationView?.removeFromSuperview()
        self.hashtagView?.currentFrame = 57
        isFavourite = true
        
    }
    
    
    
}
extension UIImageView {
    
    func makeRounded() {
        
        //        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        //        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
extension UIView {
    func startRotating(duration: Double = 4) {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(M_PI * 1.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    
}
