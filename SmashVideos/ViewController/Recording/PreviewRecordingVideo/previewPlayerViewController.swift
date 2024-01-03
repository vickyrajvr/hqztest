import UIKit
import Alamofire
import GSPlayer
import DSGradientProgressView
import AVFoundation
import CoreImage
import NextLevel

class previewPlayerViewController: UIViewController{
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var playerView: VideoPlayerView!
    @IBOutlet weak var progressView: DSGradientProgressView!
    @IBOutlet weak var btnPlayImg: UIImageView!
    @IBOutlet weak var filterView: UIView!
    fileprivate var avVideoComposition: AVVideoComposition!
    fileprivate var playerItem: AVPlayerItem!
    fileprivate var video: AVURLAsset?
    fileprivate var originalImage: UIImage?
    var url:URL?
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    
    
    internal let filterNameList = [
        "CIColorControls",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
       
        
        "CIColorClamp",
        "CIColorMatrix",
        "CIColorPolynomial",
        "CIExposureAdjust",
        "CIGammaAdjust",
        "CIHueAdjust",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear",
        "CITemperatureAndTint",
        "CIToneCurve",
        "CIVibrance",
        "CIWhitePointAdjust"
    
    ]
    
    internal let filterDisplayNameList = [
        "Normal",
        "Chrome",
        "Fade",
        "Instant",
        "Mono",
        "Noir",
        "Process",
        "Tonal",
        "Transfer",
        "Tone",
        "Linear",
        
        "Clamp",
        "Matrix",
        "Polynomial",
        "Exposure",
        "Gamma",
        "Hue",
        "SRGBTone",
        "Curve",
        "Temperature",
        "Vibrance",
        "WhitePoint"
    ]
    
    //Filters

    @IBOutlet var collectionView: UICollectionView!
    internal var image: UIImage?
    internal var smallImage: UIImage?
    var filterImages = [UIImage]()
    internal var filterIndex = 0
    internal let context = CIContext(options: nil)
    
    //MARK:-ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.collectionView.register(FilterVideoCollectionViewCell.self, forCellWithReuseIdentifier: "FilterVideoCollectionViewCell")
        self.collectionView.register(UINib.init(nibName: "FilterVideoCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "FilterVideoCollectionViewCell")
        
//        playerView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        playerView.addGestureRecognizer(tap)
        
        playerSetup()
        
        for var i in 0..<self.filterNameList.count{
            self.filterImages.append(self.createFilteredImage(filterName: self.filterNameList[i],image: UIImage(named: "v3")!))
        }
        self.collectionView.reloadData()
        print(self.filterImages.count)
    
}
    
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//
//        if self.btnPlayImg.isHidden == false {
//
//            playerView.playToEndTime?()
//            playerView.isReplay = true
//            self.playerView.player?.rate = 2.0
//            playerView.replay?()
//            playerView.replayCount = playerView.replayCount +  1
//            playerView.player?.seek(to: CMTime.zero)
//            playerView.player?.play()
//
//        }else {
//
//        }
//    }
    
    //MARK:- PlayerSetup
    
    func playerSetup(){
        
       
        
        self.btnPlayImg.isHidden = true
        
        self.playerView.contentMode = .scaleAspectFill
        
       
        self.playerView.play(for: self.url!)
        
   
        self.video = AVURLAsset(url: self.url!)
        self.image = self.video!.videoToUIImage()
        self.originalImage = self.image
        
        
        self.playerView.stateDidChanged = { [self] state in
           // self.playerView.player?.rate = 3.0
            
            switch state {
            case .none:
                print("none")
                self.showToast(message: "Filter Removed, Select again", font: UIFont.systemFont(ofSize: 14.0))
                self.loader.isHidden = true
               
            case .error(let error):
                
                print("error - \(error.localizedDescription)")
//                self.progressView.wait()
//                self.progressView.isHidden = false

            case .loading:
                print("loading")
//                self.progressView.wait()
//                self.progressView.isHidden = false
               
            case .paused(let playing, let buffering):
                print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
//                self.progressView.signal()
//                self.progressView.isHidden = true
              
                
            case .playing:
                self.btnPlayImg.isHidden = true
                //self.progressView.isHidden = true
                
            }
        }
        
        print("video Pause Reason: ",self.playerView.pausedReason)
        
        
    }
    
    //MARK:- Button Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        print("pressed")
    }
    @IBAction func btnNext(_ sender: Any) {
        print("next pressed")
        playerView.pause(reason: .hidden)
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostVideoViewController") as! PostVideoViewController
        vc.videoUrl = self.playerView.playerURL
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.playerView.resume()
    }
    
    //MARK:- ViewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        playerView.pause(reason: .hidden)
    }
    
    

    
    
    //MARK:- API Handler
    
    internal func saveVideo(withURL url: URL) {
        
       /* let imageData:NSData = NSData.init(contentsOf: url)!
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        if(UserDefaults.standard.string(forKey: "sid") == nil || UserDefaults.standard.string(forKey: "sid") == ""){
            
            UserDefaults.standard.set("null", forKey: "sid")
        }
        
        let url : String = self.appDelegate.baseUrl!+self.appDelegate.uploadVideo!
        
        let parameter :[String:Any]? = ["fb_id":UserDefaults.standard.string(forKey: "uid")!,"videobase64":["file_data":strBase64],"sound_id":"null","description":"xyz","privacy_type":"Public","allow_comments":"true","allow_duet":"1","video_id":"009988"]
        
        print(url)
        print(parameter!)
        let headers: HTTPHeaders = [
            "api-key": "4444-3333-2222-1111"
            
        ]
        
        AF.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                HomeViewController.removeSpinner(spinner: sv)
                print("json: ",json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSString
                if(code == "200"){
                    print("Dict: ",dic)
                    self.dismiss(animated:true, completion: nil)
                }
            case .failure(let error):
                HomeViewController.removeSpinner(spinner: sv)
                print(error)
            }
        })*/
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {

        playerView.pause(reason: .hidden)
        
    }
    
    
  
}


//MARK:- CollectionView
extension previewPlayerViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  
    func applyFilter(filtername:String,filterIndex:Int) {
        playerView.play(for: url!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadVideo(notify:)), name: NSNotification.Name(rawValue: "url"), object: nil)
       
    
    }
    
    @objc func uploadVideo(notify:Notification){
        
        let obj = notify.object
        print("obj",obj)
        
       
        if obj as! String == "" {

        }else {
            DispatchQueue.main.async {
                self.loader.isHidden = true
            }
           
        }
        
        
    }
    
     func createFilteredImage(filterName: String, image: UIImage) -> UIImage {
        if(filterName == filterNameList[0]){
            return self.image!
        }
        // 1 - create source image
        let sourceImage = CIImage(image: image)
        
        // 2 - create filter using name
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        
        // 3 - set source image
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        
        // 5 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!, scale: image.scale, orientation: image.imageOrientation)
        
        return filteredImage
    }
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return filterNameList.count
   }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterVideoCollectionViewCell", for: indexPath) as! FilterVideoCollectionViewCell
        cell.filterNameLabel.text = self.filterDisplayNameList[indexPath.row]
        cell.imageView.image =  self.filterImages[indexPath.row]
        return cell
    }
    
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.loader.isHidden = false
        filterIndex = indexPath.row
        applyFilter(filtername:  filterNameList[indexPath.row], filterIndex: indexPath.row)
        
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:120, height: 140)
    }
}

