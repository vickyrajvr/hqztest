//
//  ScannerViewController.swift
//  SmashVideos
//
//  Created by Mac on 24/01/2023.
//

import UIKit
import MercariQRScanner
import AVFoundation
class ScannerViewController: UIViewController {
    
    
    //MARK: - OUTLET
    
    @IBOutlet weak var qrScannerView: QRScannerView!
    
    @IBOutlet weak var btnFlash: FlashButton!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let theme = UserDefaults.standard.string(forKey: "theme") {
            if theme == "dark" {
                self.overrideUserInterfaceStyle = .dark
            } else {
                self.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    
    
    //MARK: - FUNCTION
    
    
    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }
    
    private func setupQRScannerView() {
       
       // qrScannerView.focusImage = UIImage(named: "scan_qr_focus")
        //qrScannerView.focusImagePadding = 1
        qrScannerView.animationDuration = 1
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }
    
    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Camera is required to use in this application", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    
    //MARK: - BUTTON ACTION
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func flashButtonPressed(_ sender: UIButton) {
        
        if sender.isSelected == true {
            btnFlash.setImage(UIImage(named: "flashOffIcon"), for: .normal)
            qrScannerView.setTorchActive(isOn: !sender.isSelected)
        }else {
            btnFlash.setImage(UIImage(named: "flashOnIcon"), for: .normal)
            qrScannerView.setTorchActive(isOn: !sender.isSelected)
        }
       
       
        
    }
    
    
    @IBAction func qrCodeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}

// MARK: - QRScannerViewDelegate
extension ScannerViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error.localizedDescription)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        let components = code.components(separatedBy: "profile/")
        let otherUserID = components[1]
        
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
        vc.otherUserID = otherUserID
        vc.isQrCode = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        btnFlash.isSelected = isOn
    }
    
}

