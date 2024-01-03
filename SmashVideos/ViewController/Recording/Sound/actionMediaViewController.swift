
//
//  actionMediaViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 19/08/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import CoreAnimator
//import NextLevel
import AVFoundation
import CoreAnimator
import SnapKit
import Photos
import Player
import GTProgressBar
import MarqueeLabel
import EFInternetIndicator
import KYShutterButton
import YPImagePicker
import CoreMedia
import SceneKit
import ARGear

class actionMediaViewController: UIViewController,InternetStatusIndicable,UIActionSheetDelegate {
    
    
     // MARK: - ARGearSDK properties
    
    var toast_main_position = CGPoint(x: 0, y: 0)

//     private var argConfig: ARGConfig?
//     private var argSession: ARGSession?
//     private var currentFaceFrame: ARGFrame?
//     private var nextFaceFrame: ARGFrame?
     private var preferences: ARGPreferences = ARGPreferences()

     // MARK: - Camera & Scene properties
     private let serialQueue = DispatchQueue(label: "serialQueue")
     private var currentCamera: CameraDeviceWithPosition = .front

//     private var arCamera: ARGCamera!
//     private var arScene: ARGScene!
//     private var arMedia: ARGMedia = ARGMedia()
var isRecording = false
     private lazy var cameraPreviewCALayer = CALayer()

//    @IBOutlet weak var splashView: SplashView!
    @IBOutlet weak var touchLockView: UIView!
    @IBOutlet weak var permissionView: PermissionView!
    @IBOutlet weak var settingView: SettingView!
    @IBOutlet weak var ratioView: RatioView!

    @IBOutlet weak var mainTopFunctionView: MainTopFunctionView!
    @IBOutlet weak var mainBottomFunctionView: MainBottomFunctionView!
    private var argObservers = [NSKeyValueObservation]()
    
    
    
    @IBOutlet weak var btnTalent: UIButton!
    
    
    var internetConnectionIndicator: InternetViewIndicator?
    var secondArr = [["second":"3m","isSelected":"0"],
                     ["second":"60s","isSelected":"0"],
                     ["second":"30s","isSelected":"1"]]
   
    
    
    var isShow = true
    var speed: Double = 1.0
    var outputUrl: URL? = nil
    var progress = 0.0
    //    MARK:- OUTLETS
    
    @IBOutlet weak var speedVideoView: UIView!
    
    @IBOutlet weak var btn1x: UIButton!
    @IBOutlet weak var btn2x: UIButton!
    @IBOutlet weak var btn3x: UIButton!
    
    @IBOutlet weak var videoSecondCollectionView: UICollectionView!
    
    @IBOutlet weak var btnRecordAni: KYShutterButton!
    
    @IBOutlet weak var progressViewOutlet: UIView!
    @IBOutlet weak var masterViewOutlet: UIView!
    
    @IBOutlet weak var previewDoneBtnsViewOutlet: UIView!
    @IBOutlet weak var uploadViewOutlet: UIView!
    
   // @IBOutlet weak var videoViewOutlet: UIView!
    
    @IBOutlet weak var soundsViewOutlet: UIView!
    @IBOutlet weak var soundsLabel: MarqueeLabel!
    
    @IBOutlet weak var flipViewOutlet: UIView!
    @IBOutlet weak var speedViewOutlet: UIView!
    @IBOutlet weak var filterViewOutlet: UIView!
    @IBOutlet weak var beautyViewOutlet: UIView!
    @IBOutlet weak var timerViewOutlet: UIView!
    @IBOutlet weak var flashViewOutlet: UIView!
    
    @IBOutlet weak var btnViewAni: UIView!
    
    @IBOutlet weak var recordViewOutlet: UIView!
    
    @IBOutlet weak var flipIconImgView: UIImageView!
    @IBOutlet weak var speedIconImgView: UIImageView!
    @IBOutlet weak var filterIconImgView: UIImageView!
    @IBOutlet weak var beautyIconImgView: UIImageView!
    @IBOutlet weak var timerIconImgView: UIImageView!
    @IBOutlet weak var flashIconImgView: UIImageView!
    
    @IBOutlet weak var recordIconImgView: UIImageView!
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var btnDoneOutlet: UIButton!
    
    internal var closeButton: UIButton?
    
    @IBOutlet weak var masterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var masterCenterYconstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLineView: UIView!
    internal var longPressGestureRecognizer: UILongPressGestureRecognizer?
    internal var photoTapGestureRecognizer: UITapGestureRecognizer?
    internal var focusTapGestureRecognizer: UITapGestureRecognizer?
    internal var flipDoubleTapGestureRecognizer: UITapGestureRecognizer?
    internal var singleTapRecord: UITapGestureRecognizer?

    
    internal var metadataObjectViews: [UIView]?

    internal var _panStartPoint: CGPoint = .zero
    internal var _panStartZoom: CGFloat = 0.0
    
    internal var previewView: UIView?
    
    var audioPlayer : AVAudioPlayer?
    
    var speedToggleState = 1
    var flashToggleState = 1
    
    var camType = "back"
    //    fileprivate var player = Player()
    
    @IBOutlet weak var progressBar: GTProgressBar!
    
