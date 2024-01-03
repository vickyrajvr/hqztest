//
//  SettingAgroraViewController.swift
//  WOOW
//
//  Created by Mac on 26/07/2022.
//

import UIKit
import AgoraRtcKit

protocol SettingsVCDataSource: NSObjectProtocol {
    func settingsVCNeedSettings() -> Settings
}

protocol SettingsVCDelegate: NSObjectProtocol {
    func settingsVC(_ vc: SettingAgroraViewController, didSelect dimension: CGSize)
    func settingsVC(_ vc: SettingAgroraViewController, didSelect frameRate: AgoraVideoFrameRate)
}
class SettingAgroraViewController: UIViewController {
    
    var videoPreviewArr = [["name":"Auto","is_Selected":"1"],
                   ["name":"Enabled","is_Selected":"0"],
                   ["name":"Disabled","is_Selected":"0"]]
    
    var RemotevideoEncodeArr = [["name":"Auto","isSelected":"1"],
                    ["name":"Enabled","isSelected":"0"],
                    ["name":"Disabled","isSelected":"0"]]
    
    var videoEncodeArr = [["name":"Auto","Selected":"1"],
                       ["name":"Enabled","Selected":"0"],
                       ["name":"Disabled","Selected":"0"]]
    
    var modeName = ""
    var tag = 0
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var resolutionCollectionView: UICollectionView!
    @IBOutlet weak var modeTableView: UITableView!
    
    
    @IBOutlet weak var lblLocalPreview: UILabel!
    
    @IBOutlet weak var lblRender: UILabel!
    @IBOutlet weak var lblVideoEncode: UILabel!
    
    private var settings: Settings {
        return dataSource!.settingsVCNeedSettings()
    }
    
    private var selectedDimension: CGSize = CGSize.defaultDimension() {
        didSet {
            resolutionCollectionView?.reloadData()
        }
    }
    
    private var selectedFrameRate: AgoraVideoFrameRate = AgoraVideoFrameRate.defaultValue {
        didSet {
            print(selectedFrameRate.description)
//            frameRateLabel?.text = selectedFrameRate.description
        }
    }
    
    private let dimensionList: [CGSize] = CGSize.validDimensionList()
    private let frameRateList: [AgoraVideoFrameRate] = AgoraVideoFrameRate.validList()
    
    weak var delegate: SettingsVCDelegate?
    weak var dataSource: SettingsVCDataSource?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resolutionCollectionView.delegate = self
        resolutionCollectionView.dataSource = self
        
        modeTableView.delegate = self
        modeTableView.dataSource = self
        
        modeTableView.register(UINib(nibName: "ModeTableViewCell", bundle: nil), forCellReuseIdentifier: "ModeTableViewCell")
        
        resolutionCollectionView.register(UINib(nibName: "ResolutionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResolutionCollectionViewCell")
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//
//        resolutionCollectionView!.collectionViewLayout = layout
        self.backView.isHidden = true
        
        setup()
    }
    
    
    func setup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backView.addGestureRecognizer(tap)
        
        selectedDimension = settings.dimension
        selectedFrameRate = settings.frameRate
        updateCollectionViewLayout()
        
        
    }
    
    
    deinit {
        delegate?.settingsVC(self, didSelect: selectedDimension)
        delegate?.settingsVC(self, didSelect: selectedFrameRate)
    }
    
    
    func updateCollectionViewLayout() {
        let itemInteritemSpacing: CGFloat = 8
        let collectionViewInteritemSpacing: CGFloat = 19
        let width = Double((UIScreen.main.bounds.width - (collectionViewInteritemSpacing * 2) - (itemInteritemSpacing * 2)) / 3)
        let height = 40.0
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = itemInteritemSpacing
        layout.itemSize = CGSize(width: width, height: height)
        resolutionCollectionView.setCollectionViewLayout(layout, animated: true)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.backView.isHidden = true
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func mirrorModeButtonPressed(_ sender: UIButton) {
        
       
        
        tag = sender.tag
        
        if sender.tag == 0{
            backView.isHidden = false
            print("videoPreviewArr",videoPreviewArr)
            self.modeTableView.reloadData()
            
        }else if sender.tag == 1{
            backView.isHidden = false
            print("RemotevideoEncodeArr",RemotevideoEncodeArr)
            self.modeTableView.reloadData()
           
        }else {
            backView.isHidden = false
            print("videoEncodeArr",videoEncodeArr)
            self.modeTableView.reloadData()
            
        }
        
    }
    
    
    
}

