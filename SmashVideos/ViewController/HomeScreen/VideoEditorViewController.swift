//
//  VideoEditorViewController.swift
//  SmashVideos
//
//  Created by Murali karthick Rama Krishnan on 30/12/23.
//

import UIKit
import VideoEditorSDK
import MobileCoreServices

class VideoEditorViewController: UIViewController {
    @IBOutlet weak var videoPickerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        videoPickerBtn.addTarget(self, action: #selector(videoPickerTap), for: .touchUpInside)
    }
    

}


//Video editing

extension VideoEditorViewController: VideoEditViewControllerDelegate {
    
    @objc func videoPickerTap() {
        showVideoPicker()
    }
    
    // Function to edit the selected video using VideoEditorSDK
    func editVideoUsingVideoEditorSDK(_ videoURL: URL) {
        let video = Video(url: videoURL)
//        let video =  Video(url: Bundle.main.url(forResource: videoURL, withExtension: "mp4")!)

           // Create and present the video editor. Make this class the delegate of it to handle export and cancelation.
           let videoEditViewController = VideoEditViewController(videoAsset: video)
           videoEditViewController.delegate = self
           videoEditViewController.modalPresentationStyle = .fullScreen
           presentingViewController?.present(videoEditViewController, animated: true, completion: nil)
    }

    // MARK: - VideoEditViewControllerDelegate

    func videoEditViewControllerShouldStart(_ videoEditViewController: VideoEditViewController, task: VideoEditorTask) -> Bool {
      // Implementing this method is optional. You can perform additional validation and interrupt the process by returning `false`.
      true
    }

    func videoEditViewControllerDidFinish(_ videoEditViewController: VideoEditViewController, result: VideoEditorResult) {
      // The user exported a new video successfully and the newly generated video is located at `result.output.url`. Dismissing the editor.
      presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func videoEditViewControllerDidFail(_ videoEditViewController: VideoEditViewController, error: VideoEditorError) {
      // There was an error generating the video.
      print(error.localizedDescription)
      // Dismissing the editor.
      presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func videoEditViewControllerDidCancel(_ videoEditViewController: VideoEditViewController) {
      // The user tapped on the cancel button within the editor. Dismissing the editor.
      presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


extension VideoEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showVideoPicker() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.mediaTypes = [kUTTypeMovie as String] // Set media type to videos only
           present(imagePicker, animated: true, completion: nil)
       }

       // MARK: - UIImagePickerControllerDelegate Methods

       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)

           if let videoURL = info[.mediaURL] as? URL {
             
               let urlString = videoURL.absoluteString
               editVideoUsingVideoEditorSDK(videoURL)
               // Handle the selected video URL here
               // You can use 'videoURL' for further processing (e.g., uploading, displaying, etc.)
             
           }
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
   
   }

