//
//  GenericPopUp.swift
//  D-Track
//
//  Created by Zubair Ahmed on 03/02/2022.
//



import UIKit
import IQKeyboardManagerSwift

protocol GenericPopUpDelegate {
    func didTappedOutside(in controller : UIViewController)
    func getPinCode(string:String)
}

class GenericPopUp: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    
    @IBOutlet weak var reportTextView: IQTextView!
    @IBOutlet weak var iconHeightConstrainnt: NSLayoutConstraint!
    @IBOutlet weak var iconBottomPaddingConstrainnt: NSLayoutConstraint!
    
    var primaryButtonHandler: ((UIButton) -> Void)?
    var secondaryButtonHandler: ((UIButton) -> Void)?
    var iconName : String?
    var titleForPopUp : String?
    var descriptionForPopUp : String?
    var primaryButtonTitle : String?
    var secondaryButtontitle : String?
    var isShowSecondaryButton : Bool = false
    var topController : UIViewController?
    var delegate : GenericPopUpDelegate?
    
    var hideIcon = false
    var showArrow = false
    var isForReportSubmission = false
    var isTappedOutside = false
    
    var reportForPopup : String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        colorScheme = .light
        self.view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.64)

        if let imgName = iconName{
            icon.image = UIImage(named: imgName)
        }
        
        if let title = titleForPopUp{
            lblTitle.text = title
        }
        
        if let des = descriptionForPopUp{
            lblDescription.text = des
        }

        if let primaryBtntitle = primaryButtonTitle{
            primaryButton.setTitle(primaryBtntitle, for: .normal)
        }
        
        if let secondaryTitle = secondaryButtontitle{
            secondaryButton.setTitle(secondaryTitle, for: .normal)
        }
        
        if hideIcon {
            iconHeightConstrainnt.constant = 0.0
            iconBottomPaddingConstrainnt.constant = 0.0
        }

        secondaryButton.isHidden = !isShowSecondaryButton
        secondaryButton.layer.shadowColor = UIColor.lightGray.cgColor
        secondaryButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        secondaryButton.layer.shadowOpacity = 0.1
        secondaryButton.layer.shadowRadius = 10.0
        secondaryButton.layer.masksToBounds = false
        secondaryButton.layer.backgroundColor = UIColor.appColor(.btnGreen)?.cgColor
        secondaryButton.layer.cornerRadius = 24
        
        primaryButton.layer.shadowColor = UIColor.appColor(.green)?.cgColor
        primaryButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        primaryButton.layer.shadowOpacity = 0.1
        primaryButton.layer.shadowRadius = 10.0
        primaryButton.layer.masksToBounds = false
        primaryButton.layer.cornerRadius = 24
        primaryButton.layer.backgroundColor = UIColor.appColor(.maincolor)?.cgColor
        
        if isForReportSubmission {
            lblDescription.isHidden = isForReportSubmission
            reportTextView.isHidden = !isForReportSubmission
            reportTextView.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonTappedOnReportTextView(_:)))
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            
        } else {
            
        }
        
        if isTappedOutside {
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutsideVisibleView(_:))))
        }

        if showArrow {
//            primaryButton.makeEnable(value: true, enableImage: "arrowRightGolden", disableImage: "arrowRightGrey")
//            primaryButton.setButtonLeftRightAlignment()
        } else {
            primaryButton.setImage(nil, for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reportTextView.layer.borderWidth = 1
//        reportTextView.layer.borderColor = UIColor(hexString: "D6D6D6", alpha: 1).cgColor
        reportTextView.layer.cornerRadius = 6
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func didTapOutsideVisibleView(_ sender : UITapGestureRecognizer){
        
        if let controller = topController {
            delegate?.didTappedOutside(in: controller)
        }
        dismissMe()
    }
    
    @IBAction func primaryButtonTapped(_ sender: UIButton) {
    
        dismissMe()
        if primaryButtonHandler != nil {
            sender.setTitle(reportTextView.text, for: UIControl.State())
            primaryButtonHandler!(sender)
        }
        if isForReportSubmission {
            print(reportTextView.text)
            delegate?.getPinCode(string: reportTextView.text)
            NotificationCenter.default.post(name: .getCouponCode, object: "myObject", userInfo: ["key": reportTextView.text])
        }
        
    }
    
    @objc func didTapForPincode(_ sender : UITapGestureRecognizer){
        
        if isForReportSubmission {
            print(reportTextView.text)
            delegate?.getPinCode(string: reportTextView.text)
            NotificationCenter.default.post(name: .getCouponCode, object: "myObject", userInfo: ["key": reportTextView.text])
        }
        dismissMe()
    }
    
    
    @IBAction func secondaryButtonTapped(_ sender: UIButton) {
        
        if secondaryButtonHandler != nil {
            secondaryButtonHandler!(sender)
        }
        dismissMe()
    }
    
    @objc func doneButtonTappedOnReportTextView(_ sender: UIBarButtonItem){
        print(reportTextView.text)
        delegate?.getPinCode(string: "dkjflsjflkdsjfldksjflk")
//        NotificationCenter.default.post(name: .purchaseDidFinish, object: "myObject", userInfo: ["key": "Value"])
        
        
//        NotificationCenter.default.post(name: .sendPinCode, object: "myObject", userInfo: ["pin" : reportTextView.text])
        reportTextView.resignFirstResponder()
    }
    
    @objc func keyboardDidShow(_ sender: Notification) {
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let animationDuration = sender.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: animationDuration) { [weak self] in
                self?.view.transform = CGAffineTransform(translationX: 0, y: -1 * (keyboardHeight / 1.5))
            }
        }
    }
    
    @objc func keyboardDidHide(_ sender: Notification) {
        view.transform = CGAffineTransform.identity
    }
    
    func dismissMe(completion: ((Bool) -> Void)? = nil) {
        if let navigationViewController = self.navigationController {
          if navigationViewController.viewControllers.count >= 1 {
            dismissPushedController()
          } else {
            dismissPresentedController()
          }
        } else {
          dismissPresentedController()
        }
        completion?(true)
      }
    
    fileprivate func dismissPushedController() {
        _ = navigationController?.popViewController(animated: true)
      }
      fileprivate func dismissPresentedController(completion: ((Bool) -> Void)? = nil) {
        dismiss(animated: true, completion: { () -> Void in
          completion?(true)
        })
      }
}
