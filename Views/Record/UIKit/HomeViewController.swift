/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The app's home view controller that displays instructions and camera options.
 */

import UIKit
import AVFoundation
import UniformTypeIdentifiers
import SwiftUI
import AVKit
import CoreMotion
import ReplayKit

struct RecordData {
    var url: URL
    var duration: String
    var hitFail: Int
    var hitPerfect: Int
    var hitSuccess: Int
    var hitTarget: Int
    var hitTotal: Int
    var level: String
    var result: String
    var minDistance: Double
    var avgDistance: Double
    var variance: String
}

protocol HomeDelegate: AnyObject {
    func back()

    func saveRecord(recordData: RecordData)
}

class HomeViewController: UIViewController, ContentAnalysisDelegate {
    let localStorage = LocalStorage()

    let motionManager = CMMotionManager()

    var transformedYValuesAccepted: Double = 0.0
    var minDistance: Double = 0.0
    var averageOfDistance: Double = 0.0
    var variance: String = ""

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

    func saveRecord(recordData: RecordData) {

            homeDelegate?.saveRecord(recordData: recordData)
       }

    var homeDelegate: HomeDelegate?

    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("menuStateApp") var menuStateApp = ""
    @AppStorage("menuStateApp2") var menuStateApp2 = ""
    @AppStorage("name") var name: String = ""
    @AppStorage("type") var type: String = ""

    @AppStorage("colorType") var colorType: String = ""

    @AppStorage("techniqueName") var techniqueName: String = ""
    @AppStorage("techniqueId") var techniqueId: Int = 0

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

