//
//  StartChatViewController.swift
//  SmashVideos
//
//  Created by Mac on 13/07/2023.
//

import UIKit
import KeyboardLayoutGuide

class StartChatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var searchView: UIView!
    
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var tfComment: CustomTextField!

    var callback: ((_ id : String, _ text : String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfComment.delegate = self
        tfComment.becomeFirstResponder()
        searchView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        

        
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if tfComment.text?.count == 0{
            
            btnSend.tintColor = UIColor.systemGray2
            
        }else{
            btnSend.tintColor = UIColor(named: "theme")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if tfComment.text == ""{
            self.showToast(message: "Enter your comment", font: .systemFont(ofSize: 12.0))
        }else{
            callback?(tfComment.text ?? "", "0")
            dismiss(animated: true, completion: nil)
//            self.callback1?("0")
        }
    }
    


}
