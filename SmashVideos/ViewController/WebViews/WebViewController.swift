//
//  WebViewController.swift
//  D-Track
//
//  Created by Zubair Ahmed on 08/02/2022.
//

import UIKit
import WebKit
class WebViewController: UIViewController , UIWebViewDelegate,WKNavigationDelegate, UIScrollViewDelegate {
    
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    var myUrl = "www.google.com"
    var linkTitle = ""
    
    //MARK:- OUTLET
    
    @IBOutlet weak var wkwebView: WKWebView!

    @IBOutlet weak var linkTitleLbl: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    
    
    //MARK:-  VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(myUrl)
        
        let request = URLRequest(url: URL(string: myUrl)!)
        self.navigationController?.isNavigationBarHidden = true
        wkwebView?.navigationDelegate = self
        
        wkwebView?.load(request)
        wkwebView.scalesLargeContentImage = false
        wkwebView.showsLargeContentViewer = true
        wkwebView.isMultipleTouchEnabled = false
        //wkwebView.scrollView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.linkTitleLbl.text = self.linkTitle
     
       
    }
    override func viewDidDisappear(_ animated: Bool) {

        self.loader.isHidden = true
       
    }
    
//    //MARK: - UIScrollViewDelegate
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//             scrollView.pinchGestureRecognizer?.isEnabled = false
//    }
////    @objc func back(sender: UIBarButtonItem) {
////        self.navigationController?.popViewController(animated: true)
////    }
    
  
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    {
        print(message.body)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)

        self.loader.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        self.loader.isHidden = true
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { result, error in
            if let userAgent = result as? String {
                print(userAgent)

                self.loader.isHidden = true
            }
        })
    }
    
    
    //MARK:- BUTTON ACTION
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
   
}
