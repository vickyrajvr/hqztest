//
//  ReportViewController.swift
//  WOOW
//
//  Created by Mac on 05/07/2022.
//

import UIKit

class ReportViewController: UIViewController,UITextViewDelegate {
    
    private lazy var loader : UIView = {
       return (AppUtility?.createActivityIndicator((UIApplication.shared.keyWindow?.rootViewController?.view)!))!
    }()
    

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var reportView: UIView!
    
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var reportDescTF: UITextView!
    
    var reportTiltleText = ""
    var reportID = ""
    var videoID = ""
    var otherUserID = ""
    var liveStreamId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(report(tapGestureRecognizer:)))
        reportView.isUserInteractionEnabled = true
        reportView.addGestureRecognizer(tapGestureRecognizer)
        reportDescTF.delegate = self
        reportTitle.text = reportTiltleText
        print("reportObj.id",reportID)
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "graycolor") {
            textView.text = nil
            textView.textColor = UIColor.appColor(.black)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tell us why this content is being reported. All supporting content should be relevant to the ad being reported"
            textView.textColor = UIColor(named: "graycolor")
        }
    }
    
    //MARK:-ACTION
    
    @objc func report(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        var desc = ""
        
        if reportDescTF.textColor == UIColor(named: "graycolor") {
            reportDescTF.text = nil
            
        }else {
            desc = reportDescTF.text!
        }
        
      
     
         print("desc",desc)
        if self.videoID == "" {
            reportUser(reportReason: desc)
        }else{
            reportVideo(reportReason: desc)
        }
         
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
    }
    
    //    MARK:- Report video func
    
    func reportUser(reportReason: String){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.reportUser(user_id: UserDefaultsManager.shared.user_id, report_user_id: self.otherUserID, report_reason_id: reportID, description: reportReason, live_streaming_id: self.liveStreamId) { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.view)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    if self.liveStreamId != ""{
                        AlertManager.presentGenericPopUp(fromSkip: false, topController: self, iconName: "", hideIcon: false, title: "Thanks for reporting", description: "We value your help to keep MUSICTOK, a safe community. We'll review your report and take action if there is a violation of our Community Guidelines.", primaryButtonTitle: "Ok", showArrow: false, secondaryButtonTitle: "Cancel", isShowPrimaryButton: false, primaryButtonHandler: { [] btn in
                            print("yes")
                        }, secondaryButtonHandler: { btn in
                        }, shouldNavigateBackOnTapOutside: false, isForReportSubmission: false,presentationStyle: .overCurrentContext , modalTransitionStyle: .crossDissolve)
                    }else {
                        self.showToast1(message: "Thanks for reporting.\nWe value your help to keep MUSICTOK, a safe community.\nWe'll review your report and take action if\nthere is a violation of our Community Guidelines.", font: .systemFont(ofSize: 11))
                        let seconds = 5.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            // Put your code which should be executed with a delay here
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                   
                    
//                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                }else{
                    
                    if response?.value(forKey: "code") as! NSNumber == 201 {
                       let msg = response?.value(forKey: "msg") as? String
                        self.showToast1(message: msg ?? "", font: .systemFont(ofSize: 11))
                    }else {
                        self.showToast1(message: "Thanks for reporting.\nWe value your help to keep MUSICTOK, a safe community.\nWe'll review your report and take action if\nthere is a violation of our Community Guidelines.", font: .systemFont(ofSize: 12))
                        
                        let seconds = 5.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            // Put your code which should be executed with a delay here
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                   
                    
                }
            }else{
                
            }
            self.loader.isHidden = true
        }
    }
    
    func reportVideo(reportReason: String){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.reportVideo(user_id: UserDefaultsManager.shared.user_id, video_id: videoID, report_reason_id: reportID, description: reportReason) { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.view)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    self.showToast1(message: "Thanks for reporting.\nWe value your help to keep MUSICTOK, a safe community.\nWe'll review your report and take action if\nthere is a violation of our Community Guidelines.", font: .systemFont(ofSize: 11))
                    let seconds = 3.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        // Put your code which should be executed with a delay here
                        self.dismiss(animated: true, completion: nil)
                    }
                    
//                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                }else{
                    if response?.value(forKey: "code") as! NSNumber == 201 {
                       let msg = response?.value(forKey: "msg") as? String
                        self.showToast1(message: msg ?? "", font: .systemFont(ofSize: 11))
                    }else {
                        self.showToast1(message: "Thanks for reporting.\nWe value your help to keep MUSICTOK, a safe community.\nWe'll review your report and take action if\nthere is a violation of our Community Guidelines.", font: .systemFont(ofSize: 11))
                        
                        let seconds = 3.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            // Put your code which should be executed with a delay here
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                   
                    
                }
            }else{
                
            }
            self.loader.isHidden = true
        }
    }
    

}