    var boxView = UIView()
    var textSteady = UILabel()
    var isSteady = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupView()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStateMenu), userInfo: nil, repeats: true)
        contentAnalysisViewController.contentAnalysisDelegate = self

        contentAnalysisViewController.counter.typeSend(type: String(techniqueId))
        contentAnalysisViewController.counter.levelSend(level: techniqueName)

        // Assuming you are inside a UIViewController or another appropriate context
        let screenWidth = UIScreen.main.bounds.width

        setupSetUp()

        playVideo()

        //        setupPathColorView()

        boxView = UIView(frame: CGRect(x: (screenWidth - 200) / 2, y: 20, width: 200, height: 40))
        boxView.backgroundColor = UIColor.black
        boxView.layer.cornerRadius = 12
        boxView.layer.opacity = 0.5
        view.addSubview(boxView)
        textSteady = UILabel(frame: CGRect(x: 0, y: 0, width: boxView.frame.width, height: boxView.frame.height))
        textSteady.text = ""
        textSteady.textColor = UIColor.white
        textSteady.textAlignment = .center
        textSteady.font = UIFont(name: "Urbanist", size: 17)
        boxView.addSubview(textSteady)
        boxView.isHidden = true

        setupSteady()

        //        setupPathColorView()
    }

    let boxPathColor = UIView()

    func playerViewControllerDidDismiss(_ playerViewController: AVPlayerViewController) {
        print("Stop Fullscreen")
    }

    var tempX: Double = 0.0
    var tempY: Double = 0.0
    var tempZ: Double = 0.0

    func setupSteady() {

        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, _) in
                if let acceleration = data?.acceleration {

                    let absX = abs(Int((acceleration.x - self.tempX) * 1000))
                    let absY = abs(Int((acceleration.y - self.tempY) * 1000))
                    let absZ = abs(Int((acceleration.z - self.tempZ) * 1000))
                    self.tempX = acceleration.x
                    self.tempY = acceleration.y
                    self.tempZ = acceleration.z

                    if absX < 30 && absY < 30 && absZ < 30 {
                        self.textSteady.text = "Device is steady"
                        self.isSteady = true
                        self.button.isEnabled = true
                        self.buttonWhite.isEnabled = true
                        self.button.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0)
                    } else {
                        self.textSteady.text = "Device is not steady"
                        self.isSteady = false
                        self.button.isEnabled = true
                        self.buttonWhite.isEnabled = true
                        self.button.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
                    }
                }
            }
        } else {
            print("Device motion is not available.")
            DispatchQueue.main.async {
                self.textSteady.text = "Device is steady"
            }
            isSteady = true
        }

    }

    func isDeviceStable(_ acceleration: CMAcceleration) -> Bool {
        // Implement your logic to determine stability based on accelerometer data
        // You may need to experiment with different threshold values for your specific use case
        let threshold = 0.1

        return abs(acceleration.x) < threshold &&
        abs(acceleration.y) < threshold &&
        abs(acceleration.z) < threshold
    }

    var player = AVPlayer()

    @objc func setupSetUp() {

        buttonClose.isHidden = true
        buttonPathColor.isHidden = true
        buttonWhite.isHidden = true
        buttonSetUp.isHidden = true

        boxView.isHidden = true

        boxNet.isHidden = true

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

        var setupName = "Trajectory"
        if techniqueId == 0 {
            setupName = "Placement"
            netName = "Level1"
        } else if techniqueId == 1 {
            setupName = "Placement"
        }

        // Create a video player
        if let videoURL = Bundle.main.url(forResource: setupName, withExtension: "mov") {
            player = AVPlayer(url: videoURL)

            // Create a player view controller

            playerViewController.player = player
            playerViewController.showsPlaybackControls = false // Disable playback controls
            playerViewController.allowsPictureInPicturePlayback = false // Disable entering fullscreen mode

            // Create a container view with a border radius
            let container = UIView()
            container.frame = CGRect(x: 0, y: 0, width: setupView1.frame.width, height: setupView1.frame.height)
            container.layer.cornerRadius = 12
            container.clipsToBounds = true

            // Add the player view controller's view as a subview of the container
            playerViewController.view.frame = container.bounds
            container.addSubview(playerViewController.view)

            thumbnailImageView.image = UIImage(named: "PlayButton")
            thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(thumbnailImageView)

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
        resetButton.setTitle(skipText, for: .normal)
        resetButton.titleLabel?.font = UIFont(name: "Urbanist", size: 17)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        resetButton.frame = CGRect(x: 0, y: setupView1.frame.maxY + 5, width: setupViewChild.frame.width, height: 40)
        resetButton.addTarget(self, action: #selector(skipVideo), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(skipVideo), for: .touchUpInside)

        setupViewChild.addSubview(resetButton)

        let textLevel = UILabel()
        textLevel.text = "\(setupText) "+techniqueName
        textLevel.font = UIFont(name: "Urbanist", size: 17)
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

        print("DBUGGGGG : SKIP")
//        menuStateApp = "placement"
        contentAnalysisViewController.counter.typeSend(type: String(techniqueId))
        contentAnalysisViewController.counter.levelSend(level: techniqueName)
        contentAnalysisViewController.counter.menuStateSend(menuState: "placement")

        //        boxView.isHidden = false
        buttonClose.isHidden = false
        buttonPathColor.isHidden = false
        buttonWhite.isHidden = false
        buttonSetUp.isHidden = false
        boxNet.isHidden = false
        print("skipVideo")

        playerViewController.player?.pause()
        setupViewParent.removeFromSuperview()
        setupViewChild.removeFromSuperview()
    }

    var latestStatus = ""
    @objc func updateStateMenu() {
        if latestStatus != menuStateApp {
            print("DBUGGGGG : \(latestStatus) - \(menuStateApp)")
            if menuStateApp == "stillPlay"{
                latestStatus = menuStateApp
                print("DBUGGGGG : PLAY")
                startRecording()
            } else  if menuStateApp == "result"{
                latestStatus = menuStateApp
                print("DBUGGGGG : STOP")
                contentAnalysisViewController.stop()
            }
        }
    }

    let pathColorView = UIView()

    @objc func save() {

        //            boxView.isHidden = false
        buttonClose.isHidden = false
        buttonPathColor.isHidden = false
        buttonWhite.isHidden = false
        buttonSetUp.isHidden = false
        boxNet.isHidden = false

        pathColorView.removeFromSuperview()
    }

    let buttonWhite = UIButton(type: .custom)
    let button = UIButton(type: .custom)

    let pathGreen = UIBezierPath()
    let pathYellow = UIBezierPath()
    let pathRed = UIBezierPath()
    let circleGreen = UIView()
    let circleYellow = UIView()
    let circleRed = UIView()

    let circleGreenPath = UIView()
    let circleYellowPath = UIView()
    let circleRedPath = UIView()

    let shapeLayerGreen = CAShapeLayer()
    let shapeLayerRed = CAShapeLayer()
    let shapeLayerYellow = CAShapeLayer()

    let buttonPathColor = UIButton(type: .custom)
    let buttonClose = UIButton(type: .custom)

    let buttonSetUp = UIButton(type: .custom)

    let boxNet = UIView()
    var netName = "NetLevel1"
    let imageNetView = UIImageView()

    var guideBox1 = UIView()
    var guideBox2 = UIView()
    var guideText1 = UILabel()
    var guideText2 = UILabel()

    @objc func openDir() {
        //        print("Open Dir!")
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.movie,
                                                                                UTType.video], asCopy: true)
        docPicker.delegate = self
        docPicker.allowsMultipleSelection = false
        present(docPicker, animated: true, completion: nil)
    }
    @objc func liveCamera() {
        if !isSteady {
            return
        }

        player.pause()
        playerViewController.player = nil

        motionManager.stopAccelerometerUpdates()
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
        contentAnalysisViewController.counter.menuStateSend(menuState: "")
        contentAnalysisViewController.counter.typeSend(type: "")
        contentAnalysisViewController.counter.levelSend(level: "")
        homeDelegate?.back()
    }

    func setupCamera() {

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
    }

}

extension HomeViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        localStorage.saveColor(selectedColor, forKey: colorType)

        // Handle the selected color
        print("Selected Color: \(selectedColor)")

        if colorType == "Green" {
            circleGreenPath.backgroundColor = selectedColor
            circleGreen.backgroundColor = selectedColor
            shapeLayerGreen.strokeColor = selectedColor.cgColor
        } else if colorType == "Yellow" {
            circleYellowPath.backgroundColor = selectedColor
            circleYellow.backgroundColor = selectedColor
            shapeLayerYellow.strokeColor = selectedColor.cgColor
        } else if colorType == "Red" {
            circleRedPath.backgroundColor = selectedColor
            circleRed.backgroundColor = selectedColor
            shapeLayerRed.strokeColor = selectedColor.cgColor
        }
    }
}
