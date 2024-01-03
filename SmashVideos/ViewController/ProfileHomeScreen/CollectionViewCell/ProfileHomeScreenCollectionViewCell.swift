//
//  ProfileHomeScreenCollectionViewCell.swift
//  SmashVideos
//
//  Created by Mac on 24/01/2023.
//

import UIKit
import GSPlayer
import MarqueeLabel
import DSGradientProgressView
import Lottie
import SnapKit

class ProfileHomeScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var rightView: UIStackView!
    
    
    
    @IBOutlet weak var saveLabel: UILabel!
    
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var btnUsername: UIButton!
    @IBOutlet weak var btnLike: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var lblCommentCount: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnHashtag: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var musicName: MarqueeLabel!
    //    @IBOutlet weak var musicName: MarqueeLabel!
    
    //    @IBOutlet weak var musicName: MarqueeLabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var txtDesc: AttrTextView!
    
    @IBOutlet weak var videoView: VideoPlayerView!
    
    
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
    private var url: URL!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    
    var heartAnimationView : LottieAnimationView!
    
    var isLiked = false
    var hashtagView : LottieAnimationView!
    var isFavourite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showSoundBtn.setTitle("", for: .normal)
        
        
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
        
        heartAnimationView = .init(name: "heart1")
        
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
    
    func alreadyLiked(){
        
        heartAnimationView?.removeFromSuperview()
        heartAnimationView?.backgroundColor = .clear
        heartAnimationView = .init(name: "heart1")
        
        heartAnimationView?.sizeToFit()
        btnLike.addSubview(heartAnimationView!)
        
        heartAnimationView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnLike)
        })
        
        self.heartAnimationView?.currentFrame = 60
        isLiked = true
        
    }
    
    
    func favourite(){
        
        hashtagView = .init(name: "bookmark")
        
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
        
        hashtagView?.sizeToFit()
        btnHashtag.addSubview(hashtagView!)
        
        hashtagView?.snp.makeConstraints({ (mkr) in
            mkr.center.equalTo(btnHashtag)
        })
        
        self.hashtagView?.currentFrame = 57
        isFavourite = true
        
    }
    
    
    
}
