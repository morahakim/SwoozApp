/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The app's home view controller that displays instructions and camera options.
 */

import UIKit
import AVFoundation
import UniformTypeIdentifiers
import UniformTypeIdentifiers
import SwiftUI
import AVKit

protocol HomeDelegate: AnyObject {
    func saveRecord(url: URL)
}

class HomeViewController: UIViewController, ContentAnalysisDelegate {
    
    func saveRecord(url: URL) {
        homeDelegate?.saveRecord(url: url)
    }
    
    var homeDelegate: HomeDelegate?
    
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("menuStateApp") var menuStateApp = ""
    @AppStorage("name") var name: String = ""
    
    let contentAnalysisViewController = ContentAnalysisViewController()
    
    
    private var cameraViewController: CameraViewController!
    var recordedVideoURL: URL?
    
    @IBAction func uploadVideoForAnalysis(_ sender: Any) {
        
        // Create a document picker the sample app uses to upload a video to analyze.
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.movie,
                                                                                UTType.video], asCopy: true)
        docPicker.delegate = self
        docPicker.allowsMultipleSelection = false
        present(docPicker, animated: true, completion: nil)
        
    }
    
    @IBAction func startCameraForAnalysis(_ sender: Any) {
        performSegue(withIdentifier: ContentAnalysisViewController.segueDestinationId,
                     sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupCamera()
        setupView()
        contentAnalysisViewController.counter.menuStateSend(menuState: "placement")
//        menuStateApp = "placement"
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStateMenu), userInfo: nil, repeats: true)
        contentAnalysisViewController.contentAnalysisDelegate = self
    }
    
    let setupViewParent = UIView()
    let setupViewChild = UIView()
    var textClear = UILabel()
    var text1 = UILabel()
    var text2 = UILabel()
    var text3 = UILabel()
    var textCountdown = UILabel()
    var boxCourtArea = UIView()
    var countdown = 0
    let boxCountdown = UIView()
    let boxScore = UIView()
    
    let playerViewController = AVPlayerViewController()
    
    @objc func setupSetUp(){
        
        print("setupSetUp")
//        view.backgroundColor = .blue
        
        setupViewParent.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        setupViewParent.backgroundColor = .black
        setupViewParent.alpha = 0.5
        view.addSubview(setupViewParent)
        
        
        setupViewChild.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        setupViewChild.backgroundColor = nil
        view.addSubview(setupViewChild)
        
        let setupView1 = UIView()
        setupView1.backgroundColor = nil
        setupView1.frame = CGRect(x: 0, y: 0, width: view.frame.width/1.5, height: view.frame.height/1.5)
        setupView1.center = view.center
        setupViewChild.addSubview(setupView1)
        
        setupView1.translatesAutoresizingMaskIntoConstraints = false
        setupView1.heightAnchor.constraint(equalToConstant: view.frame.height/1.5).isActive = true
        setupView1.widthAnchor.constraint(equalToConstant: view.frame.width/1.5).isActive = true
        setupView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupView1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        var setupName = "SetUpLevel1"
        if(name == "Intermediate"){
            setupName = "SetUpLevel1"
        }else if(name == "Experienced"){
            setupName = "SetUpLevel2"
        }else if(name == "Advanced"){
            setupName = "SetUpLevel3"
        }
        
        // Create a video player
        if let videoURL = Bundle.main.url(forResource: setupName, withExtension: "mp4") {
            let player = AVPlayer(url: videoURL)

            // Create a player view controller
            
            playerViewController.player = player

            // Create a container view with a border radius
            let container = UIView()
            container.frame = CGRect(x: 0, y: 0, width: setupView1.frame.width, height: setupView1.frame.height)
            container.layer.cornerRadius = 12
            container.clipsToBounds = true

            // Add the player view controller's view as a subview of the container
            playerViewController.view.frame = container.bounds
            container.addSubview(playerViewController.view)

         
            thumbnailImageView.image = UIImage(named: "PlayButton") // Your thumbnail image here
            thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(thumbnailImageView)

            // Add Auto Layout constraints to center the thumbnailImageView
            thumbnailImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            thumbnailImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

            // Add the container view to your setupView1
            setupView1.addSubview(container)

            // Play the video when the thumbnail is tapped
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playVideo))
            thumbnailImageView.addGestureRecognizer(tapGesture)
            thumbnailImageView.isUserInteractionEnabled = true
            
            
        } else {
            print("Video file not found in the app's bundle.")
        }

        let resetButton = UIButton()
        resetButton.setTitle("SKIP", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        resetButton.frame = CGRect(x: 0, y: setupView1.frame.maxY + 5, width: setupViewChild.frame.width, height: 40)
        resetButton.addTarget(self, action: #selector(skipVideo), for: .touchUpInside)
        setupViewChild.addSubview(resetButton)
        
        let textLevel = UILabel()
        textLevel.text = "Set Up Tutorial "+name
        textLevel.font = UIFont.systemFont(ofSize: 17)
        textLevel.textColor = UIColor.white
        textLevel.textAlignment = .center
        textLevel.frame = CGRect(x: 0, y: setupView1.frame.minY - 50, width: setupViewChild.frame.width, height: 40)
        setupViewChild.addSubview(textLevel)

        
    }
    
    
    let thumbnailImageView = UIImageView()
    
    @objc func playVideo() {
        playerViewController.player?.play()
        thumbnailImageView.removeFromSuperview()
    }
    
    @objc func skipVideo() {
        print("skipVideo")
        setupViewParent.removeFromSuperview()
        setupViewChild.removeFromSuperview()
    }
    
    @objc func updateStateMenu(){
        print("DBUG : Timer")
        print("DBUG : ",menuStateApp)
        if(menuStateApp == "stillPlay" || menuStateApp == "result"){
            liveCamera()
        } else if(menuStateApp == "done"){
            contentAnalysisViewController.stop()
        } else if(menuStateApp == "restart"){
            contentAnalysisViewController.restart()
        }
        
    }
    func setupView(){
        let boxNet = UIView()
        boxNet.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //        boxNet.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        boxNet.layer.cornerRadius = 4
        
        let imageNetView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        var netName = "NetLevel1"
        if(name == "Intermediate"){
            netName = "NetLevel1BU"
        }else if(name == "Experienced"){
            netName = "NetLevel2"
        }else if(name == "Advanced"){
            netName = "NetLevel3"
        }
        
        if let image = UIImage(named: netName) {
            imageNetView.image = image
        }
        boxNet.addSubview(imageNetView)
        view.addSubview(boxNet)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDir))
        imageNetView.isUserInteractionEnabled = true // Enable user interaction for the imageView
        imageNetView.addGestureRecognizer(tapGesture)
        
        let buttonSetUp = UIButton(type: .custom)
        let image2 = UIImage(named: "SetUpButton")
        buttonSetUp.setImage(image2, for: .normal)
        buttonSetUp.imageView?.contentMode = .scaleAspectFit
        buttonSetUp.frame = CGRect(x: 20, y: 75, width: 40, height: 40)
        buttonSetUp.addTarget(self, action: #selector(setupSetUp), for: .touchUpInside)
        view.addSubview(buttonSetUp)
        
        let buttonClose = UIButton(type: .custom)
        let image3 = UIImage(named: "CloseButton")
        buttonClose.setImage(image3, for: .normal)
        buttonClose.imageView?.contentMode = .scaleAspectFit
        buttonClose.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        buttonClose.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(buttonClose)
        
        
        let iconClose = UIImage(systemName: "xmark")
        let iconImageView = UIImageView(image: iconClose)
        iconImageView.tintColor = .white
        iconImageView.frame = CGRect(x:10, y: 10, width: 20, height: 20)
        buttonClose.addSubview(iconImageView)
        
        let buttonWhite = UIButton(type: .custom)
        buttonWhite.frame = CGRect(x: view.frame.size.width - 68 - (34/2), y: (view.frame.size.height/2) - (34/2), width: 68, height: 68)
        buttonWhite.backgroundColor = nil
        buttonWhite.layer.cornerRadius = 34
        buttonWhite.clipsToBounds = true
        buttonWhite.layer.borderWidth = 3.0
        buttonWhite.layer.borderColor = UIColor.white.cgColor
        buttonWhite.addTarget(self, action: #selector(liveCamera), for: .touchUpInside)
        view.addSubview(buttonWhite)
        
    
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 5, y: 5, width: 58, height: 58)
        button.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0)
        button.layer.cornerRadius = 29
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(liveCamera), for: .touchUpInside)
        
        buttonWhite.addSubview(button)
        
        
    }
    
    @objc func openDir() {
        print("Open Dir!")
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.movie,
                                                                                UTType.video], asCopy: true)
        docPicker.delegate = self
        docPicker.allowsMultipleSelection = false
        present(docPicker, animated: true, completion: nil)
    }
    @objc func liveCamera(){
        print("Live Camera!")
//        performSegue(withIdentifier: ContentAnalysisViewController.segueDestinationId,
//                     sender: self)
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        contentAnalysisViewController.urlVideo = nil
        
        view.addSubview(contentAnalysisViewController.view)
    }
    @objc func back() {
        print("Back!")
    }
    
    
    func setupCamera(){
        
        // Set up the video layers.
        cameraViewController = CameraViewController()
        cameraViewController.view.frame = view.bounds
        addChild(cameraViewController)
        cameraViewController.beginAppearanceTransition(true, animated: true)
        view.addSubview(cameraViewController.view)
        cameraViewController.endAppearanceTransition()
        cameraViewController.didMove(toParent: self)
        
        do {
            try cameraViewController.setupAVSession()
            print("DBUG : ABC")
        } catch {
            AppError.display(error, inViewController: self)
        }
        
        cameraViewController.outputDelegate = self
        
//        cameraViewController.outputDelegate = self
        
//        let captureSession = AVCaptureSession()
//            
//            if let captureDevice = AVCaptureDevice.default(for: .video) {
//                do {
//                    let input = try AVCaptureDeviceInput(device: captureDevice)
//                    captureSession.addInput(input)
//                } catch {
//                    print(error)
//                }
//            }
//
//            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//
//            if let connection = previewLayer.connection {
//                if connection.isVideoOrientationSupported {
//                    connection.videoOrientation = .landscapeRight
//                }
//            }
//
//            previewLayer.frame = view.bounds
//            view.layer.addSublayer(previewLayer)
//
//            captureSession.startRunning()
    }
}

extension HomeViewController: UIDocumentPickerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let controller = segue.destination as? ContentAnalysisViewController else {
            print("Failed to load the content analysis view controller.")
            return
        }
        
        guard let videoURL = recordedVideoURL else {
            print("Failed to load a video path.")
            return
        }
        controller.recordedVideoSource = AVAsset(url: videoURL)
        
    }
    func  documentPicker(_ controller: UIDocumentPickerViewController,
                         didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else {
            print("Failed to find a document path at the selected path.")
            return
        }
        recordedVideoURL = url
//        performSegue(withIdentifier: ContentAnalysisViewController.segueDestinationId,
//                     sender: self)
//        recordedVideoURL = nil
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        contentAnalysisViewController.urlVideo = recordedVideoURL
        
        view.addSubview(contentAnalysisViewController.view)
            
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
}




extension HomeViewController: CameraViewControllerOutputDelegate {
    
    func cameraViewController(_ controller: CameraViewController,
                              didReceiveBuffer buffer: CMSampleBuffer,
                              orientation: CGImagePropertyOrientation) {
        print("DBUG : 123")
    
    }
    
}
