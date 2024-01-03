# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SmashVideos' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
 
  # Pods for SmashVideos
pod 'IQKeyboardManagerSwift'
pod 'DSGradientProgressView'
pod 'Firebase'
pod 'FirebaseCore'
pod 'FirebaseStorage'
pod 'NextLevel'
pod 'YPImagePicker'
pod 'FirebaseAuth'
pod 'FirebaseDatabase'
pod 'RangeSeekSlider'
pod 'FirebaseMessaging'
pod 'Firebase/Crashlytics'
pod 'Firebase/Analytics'
pod 'Moya'
pod 'Alamofire'
pod "Player"
pod 'EFInternetIndicator'
pod 'NVActivityIndicatorView'
pod 'GSPlayer'
pod "SwiftyCam"
pod 'SDWebImage', '~> 5.0'
pod 'DropDown'
pod 'AgoraRtcEngine_iOS'
pod 'ActiveLabel'
pod 'GTProgressBar'
pod 'CoreAnimator', '~> 2.1.4'
pod 'DPOTPView'
pod 'MarqueeLabel'
pod 'lottie-ios'
pod 'SnapKit', '~> 5.0.0'
pod 'PhoneNumberKit'
pod 'FullMaterialLoader'
pod 'FBSDKLoginKit'
pod 'GoogleSignIn'
pod 'Kingfisher', '~>5.15.7'
pod 'FBSDKShareKit'
pod 'UIView-Shimmer', '~> 1.0'
pod 'XLPagerTabStrip', '~> 9.0'
pod 'GrowingTextView'
pod 'SwiftyStoreKit'
pod 'KYShutterButton'
pod 'MercariQRScanner'
pod 'QCropper'
pod 'iOSDropDown'
pod 'RealmSwift'
pod 'RangeSeekSlider'
pod 'Keyboard+LayoutGuide'
pod 'TOCropViewController'
pod 'VideoEditorSDK'



end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