    var videoLengthSec = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        NotificationCenter.default.post(name: Notification.Name("pauseSongNoti"), object: nil)
        self.progressBar.progress = 0
        self.progressBar.isHidden = true
        btnDoneOutlet.isHidden = true
        self.startMonitoringInternet()
//
        videoSecondCollectionView.delegate = self
        videoSecondCollectionView.dataSource = self
//
        self.speedVideoView.isHidden = true
//
//
//        previewDoneBtnsViewOutlet.isHidden = true
//        uploadViewOutlet.isHidden = false
//
//        previewDoneBtnsViewOutlet.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//
//        devicesChecks()
        tapGesturesToViews()
        self.setupARGearConfig()
        setupScene()
        setupCamera()
        setupUI()
        addObservers()

        ratioButtonAction()
        initHelpers()
        self.connectAPI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openBottomView(notification:)), name: Notification.Name("openBottomView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeBottomView(notification:)), name: Notification.Name("closeBottomView"), object: nil)
       
        
    }
    
    
    
    @objc func openBottomView(notification: Notification) {
        self.videoSecondCollectionView.isHidden = true
        self.uploadViewOutlet.isHidden = true
        
    }
    @objc func closeBottomView(notification: Notification) {
        self.videoSecondCollectionView.isHidden = false
        self.uploadViewOutlet.isHidden = false
        
    }
    
    //    MARK:- GESTURES ON VIEWS
    private func tapGesturesToViews(){
                let speedViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.speedViewAction))
                self.speedViewOutlet.addGestureRecognizer(speedViewgesture)
        let flashViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.flashViewAction))
        self.flashViewOutlet.addGestureRecognizer(flashViewgesture)
        soundsViewOutlet.isUserInteractionEnabled = true
        let soundsViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.soundsViewAction))
        self.soundsViewOutlet.addGestureRecognizer(soundsViewgesture)
        uploadViewOutlet.isUserInteractionEnabled = true
        let uploadViewgesture = UITapGestureRecognizer(target: self, action:  #selector(self.uploadViewAction))
        self.uploadViewOutlet.addGestureRecognizer(uploadViewgesture)
    }
   
    @objc func speedViewAction(sender : UITapGestureRecognizer) {
        print("speedView tapped")
        if isShow == true {
            UIView.animate(withDuration: 1.0) {
                self.speedVideoView.isHidden = false
                self.speedIconImgView.image = UIImage(named: "speedOnIcon")
            }
            isShow = false
        }else {
            UIView.animate(withDuration: 1.0) {
                self.speedVideoView.isHidden = true
                self.speedIconImgView.image = UIImage(named: "speedOffIcon")
            }
            isShow = true
        }
        
        //
        //        generalBtnAni(viewName: speedIconImgView)
        //        if speedToggleState == 1 {
        //            speedToggleState = 2
        //
        //        } else {
        //
        //            speedToggleState = 1
        //            speedIconImgView.image = #imageLiteral(resourceName: "speedOnIcon")
        //        }
        //
        
        //        self.endCapture()
        
    }
    
    @objc func beautyViewAction(sender : UITapGestureRecognizer) {
        print("beautyView tapped")
        generalBtnAni(viewName: beautyIconImgView)
    }
    
    @objc func timerViewAction(sender : UITapGestureRecognizer) {
        print("timerView tapped")
        generalBtnAni(viewName: timerIconImgView)
    }
    
    @objc func flashViewAction(sender : UITapGestureRecognizer) {
        print("flashView tapped")
        
        generalBtnAni(viewName: flashIconImgView)
        
        
        if flashToggleState == 1 {
            flashToggleState = 2
            flashIconImgView.image =  UIImage(named: "flashOnIcon") //imageLiteral(resourceName: "flashOnIcon")
            
            //            NextLevel.shared.flashMode = .on
//            NextLevel.shared.flashMode = .on
            // Set torchMode
//            NextLevel.shared.torchMode = .on
            
            
            
        } else {
            
            flashToggleState = 1
            flashIconImgView.image =  UIImage(named: "flashOffIcon") //imageLiteral(resourceName: "flashOffIcon")
//            NextLevel.shared.flashMode = .off
//            NextLevel.shared.torchMode = .off
            
        }
        
    }
    
    @objc func recordViewAction(sender : UITapGestureRecognizer) {
        print("recordView tapped")
        
        UIView.animate(withDuration: 0.6,
                       animations: {
            self.recordIconImgView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.recordIconImgView.layer.cornerRadius = 6
        },
                       completion: { _ in
            print("done")
        })
    }
    
    //    MARK:- SELECT AUDIO ACTION
    @objc func soundsViewAction(sender : UITapGestureRecognizer) {
        print("sounds view tapped")
        //        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "AddSoundViewController") as! AddSoundViewController
        //        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "soundsVC") as! soundsViewController
        let vc = storyboard?.instantiateViewController(withIdentifier: "soundsVC") as! soundsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //    MARK:- ANIMATION
    
    func generalBtnAni(viewName:UIImageView)
    {
        UIView.animate(withDuration: 0.2,
                       animations: {
            viewName.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            viewName.layer.cornerRadius = 6
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.2) {
                viewName.transform = CGAffineTransform.identity
            }
        })
        
    }
    
    
    func soundsMarqueeFunc(){
        
    }
    
    //    MARK:- DEVICE CHECKS
    func devicesChecks(){
        if DeviceType.iPhoneWithHomeButton{
            print("view height ",view.frame.height)
            masterViewHeightConstraint.constant = self.view.frame.height/6.5
            masterCenterYconstraint.constant = self.view.frame.height/30
            masterViewOutlet.layoutIfNeeded()
            masterViewOutlet.layer.cornerRadius = 500
            UIApplication.shared.isStatusBarHidden = true
        }
    }
  
    //    MARK:- VIEWWILL APPEAR
    deinit {
        removeObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.isNavigationBarHidden =  true
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        //        player.asset = nil
        
        runARGSession()
        
                self.btnDoneOutlet.isHidden = true
        switch btnRecordAni.buttonState {
        case .recording:
            btnRecordAni.buttonState = .normal
            progressBar.animateTo(progress: 0.0)
            self.crossBtn.isHidden = false
          //  self.btnDoneOutlet.isHidden = false
        default:
            break
        }
//
        loadAudio()
    }
    
    

    
    //    MARK:- LOAD AUDIO
    func loadAudio(){
        
        if let url = UserDefaults.standard.string(forKey: "url"), let audioUrl = URL(string: url) {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            print("destinationUrl: ",destinationUrl)
            
            audioPlayer?.rate = 1.0;
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                print("loaded audio file")
                //                let nextLevel = NextLevel()
                //                nextLevel.disableAudioInputDevice()
                
                
                let soundName = UserDefaults.standard.string(forKey: "selectedSongName")
                
                soundsLabel.text = soundName
                soundsLabel.type = .continuous
                
            } catch {
                // couldn't load file :(
                print("CouldNot load audio file")
            }
            
            print("audioPlayer?.duration:- ",audioPlayer?.duration)
            
        }
    }
    
    //MARK:- VIEW DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.pause()
        //        audioPlayer.stop()
    }
    
    @IBAction func firstXButtonPressed(_ sender: UIButton) {
        self.btn1x.setTitleColor(.black, for: .normal)
        self.btn2x.setTitleColor(.white, for: .normal)
        self.btn3x.setTitleColor(.white, for: .normal)
        
        self.btn1x.backgroundColor = .white
        self.btn2x.backgroundColor = .clear
        self.btn3x.backgroundColor = .clear
        
    }
    
    @IBAction func secondXButtonPressed(_ sender: UIButton) {
        self.btn1x.setTitleColor(.white, for: .normal)
        self.btn2x.setTitleColor(.black, for: .normal)
        self.btn3x.setTitleColor(.white, for: .normal)
        
        self.btn1x.backgroundColor = .clear
        self.btn2x.backgroundColor = .white
        self.btn3x.backgroundColor = .clear
    }
    
    @IBAction func thirdXButtonPressed(_ sender: UIButton) {
        self.btn1x.setTitleColor(.white, for: .normal)
        self.btn2x.setTitleColor(.white, for: .normal)
        self.btn3x.setTitleColor(.black, for: .normal)
        
        self.btn1x.backgroundColor = .clear
        self.btn2x.backgroundColor = .clear
        self.btn3x.backgroundColor = .white
    }
    
    var resultFileInfo: [AnyHashable : Any] = [:]
   
    
    
    //    MARK:- BUTTON DONE
    @IBAction func btnDone(_ sender: Any) {
        //        sessionDoneFunc()
        
        if let info = self.resultFileInfo as? Dictionary<String, Any> {
          //  self.videoButtonActionFinished(videoInfo: info)
        }
        
        
//        ARGLoading.show()
//        //        button.tag = 0
//        self.mainTopFunctionView.enableButtons()
//
//        self.arMedia.recordVideoStop({ tempFileInfo in
//        }) { resultFileInfo in
//            ARGLoading.hide()
//            if let info = resultFileInfo as? Dictionary<String, Any> {
//                self.videoButtonActionFinished(videoInfo: info)
//            }
//        }
        
    }
    
    
    func sessionDoneFunc() {//
//        guard let session = NextLevel.shared.session, let lastClipUrl = session.lastClipUrl else {
//            return
//        }
        
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "previewPlayerViewController") as! previewPlayerViewController
//        vc.url = lastClipUrl
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
// MARK: - library

