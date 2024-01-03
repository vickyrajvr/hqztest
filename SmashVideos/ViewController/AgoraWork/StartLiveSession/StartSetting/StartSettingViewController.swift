//
//  StartSettingViewController.swift
//  SmashVideos
//
//  Created by Mac on 12/07/2023.
//

import UIKit

class StartSettingViewController: UIViewController {
    
    @IBOutlet var settingTableView: UITableView!
    
    var settingArr = [["name":"Comment","image":"image-3"],
                      ["name":"Flip camera","image":"image-41"],
//                      ["name":"Mirror your video","image":"image-5"],
                      ["name":"Pause LIVE","image":"image-8"],
                      ["name":"Mute microphone","image":"image-9"]]
    
    var mic = "1"
    var video = "1"
    var callback1: ((String) -> Void)?
    var callback: ((_ id : String, _ text : String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        settingTableView.register(UINib(nibName: "StartSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "StartSettingTableViewCell")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            dismiss(animated: true, completion: nil)
            
        }
    }
    
  
    
    
}


extension StartSettingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.settingArr.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StartSettingTableViewCell", for: indexPath) as! StartSettingTableViewCell
        
        cell.lblSetting.text = settingArr[indexPath.row]["name"]
        cell.settingImage.image = UIImage(named: settingArr[indexPath.row]["image"]!)
        if self.video == "1" {
            cell.settingSwitch.isOn = false
        }else {
            cell.settingSwitch.isOn = true
        }
        if indexPath.row == 2 || indexPath.row == 4{
            cell.settingSwitch.isHidden = false
            cell.nextButton.isHidden = true
        }else{
            cell.settingSwitch.isHidden = true
            cell.nextButton.isHidden = false
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
        
            weak var pvc = self.presentingViewController

            self.dismiss(animated: false, completion: {
                let myViewController = StartChatViewController(nibName: "StartChatViewController", bundle: nil)
                myViewController.modalPresentationStyle = .overFullScreen
                myViewController.callback = { (id,text) -> Void in
                    print("string: ",id)
                    print("id: ",text)
                    self.callback?(id , "\(text)")
                   
                }
                pvc?.present(myViewController, animated: false)
            })
            
        }else if indexPath.row == 1{
            self.callback1?("1")
            
        }else if indexPath.row == 2{
            if self.video == "1" {
                self.video = "0"
                self.callback?("video" , "\(video)")
            }else {
                self.video = "1"
                self.callback?("video" , "\(video)")
            }
//            self.callback1?("2")
            
        }else{
            if self.mic == "1" {
                self.mic = "0"
                self.callback?("mic" , "\(mic)")
            }else {
                self.mic = "1"
                self.callback?("mic" , "\(mic)")
            }
//            self.callback1?("4")
        }
        
        self.navigationController?.dismiss(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
        
    }
    
    
}