//MARK:- EXTENSION FOR COLLECTION VIEW

extension SettingAgroraViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dimensionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResolutionCollectionViewCell", for: indexPath)as! ResolutionCollectionViewCell
        let dimension = dimensionList[indexPath.row]
        cell.update(with: dimension, isSelected: (dimension == selectedDimension))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dimension = dimensionList[indexPath.row]
        selectedDimension = dimension
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.resolutionCollectionView.frame.width / 3.0) - 20, height: 50)
    }
    
    
}

//MARK:- EXTENSION TABLE VIEW

extension SettingAgroraViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tag == 0 {
            return videoPreviewArr.count
            
        }else if tag == 1{
            return RemotevideoEncodeArr.count
        }else{
            return videoEncodeArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModeTableViewCell", for: indexPath)as! ModeTableViewCell
        
        print("tag",tag)
        
        if tag == 0{
            
            cell.lblMode.text = videoPreviewArr[indexPath.row]["name"] ?? ""
            if videoPreviewArr[indexPath.row]["is_Selected"] == "1"{
                cell.imgMode.image = UIImage(named: "icons8-ok-50()")
            }else {
                cell.imgMode.image = UIImage(named: "icons8-round-50()")
            }
            
        }else if tag == 1{
            cell.lblMode.text = RemotevideoEncodeArr[indexPath.row]["name"] ?? ""
            if RemotevideoEncodeArr[indexPath.row]["isSelected"] == "1"{
                cell.imgMode.image = UIImage(named: "icons8-ok-50()")
            }else {
                cell.imgMode.image = UIImage(named: "icons8-round-50()")
            }
           
        }else {
            
           
            cell.lblMode.text = videoEncodeArr[indexPath.row]["name"] ?? ""
            if videoEncodeArr[indexPath.row]["Selected"] == "1"{
                cell.imgMode.image = UIImage(named: "icons8-ok-50()")
            }else {
                cell.imgMode.image = UIImage(named: "icons8-round-50()")
            }
           
        }
        
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("tag",tag)
        if tag == 0{
            modeName = videoPreviewArr[indexPath.row]["name"] ?? ""
            lblLocalPreview.text = modeName
            
            for var i in 0..<self.videoPreviewArr.count{
                var obj = self.videoPreviewArr[i]
                obj.updateValue("0", forKey: "is_Selected")
                self.videoPreviewArr.remove(at: i)
                self.videoPreviewArr.insert(obj, at: i)
            }
            var obj = self.videoPreviewArr[indexPath.row]
            obj.updateValue("1", forKey: "is_Selected")
            self.videoPreviewArr.remove(at: indexPath.row)
            self.videoPreviewArr.insert(obj, at: indexPath.row)
            print("videoPreviewArr",videoPreviewArr)
            self.backView.isHidden = true
           
            
        }else if tag == 1{
            modeName = RemotevideoEncodeArr[indexPath.row]["name"] ?? ""
            lblRender.text = modeName
            for var i in 0..<self.RemotevideoEncodeArr.count{
                var obj = self.RemotevideoEncodeArr[i]
                obj.updateValue("0", forKey: "isSelected")
                self.RemotevideoEncodeArr.remove(at: i)
                self.RemotevideoEncodeArr.insert(obj, at: i)
            }
            var obj = self.RemotevideoEncodeArr[indexPath.row]
            obj.updateValue("1", forKey: "isSelected")
            self.RemotevideoEncodeArr.remove(at: indexPath.row)
            self.RemotevideoEncodeArr.insert(obj, at: indexPath.row)
            print("RemotevideoEncodeArr",RemotevideoEncodeArr)
            self.backView.isHidden = true
            
        }else {
           
            modeName = videoEncodeArr[indexPath.row]["name"] ?? ""
            lblVideoEncode.text = modeName
            for var i in 0..<self.videoEncodeArr.count{
                var obj = self.videoEncodeArr[i]
                obj.updateValue("0", forKey: "Selected")
                self.videoEncodeArr.remove(at: i)
                self.videoEncodeArr.insert(obj, at: i)
            }
            var obj = self.videoEncodeArr[indexPath.row]
            obj.updateValue("1", forKey: "Selected")
            self.videoEncodeArr.remove(at: indexPath.row)
            self.videoEncodeArr.insert(obj, at: indexPath.row)
            print("videoEncodeArr",videoEncodeArr)
            self.backView.isHidden = true
           
        }
        
        
        
    }
    
}