extension actionMediaViewController {
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }
    
}

// MARK: - capture

extension actionMediaViewController {
    
    internal func startCapture() {
        
        audioPlayer?.play()
        print("audioPlayer?.currentTime:- ",audioPlayer?.currentTime)
        
        //        NextLevel.shared.automaticallyConfiguresApplicationAudioSession = true
        self.photoTapGestureRecognizer?.isEnabled = false
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            self.recordIconImgView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (completed: Bool) in
        }
//        NextLevel.shared.record()
        self.uploadViewOutlet.isHidden = true
        self.previewDoneBtnsViewOutlet.isHidden = false
    }
    
    internal func pauseCapture() {
        self.audioPlayer?.pause()
//        NextLevel.shared.pause()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.recordIconImgView?.transform = .identity
            
            //            var arrAudioTimes = [String]()
            //
            //            let timeBreak = "\(self.audioPlayer!.currentTime)"
            //            arrAudioTimes.append(timeBreak)
            
        }) { (completed: Bool) in
            
        }
        
    }
    
    internal func endCapture() {
        self.photoTapGestureRecognizer?.isEnabled = true
        self.audioPlayer?.stop()
        
    }
    
    internal func authorizePhotoLibaryIfNecessary() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .restricted:
            fallthrough
        case .denied:
            let alertController = UIAlertController(title: "Oh no!", message: "Access denied.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    
                } else {
                    
                }
            })
            break
        case .authorized:
            break
        @unknown default:
            fatalError("unknown authorization type")
        }
    }
    
}


