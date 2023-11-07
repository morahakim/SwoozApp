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
        setupCamera()
        setupView()
        contentAnalysisViewController.counter.menuStateSend(menuState: "placement")
//        menuStateApp = "placement"
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStateMenu), userInfo: nil, repeats: true)
        contentAnalysisViewController.contentAnalysisDelegate = self
    }
    
    @objc func updateStateMenu(){
        print("DBUG : Timer")
        print("DBUG : ",menuStateApp)
        if(menuStateApp == "stillPlay"){
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
        if let image = UIImage(named: "Net") {
            imageNetView.image = image
        }
        boxNet.addSubview(imageNetView)
        view.addSubview(boxNet)
        
        let buttonClose = UIButton(type: .custom)
        buttonClose.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        buttonClose.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        buttonClose.layer.cornerRadius = 20
        buttonClose.clipsToBounds = true
        
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
        buttonWhite.addTarget(self, action: #selector(openDir), for: .touchUpInside)
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
    
    }
    
}
