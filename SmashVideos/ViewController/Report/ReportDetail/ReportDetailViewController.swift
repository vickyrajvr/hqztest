//
//  ReportDetailViewController.swift
//  WOOW
//
//  Created by Mac on 05/07/2022.
//

import UIKit

class ReportDetailViewController: UIViewController {
    var otherUserID = ""

    var liveStreamId = ""
    private lazy var loader : UIView = {
       return (AppUtility?.createActivityIndicator((UIApplication.shared.keyWindow?.rootViewController?.view)!))!
    }()
    
    
    @IBOutlet weak var reportTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.tableFooterView = UIView()
        reportTableView.register(UINib(nibName: "ReportDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportDetailTableViewCell")
        getReportReasons()
    }
    
    var reportDataArr = [reportMVC]()
    var videoID = ""
    
    @IBAction func btnBack(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
    }
    
    
    func getReportReasons(){
        
        reportDataArr.removeAll()
        
        self.loader.isHidden = false
        ApiHandler.sharedInstance.showReportReasons { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let msgData = response?.value(forKey: "msg") as! NSArray
                    
                    for reportObj in msgData{
                        let reportDict = reportObj as! NSDictionary
                        
                        let report = reportDict.value(forKey: "ReportReason") as! NSDictionary
                        
                        let id = report.value(forKey: "id") as! String
                        let title = report.value(forKey: "title") as! String
                        let created = report.value(forKey: "created") as! String
                        
                        let obj = reportMVC(id: id, title: title, created: created)
                        
                        self.loader.isHidden = true
                        self.reportDataArr.append(obj)
                        
                    }
                }else{
                    self.loader.isHidden = true
                    print("!200: ",response as Any)
                }
                
                self.reportTableView.reloadData()
            }else{
                self.loader.isHidden = true
                print("failed: ",response as Any)
            }
        }
    }


}

//MARK:- EXTENSION TABLE VIEW

extension ReportDetailViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportDetailTableViewCell", for: indexPath)as! ReportDetailTableViewCell
        cell.lblReport.text = reportDataArr[indexPath.row].title
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reportObj = reportDataArr[indexPath.row]
       
        let myViewController = ReportViewController(nibName: "ReportViewController", bundle: nil)
        
        myViewController.reportTiltleText = reportObj.title
        
        myViewController.reportID = reportObj.id
        myViewController.videoID = self.videoID
        myViewController.otherUserID = self.otherUserID
        myViewController.liveStreamId = self.liveStreamId
        myViewController.modalPresentationStyle = .overFullScreen
    
        self.present(myViewController, animated: true, completion: nil)
    }
    
}