// MARK: - media utilities

extension actionMediaViewController {
    
    internal func saveVideo(withURL url: URL) {
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            // prompt that the video has been saved
                            let alertController = UIAlertController(title: "Video Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            // prompt that the video has been saved
                            let alertController = UIAlertController(title: "Oops!", message: "Something failed!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            })
    }
    
    internal func savePhoto(photoImage: UIImage) {
        let NextLevelAlbumTitle = "NextLevel"
        
        PHPhotoLibrary.shared().performChanges({
            
            let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: NextLevelAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }
            
        }, completionHandler: { (success1: Bool, error1: Error?) in
            
            if success1 == true {
                if let albumAssetCollection = self.albumAssetCollection(withTitle: NextLevelAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                        let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                        let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                        assetCollectionChangeRequest?.addAssets(enumeration)
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            } else if let _ = error1 {
                print("failure capturing photo from video frame \(String(describing: error1))")
            }
            
        })
    }
    
    
}

// MARK: - UIGestureRecognizerDelegate

extension actionMediaViewController: UIGestureRecognizerDelegate {
    
    @objc internal func handleLongPressGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            //            btnRecordAni.buttonState = .recording
            self.startCapture()
            self._panStartPoint = gestureRecognizer.location(in: self.view)
//            self._panStartZoom = CGFloat(NextLevel.shared.videoZoomFactor)
            break
        case .changed:
            let newPoint = gestureRecognizer.location(in: self.view)
            let scale = (self._panStartPoint.y / newPoint.y)
            let newZoom = (scale * self._panStartZoom)
//            NextLevel.shared.videoZoomFactor = Float(newZoom)
            break
        case .ended:
            fallthrough
        case .cancelled:
            fallthrough
        case .failed:
            self.pauseCapture()
            fallthrough
        default:
            break
        }
    }
}

extension actionMediaViewController {
    
