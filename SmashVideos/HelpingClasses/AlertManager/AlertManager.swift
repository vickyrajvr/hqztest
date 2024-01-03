//
//  AlertManager.swift
//  D-Track
//
//  Created by Zubair Ahmed on 03/02/2022.
//

import UIKit

open class AlertManager: UIAlertController {
   
   open class func showAlert(title: String? = "", message: String? = "", preferredStyle: UIAlertController.Style = .alert, alertActions: [UIAlertAction]?) {
       let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
       if let actions = alertActions {
           for action in actions {
               alert.addAction(action)
           }
       }
       
       UIApplication.shared.keyWindow!.rootViewController!.present(alert, animated: true, completion: nil)
   }
   
   class func showAlert(title: String, message: String = "", OkBtnTitle: String = "", completionHandler: ((UIAlertAction) -> ())?) {
       let block = {
           let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: OkBtnTitle, style: UIAlertAction.Style.default, handler: completionHandler))
           UIApplication.shared.keyWindow!.rootViewController!.present(alert, animated: true, completion: nil)
       }
       
       if Thread.isMainThread {
           block()
       }
       else {
           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0) {
               block()
           }
       }
   }
   
   class func showAlert(title: String, message: String = "", OkBtnTitle: String = "") {
       AlertManager.showAlert(title: title, message: message, OkBtnTitle: OkBtnTitle, completionHandler: nil)
   }
   
   class func showAlert(message: String = "") {
       AlertManager.showAlert(title: "", message: message, completionHandler: nil)
   }
   
   class func showNoConnectivityAlert() {
       
//        AlertManager.showAlert(title: "!!!", message: "No Internet Connection", OkBtnTitle: "OK")
       AlertManager.presentGenericPopUp(topController: UIApplication.shared.windows.first!.rootViewController, iconName: "Logo_1", title: "No Internet Connection", description: "", primaryButtonTitle: "OK", secondaryButtonTitle: nil, primaryButtonHandler: nil, secondaryButtonHandler: nil)
   }
   
   class func showServerError() {
       AlertManager.showAlert(title: "", message: "", OkBtnTitle: "")
   }
   
   open class func presentGenericPopUp(fromSkip: Bool = false, topController: UIViewController?, iconName: String?, hideIcon: Bool = false, title: String?, description: String?, primaryButtonTitle : String?, showArrow : Bool = false, secondaryButtonTitle: String?, isShowPrimaryButton : Bool = false, primaryButtonHandler: ((UIButton) -> Void)?, secondaryButtonHandler: ((UIButton) -> Void)? , shouldNavigateBackOnTapOutside : Bool = false , isForReportSubmission: Bool = false, presentationStyle : UIModalPresentationStyle = .overCurrentContext, modalTransitionStyle:UIModalTransitionStyle = .crossDissolve) {
       let controller = GenericPopUp(nibName: "GenericPopUp", bundle: nil)
       
       if shouldNavigateBackOnTapOutside {
           controller.topController = topController
//            controller.delegate = LoginService.shared
       }
       
       controller.isShowSecondaryButton = isShowPrimaryButton
       controller.isForReportSubmission = isForReportSubmission
       controller.isTappedOutside = shouldNavigateBackOnTapOutside
       if iconName != nil {
           controller.iconName = iconName
       }
       controller.hideIcon = hideIcon
       controller.showArrow = showArrow
       
       if title != nil {
           controller.titleForPopUp = title
       }
       if description != nil {
           controller.descriptionForPopUp = description
       }
       if primaryButtonTitle != nil {
           controller.primaryButtonTitle = primaryButtonTitle
       }
       if secondaryButtonTitle != nil {
           controller.secondaryButtontitle = secondaryButtonTitle
       }
       controller.primaryButtonHandler = primaryButtonHandler
       controller.secondaryButtonHandler = secondaryButtonHandler
       
       if topController is GenericPopUp  {
           return
       }
       
//        if let nav = topController as? UINavigationController {
//            if nav.containsViewController(ofKind: GenericPopUp.self){
//                return
//            }
//        }
       
       controller.modalPresentationStyle = presentationStyle
       controller.modalTransitionStyle = modalTransitionStyle
       topController?.present(controller, animated: true, completion: nil)
   }
   
//
//    open class func presentUpdateStatusPopUp(fromSkip: Bool = false, topController: UIViewController?, iconName: String?, hideIcon: Bool = false, title: String?, description: String?, primaryButtonTitle : String?, showArrow : Bool = false, secondaryButtonTitle: String?, isShowPrimaryButton : Bool = false, primaryButtonHandler: ((UIButton) -> Void)?, secondaryButtonHandler: ((UIButton) -> Void)? , shouldNavigateBackOnTapOutside : Bool = false , isForReportSubmission: Bool = false, presentationStyle : UIModalPresentationStyle = .overCurrentContext, modalTransitionStyle:UIModalTransitionStyle = .crossDissolve) {
//        let controller = UpdateStatus(nibName: "UpdateStatus", bundle: nil)
//
//        if shouldNavigateBackOnTapOutside {
//            controller.topController = topController
// //            controller.delegate = LoginService.shared
//        }
//
//        controller.isShowSecondaryButton = isShowPrimaryButton
//        controller.isForReportSubmission = isForReportSubmission
//        controller.isTappedOutside = shouldNavigateBackOnTapOutside
//        if iconName != nil {
//            controller.iconName = iconName
//        }
//        controller.hideIcon = hideIcon
//        controller.showArrow = showArrow
//
//        if title != nil {
//            controller.titleForPopUp = title
//        }
//        if description != nil {
//            controller.descriptionForPopUp = description
//        }
//        if primaryButtonTitle != nil {
//            controller.primaryButtonTitle = primaryButtonTitle
//        }
//        if secondaryButtonTitle != nil {
//            controller.secondaryButtontitle = secondaryButtonTitle
//        }
//        controller.primaryButtonHandler = primaryButtonHandler
//        controller.secondaryButtonHandler = secondaryButtonHandler
//
//        if topController is GenericPopUp  {
//            return
//        }
//
// //        if let nav = topController as? UINavigationController {
// //            if nav.containsViewController(ofKind: GenericPopUp.self){
// //                return
// //            }
// //        }
//
//        controller.modalPresentationStyle = presentationStyle
//        controller.modalTransitionStyle = modalTransitionStyle
//        topController?.present(controller, animated: true, completion: nil)
//    }
}