    internal func handlePhotoTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // play system camera shutter sound
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
//        NextLevel.shared.capturePhotoFromVideo()
    }
    
    
    @IBAction func didTapButton(_ sender: KYShutterButton) {
        
        print("btn tapped")
        switch sender.buttonState {
        case .normal:
            sender.buttonState = .recording
            crossBtn.isHidden = true
            btnDoneOutlet.isHidden = true
            startCapture()
        case .recording:
            sender.buttonState = .normal
            crossBtn.isHidden = false
            if progressBar.progress < 0.2 {
                btnDoneOutlet.isHidden = true
                self.crossBtn.isHidden = true
            }else {
                btnDoneOutlet.isHidden = false
                self.crossBtn.isHidden = false
                
            }
          
            pauseCapture()
        }
    }
    
    // MARK:- ACTION SHEET FOR CROSS BUTTON
    func actionSheetFunc(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let startOver: UIAlertAction = UIAlertAction(title: "Start over", style: .default) { action -> Void in
            switch self.btnRecordAni.buttonState {
            case .recording:
                self.btnRecordAni.buttonState = .normal
                self.crossBtn.isHidden = false
                self.btnDoneOutlet.isHidden = true
                
            default:
                self.btnDoneOutlet.isHidden = true
                break
            }
            //            self.endCapture()
            self.progressBar.animateTo(progress: CGFloat(0.0))
//            let session = NextLevel.shared.session
//            session?.reset()
//            session?.removeAllClips()
            self.loadAudio()
            
            self.soundsViewOutlet.isUserInteractionEnabled = true
            print("startOver pressed")
        }
        
        let discard: UIAlertAction = UIAlertAction(title: "Discard", style: .default) { action -> Void in
            
            switch self.btnRecordAni.buttonState {
            case .recording:
                self.btnRecordAni.buttonState = .normal
                self.crossBtn.isHidden = false
                self.btnDoneOutlet.isHidden = true
                
            default:
                break
            }
            //            self.endCapture()
            self.progressBar.animateTo(progress: CGFloat(0.0))
//            let session = NextLevel.shared.session
//            session?.reset()
//            session?.removeAllClips()
            //            self.loadAudio()
            
            self.soundsViewOutlet.isUserInteractionEnabled = true
            print("Discard Action pressed")
            self.tabBarController?.selectedIndex = 0
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        startOver.setValue(UIColor.red, forKey: "titleTextColor")      // add actions
        actionSheetController.addAction(startOver)
        actionSheetController.addAction(discard)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad
        
        actionSheetController.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        
        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    
    @IBAction func cross(_ sender: Any) {
        
        if progressBar.progress <= 0.0{
            self.dismiss(animated: true){
                self.tabBarController?.selectedIndex = 1
            }
        }else{
            actionSheetFunc()
        }
        
    }
}

// MARK: - KVO

private var CameraViewControllerNextLevelCurrentDeviceObserverContext = "CameraViewControllerNextLevelCurrentDeviceObserverContext"

extension actionMediaViewController {
    internal func addKeyValueObservers() {
        self.addObserver(self, forKeyPath: "currentDevice", options: [.new], context: &CameraViewControllerNextLevelCurrentDeviceObserverContext)
    }
    
    internal func removeKeyValueObservers() {
        self.removeObserver(self, forKeyPath: "currentDevice")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CameraViewControllerNextLevelCurrentDeviceObserverContext {
            //self.captureDeviceDidChange()
        }
    }
    
}

//MARK:- VIDEO PICKER FROM LIBRARY
extension actionMediaViewController{
    
    @objc func uploadViewAction(sender : UITapGestureRecognizer) {
        print("upload pressed")
      
        var config = YPImagePickerConfiguration()
        // [Edit configuration here ...]
        // Build a picker with your configuration
        config.video.compression = AVAssetExportPresetHighestQuality
        //        config.video.fileType = .mov
        config.video.recordingTimeLimit = 60.0
        config.video.libraryTimeLimit = 60.0
        config.video.minimumTimeLimit = 3.0
        config.video.trimmerMaxDuration = 60.0
        config.video.trimmerMinDuration = 3.0
        config.showsPhotoFilters = true
        config.screens = [.library, .video]
        config.library.mediaType = .video

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let video = items.singleVideo {
                print("video.fromCamera: ",video.fromCamera)
                print("video.thumbnail: ",video.thumbnail)
                print("video.url: ",video.url)
            }
            picker.dismiss(animated: true) {
                let vc =  self.storyboard?.instantiateViewController(withIdentifier: "previewPlayerViewController") as! previewPlayerViewController

                guard let vidURL = items.singleVideo?.url else {return}

                vc.url = vidURL
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    func convertMinutesToSeconds(minutes: Double) -> TimeInterval {
        return minutes * 60.0
    }
}
//MARK:- EXTENSION FOR COLLECTION VIEW

extension actionMediaViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return secondArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoSecondCollectionViewCell", for: indexPath)as! VideoSecondCollectionViewCell
        
        cell.lblSecond.text = self.secondArr[indexPath.row]["second"]
        cell.backView.isHidden = true
        cell.lblSecond.textColor = .white
        if self.secondArr[indexPath.row]["isSelected"] == "1"{
            cell.backView.isHidden = false
            cell.lblSecond.textColor = .black
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("test")
        for var i in 0 ..< secondArr.count{
            var obj = secondArr[i]
            obj.updateValue("0", forKey: "isSelected")
            secondArr.remove(at: i)
            secondArr.insert(obj, at: i)
        }
        var obj1 = secondArr[indexPath.row]
        obj1.updateValue("1", forKey: "isSelected")
        secondArr.remove(at: indexPath.row)
        secondArr.insert(obj1, at: indexPath.row)
        print("indexPath.row",indexPath.row)
        if indexPath.row == 0 {
            videoLengthSec = convertMinutesToSeconds(minutes: 3.0)
            
            
            
        }else if indexPath.row == 1 {
            videoLengthSec = 60.0
        }else {
            videoLengthSec = 30.0
        }
        
        
          print("videoLengthSec",videoLengthSec)
//          let nextLevel = NextLevel.shared
          let maxDuration = CMTimeMakeWithSeconds(videoLengthSec, preferredTimescale: 1)
//          let videoConfiguration = NextLevelVideoConfiguration()
//          videoConfiguration.maximumCaptureDuration = maxDuration
//          nextLevel.videoConfiguration = videoConfiguration
          
        
        if progressBar.progress <= 0.0{
            
        }else {
            self.btnRecordAni.buttonState = .normal
            self.crossBtn.isHidden = false
            self.btnDoneOutlet.isHidden = true
            self.uploadViewOutlet.isHidden = false
            self.progressBar.animateTo(progress: CGFloat(0.0))
//            let session = NextLevel.shared.session
//            session?.reset()
//            session?.removeAllClips()
            self.loadAudio()
            self.soundsViewOutlet.isUserInteractionEnabled = true
        }
        
        self.videoSecondCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3.0, height: 30)
    }
    
    
}

//
//// MARK: - Argear Functions
extension actionMediaViewController {

    private func initHelpers() {
//        ArGearNetworkManager.shared.argSession = self.argSession
//        BeautyManager.shared.argSession = self.argSession
//        FilterManager.shared.argSession = self.argSession
//        ContentManager.shared.argSession = self.argSession
//        BulgeManager.shared.argSession = self.argSession

        BeautyManager.shared.start()
    }



//    // MARK: - connect argear API
    private func connectAPI() {

        ArGearNetworkManager.shared.connectAPI { (result: Result<[String: Any], APIError>) in
            switch result {
            case .success(let data):
                RealmManager.shared.setARGearData(data) { [weak self] success in
                    guard let self = self else { return }

                    self.loadAPIData()
                }
            case .failure(.network)
                :
                self.loadAPIData()
                break
            case .failure(.data):
                self.loadAPIData()
                break
            case .failure(.serializeJSON):
                self.loadAPIData()
                break
            }
        }
    }

    private func loadAPIData() {
        DispatchQueue.main.async {
            let categories = RealmManager.shared.getCategories()
            print("categories",categories)
            self.mainBottomFunctionView.contentView.contentsCollectionView.contents = categories
            self.mainBottomFunctionView.contentView.contentTitleListScrollView.contents = categories
            self.mainBottomFunctionView.filterView.filterCollectionView.filters = RealmManager.shared.getFilters()
        }
    }


    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopARGSession()
    }
//


    // MARK: - ARGearSDK setupConfig
    private func setupARGearConfig() {
//        do {
//            let config = ARGConfig(
//                apiURL: API_HOST,
//                apiKey: API_KEY1,
//                secretKey: API_SECRET_KEY,
//                authKey: API_AUTH_KEY
//            )
//
//
//            do {
////                self.argSession = try ARGSession(argConfig: config, feature: [.faceMeshTracking])
//            } catch {
//                print("error")
//            }
//
//
////            argSession?.delegate = self
//
////            let debugOption: ARGInferenceDebugOption = self.preferences.showLandmark ? .optionDebugFaceLandmark2D : .optionDebugNON
////            argSession?.inferenceDebugOption = debugOption
//
//        } catch let error as NSError {
//            print("Failed to initialize ARGear Session with error: %@", error.description)
//        } catch let exception as NSException {
//            print("Exception to initialize ARGear Session with error: %@", exception.description)
//        }
    }


    // MARK: - setupScene
    private func setupScene() {
//        arScene = ARGScene(viewContainer: view)
//
//        arScene.sceneRenderUpdateAtTimeHandler = { [weak self] renderer, time in
//            guard let self = self else { return }
//            self.refreshARFrame()
//        }
//
//        arScene.sceneRenderDidRenderSceneHandler = { [weak self] renderer, scene, time in
//            guard let _ = self else { return }
//        }
//
//        cameraPreviewCALayer.contentsGravity = .resizeAspect//.resizeAspectFill
//        cameraPreviewCALayer.frame = CGRect(x: 0, y: 0, width: arScene.sceneView.frame.size.height, height: arScene.sceneView.frame.size.width)
//        cameraPreviewCALayer.contentsScale = UIScreen.main.scale
//        view.layer.insertSublayer(cameraPreviewCALayer, at: 0)
    }

    // MARK: - setupCamera
    private func setupCamera() {
//        arCamera = ARGCamera()
//
//        arCamera.sampleBufferHandler = { [weak self] output, sampleBuffer, connection in
//            guard let self = self else { return }
//
//            self.serialQueue.async {
//
////                self.argSession?.update(sampleBuffer, from: connection)
//            }
//        }
//
//        self.permissionCheck {
//            self.arCamera.startCamera()
//
//            self.setCameraInfo()
//        }
    }

    func setCameraInfo() {

//        if let device = arCamera.cameraDevice, let connection = arCamera.cameraConnection {
//            self.arMedia.setVideoDevice(device)
//            self.arMedia.setVideoDeviceOrientation(connection.videoOrientation)
//            self.arMedia.setVideoConnection(connection)
//        }
//        arMedia.setMediaRatio(arCamera.ratio)
//        arMedia.setVideoBitrate(ARGMediaVideoBitrate(rawValue: self.preferences.videoBitrate) ?? ._4M)
    }

    // MARK: - UI
    private func setupUI() {

        self.mainTopFunctionView.delegate = self
        self.mainBottomFunctionView.delegate = self
        self.settingView.delegate = self

//        self.ratioView.setRatio(arCamera.ratio)
//        self.settingView.setPreferences(autoSave: self.arMedia.autoSave, showLandmark: self.preferences.showLandmark, videoBitrate: self.preferences.videoBitrate)

        toast_main_position = CGPoint(x: self.view.center.x, y: mainBottomFunctionView.frame.origin.y - 24.0)

        ARGLoading.prepare()
    }

    private func startUI() {
        self.setCameraInfo()
        self.touchLock(false)
    }

    private func pauseUI() {
        self.ratioView.blur(true)
        self.touchLock(true)
    }

    func refreshRatio() {
//        let ratio = arCamera.ratio
//
//        self.ratioView.setRatio(ratio)
//        self.mainTopFunctionView.setRatio(ratio)
//
//        self.setCameraPreview(ratio)
//
//      //  self.arMedia.setMediaRatio(ratio)
//    }
//
//    func setCameraPreview(_ ratio: ARGMediaRatio) {
//        self.cameraPreviewCALayer.contentsGravity = (ratio == ._16x9) ? .resizeAspectFill : .resizeAspect
    }

    // MARK: - ARGearSDK Handling
    private func refreshARFrame() {

//        guard self.nextFaceFrame != nil && self.nextFaceFrame != self.currentFaceFrame else { return }
//        self.currentFaceFrame = self.nextFaceFrame
    }

    private func drawARCameraPreview() {

//        guard
////            let frame = self.currentFaceFrame,
////            let pixelBuffer = frame.renderedPixelBuffer
//            else {
//            return
//        }
//
//        var flipTransform = CGAffineTransform(scaleX: -1, y: 1)
//        if self.arCamera.currentCamera == .back {
//            flipTransform = CGAffineTransform(scaleX: 1, y: 1)
//        }
//
//        DispatchQueue.main.async {
//
//            CATransaction.flush()
//            CATransaction.begin()
//            CATransaction.setAnimationDuration(0)
//            if #available(iOS 11.0, *) {
//                self.cameraPreviewCALayer.contents = pixelBuffer
//            } else {
//                self.cameraPreviewCALayer.contents = self.pixelbufferToCGImage(pixelBuffer)
//            }
//            let angleTransform = CGAffineTransform(rotationAngle: .pi/2)
//            let transform = angleTransform.concatenating(flipTransform)
//            self.cameraPreviewCALayer.setAffineTransform(transform)
//            self.cameraPreviewCALayer.frame = CGRect(x: 0, y: -self.getPreviewY(), width: self.cameraPreviewCALayer.frame.size.width, height: self.cameraPreviewCALayer.frame.size.height)
//            self.view.backgroundColor = .white
//            CATransaction.commit()
//        }
    }

    private func getPreviewY() -> CGFloat {
//        let height43: CGFloat = (self.view.frame.width * 4) / 3
//        let height11: CGFloat = self.view.frame.width
        var previewY: CGFloat = 0
//        if self.arCamera.ratio == ._1x1 {
//            previewY = (height43 - height11)/2 + CGFloat(kRatioViewTopBottomAlign11/2)
//        }
//
//        if #available(iOS 11.0, *), self.arCamera.ratio != ._16x9 {
//            if let topInset = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.top {
//                if self.arCamera.ratio == ._1x1 {
//                    previewY += topInset/2
//                } else {
//                    previewY += topInset
//                }
//            }
//        }

        return previewY
    }

    private func pixelbufferToCGImage(_ pixelbuffer: CVPixelBuffer) -> CGImage? {
        let ciimage = CIImage(cvPixelBuffer: pixelbuffer)
        let context = CIContext()
        let cgimage = context.createCGImage(ciimage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelbuffer), height: CVPixelBufferGetHeight(pixelbuffer)))

        return cgimage
    }

    private func runARGSession() {

//        argSession?.run()
    }

    private func stopARGSession() {
//        argSession?.pause()
    }

    func removeSplashAfter(_ sec: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
           // self.splashView.removeFromSuperview()
        }
    }
}
//
//// MARK: - ARGearSDK ARGSession delegate
extension actionMediaViewController : ARGSessionDelegate {

      public func didUpdate(_ arFrame: ARGFrame) {

//        if let splash = self.splashView {
//            splash.removeFromSuperview()
//        }

        self.drawARCameraPreview()

//        for face in arFrame.faces.faceList {
//           if face.isValid {
////            NSLog("landmarkcount = %d", face.landmark.landmarkCount)
//
//            // get face information (landmarkCoordinates , rotation_matrix, translation_vector)
//            // let landmarkcount = face.landmark.landmarkCount
//            // let landmarkCoordinates = face.landmark.landmarkCoordinates
//            // let rotation_matrix = face.rotation_matrix
//            // let translation_vector = face.translation_vector
//
//           }
//        }

//        nextFaceFrame = arFrame

        if #available(iOS 11.0, *) {
        } else {
//            self.arScene.sceneView.sceneTime += 1 // 30
//
//            let lll = self.arScene.sceneView.sceneTime
            
   
        }
    }


}
//
//
//// MARK: - User Interaction
extension actionMediaViewController {
    // Touch Lock Control
    func touchLock(_ lock: Bool) {

        self.touchLockView.isHidden = !lock
        if lock {
            mainTopFunctionView.disableButtons()
        } else {
            mainTopFunctionView.enableButtons()
        }
    }
}
//
//// MARK: - Permission
extension actionMediaViewController {
    func permissionCheck(_ permissionCheckComplete: @escaping PermissionCheckComplete) {

        let permissionLevel = self.permissionView.permission.getPermissionLevel()
        self.permissionView.permission.grantedHandler = permissionCheckComplete
        self.permissionView.setPermissionLevel(permissionLevel)

        switch permissionLevel {
        case .Granted:
            break
        case .Restricted:
            self.removeSplashAfter(1.0)
        case .None:
            self.removeSplashAfter(1.0)
        }
    }
}
//
//// MARK: - Observers
extension actionMediaViewController {

    // MainTopFunctionView
    func addMainTopFunctionViewObservers() {
//        self.argObservers.append(
//            self.arCamera.observe(\.ratio, options: [.new]) { [weak self] obj, _ in
//                guard let self = self else { return }
//
//                self.mainTopFunctionView.setRatio(obj.ratio)
//            }
//        )
    }

    // MainBottomFunctionView
    func addMainBottomFunctionViewObservers() {
//        self.argObservers.append(
//            self.arCamera.observe(\.ratio, options: [.new]) { [weak self] obj, _ in
//                guard let self = self else { return }
//
//                self.mainBottomFunctionView.setRatio(obj.ratio)
//            }
//        )
    }

    // Add
    func addObservers() {
        self.addMainTopFunctionViewObservers()
        self.addMainBottomFunctionViewObservers()
    }

    // Remove
    func removeObservers() {
        self.argObservers.removeAll()
    }
}
//
//// MARK: - Setting Delegate
extension actionMediaViewController: SettingDelegate {
    func autoSaveSwitchAction(_ sender: UISwitch) {
//        self.arMedia.autoSave = sender.isOn
    }

    func faceLandmarkSwitchAction(_ sender: UISwitch) {
        self.preferences.setShowLandmark(sender.isOn)

//        if let session = self.argSession {
//            let debugOption: ARGInferenceDebugOption = sender.isOn ? .optionDebugFaceLandmark2D : .optionDebugNON
//            session.inferenceDebugOption = debugOption
//        }
    }

    func bitrateSegmentedControlAction(_ sender: UISegmentedControl) {
//        self.preferences.setVideoBitrate(sender.selectedSegmentIndex)
//        self.arMedia.setVideoBitrate(ARGMediaVideoBitrate(rawValue: sender.selectedSegmentIndex) ?? ._4M)
    }
}
//
//// MARK: - MainTopFunction Delegate
extension actionMediaViewController: MainTopFunctionDelegate {

    func settingButtonAction() {
        self.settingView.open()
    }

    func ratioButtonAction() {
//        guard
//            let session = argSession
//            else { return }
//
//        self.pauseUI()
//        session.pause()
//
//        self.arCamera.changeCameraRatio {
//
//            self.startUI()
//            self.refreshRatio()
//            session.run()
//        }
    }

    func toggleButtonAction() {
//        guard
//            let session = argSession
//            else { return }
//
//        self.pauseUI()
//        session.pause()
//
//        arCamera.toggleCamera {
//
//            self.startUI()
//            self.refreshRatio()
//            session.run()
        }
    }
//
//// MARK: - MainBottomFunction Delegate
extension actionMediaViewController: MainBottomFunctionDelegate {
    func photoButtonAction(_ button: UIButton) {
//        self.arMedia.takePic { image in
//            self.photoButtonActionFinished(image: image)
//        }
    }

    func videoButtonAction(_ button: UIButton) {
        if isRecording == true {
            
        }else {
            
        }
        if button.tag == 0 {
            // start record
            isRecording = true
            button.tag = 1
            self.mainTopFunctionView.disableButtons()
            self.audioPlayer?.play()
            self.audioPlayer?.numberOfLoops = -1
//            self.arMedia.recordVideoStart { [weak self] recTime in
//                guard let self = self else { return }
//
//                DispatchQueue.main.async {
//                    self.mainBottomFunctionView.setRecordTime(Float(recTime))
//                    print("recTime  : \(recTime)") //
//                    let t = Double(recTime)
//
//                    let min1: Double = Double(t / 60 * 60)
//                    let sec1: Double = Double(t) - min1 * 60
//
//                    let ss = String(format: "%02d:%02d", min1, sec1)
//
//                    let ss1 = Double(String(format: "%02d", sec1))
//
//                    let aString: Double = Double(String(format: "%.0f", Float(recTime))) ?? 0.0 // "1"
//
//                    print("secccccccccc ",aString)
//
//                    let currentProgress = (aString / self.videoLengthSec).clamped(to: 0...1)
//
//                    self.progressBar.animateTo(progress: CGFloat(currentProgress)) {
//                        print("progress done at2:- ",currentProgress)
//                                  self.progressBar.barFillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                       // colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                    }
//
////
////                    let time = Float(recTime)
////                    let min: Int = Int(time / 60)
////                    let sec: Int = Int(time) - min * 60
////
////                    let currentProgress = (sec / Int(self.videoLengthSec)).clamped(to: 0...1)
////
////                                self.progressBar.animateTo(progress: CGFloat(currentProgress)) {
////                                    print("progress done at:- ",currentProgress)
////                                                self.progressBar.barFillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
////                                }
////
////
////
////                        //
//                                if currentProgress == 0.9 {
////                        //            //            sessionDoneFunc()
////                        //            //            nextLevel.stop()
////                        //          //  pauseCapture()
////                        //            btnRecordAni.buttonState = .normal
//                                    self.btnDoneOutlet.isHidden = false
//                                }
////
//
//                    if currentProgress == 1.0{
//                        self.pauseCapture()
////                                    btnRecordAni.buttonState = .normal
//                        self.btnDoneOutlet.isHidden = false
//                        ARGLoading.show()
//                        self.audioPlayer?.stop()
//                        button.tag = 0
//                        self.mainTopFunctionView.enableButtons()
//                        self.arMedia.recordVideoStop({ tempFileInfo in
//                        }) { resultFileInfo in
//                            ARGLoading.hide()
//                            self.resultFileInfo = resultFileInfo
//
//
//                            if let info = resultFileInfo as? Dictionary<String, Any> {
//                               // self.videoButtonActionFinished(videoInfo: info)
//                            }
//                        }
//
//                                }
////
//                    if currentProgress > 0.0 {
////                                    soundsViewOutlet.isUserInteractionEnabled = false
//                                }
//
//                }
//            }
        } else {
            // stop record
            self.audioPlayer?.stop()
            ARGLoading.show()
            button.tag = 0
            self.mainTopFunctionView.enableButtons()
//            self.arMedia.recordVideoStop({ tempFileInfo in
//            }) { resultFileInfo in
//                ARGLoading.hide()
//                if let info = resultFileInfo as? Dictionary<String, Any> {
//                  //  self.videoButtonActionFinished(videoInfo: info)
//                }
//            }
        }
    }

    func photoButtonActionFinished(image: UIImage?) {
        guard let saveImage = image else { return }

//        self.arMedia.save(saveImage, saved: {
//            self.view.showToast(message: "photo_video_saved_message".localized(), position: self.toast_main_position)
//        }) {
//            self.goPreview(content: saveImage)
//        }
    }

    func videoButtonActionFinished(videoInfo: Dictionary<String, Any>?) {
        guard let info = videoInfo else { return }

//        self.arMedia.saveVideo(info, saved: {
//            self.view.showToast(message: "photo_video_saved_message".localized(), position: self.toast_main_position)
//        }) {
//            self.goPreview(content: info)
//        }
    }

    func goPreview(content: Any) {
        
        if let image = content as? UIImage {
            
        } else if let videoInfo = content as? [String: Any] {
            
            let videoPathKey = "filePath"
            
            let videoInfo1 = content as? [String: Any]
            
            guard let videoInfo = videoInfo1, let videoPath = videoInfo[videoPathKey] as? URL
                else { return }
          
            
            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "previewPlayerViewController") as! previewPlayerViewController
            vc.url = videoPath // lastClipUrl
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
//        self.performSegue(withIdentifier: "toPreviewSegue", sender: content)
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

 
