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
import CoreMotion
import ReplayKit
import HealthKit

protocol HomeDelegate: AnyObject {
    func back()
    
    func saveRecord(url: URL,
                    duration: String,
                    hitFail: Int,
                    hitPerfect: Int,
                    hitSuccess: Int,
                    hitTarget: Int,
                    hitTotal: Int,
                    level: String,
                    result: String,
                    minDistance: Double,
                    avgDistance: Double,
                    variance: String,
                    caloriesBurned: Double,
                    avgHeartRate: Double)
}

class HomeViewController: UIViewController, ContentAnalysisDelegate {
    let localStorage = LocalStorage()
    
    let motionManager = CMMotionManager()
    
    var transformedYValuesAccepted :Double = 0.0
    var minDistance :Double = 0.0
    var averageOfDistance :Double = 0.0
    var variance :String = ""
    
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
//    var calorieCount: Double = 0.0
//    var startTime: Date?
//    var calorieTimer: Timer?
//    let calorieBurnRatePerMinute: Double = 10.0
//    var caloriesBurned = 0.0
    
    let playerViewController = AVPlayerViewController()
    
   
    
    func stopRecordScreen() async throws -> URL {
        let name = "\(UUID().uuidString).mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        let recorder = RPScreenRecorder.shared()
        try await recorder.stopRecording(withOutput: url)
        return url
    }

    @objc func startRecording() {
        startRecordScreen { error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
        }
//        self.startCalorieTracking()
//        print("Start Tracking!")
    }

    func stopVideoPlayer() {
        playerViewController.player?.pause()
        playerViewController.player = nil
    }

    func startRecordScreen(
        enableMic: Bool = false,
        completion: @escaping (Error?) -> ()
    ) {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = enableMic
        recorder.startRecording(handler: completion)
        
        if recorder.isRecording {
            print("RECORD")
//            self.startCalorieTracking()
            liveCamera()
        } else {
            print("NOT RECORD")
            latestStatus = ""
        }
    }

    func stopRecording() {
        Task {
            do {
                let url = try await stopRecordScreen()
                try FileManager.default.removeItem(at: url)
            } catch {
                print(error.localizedDescription)
            }
        }
        print("Stop Recording!")
    }

    
    func saveRecord(url: URL,
                    duration: String,
                    hitFail: Int,
                    hitPerfect: Int,
                    hitSuccess: Int,
                    hitTarget: Int,
                    hitTotal: Int,
                    level: String,
                    result: String,
                    minDistance: Double,
                    avgDistance: Double,
                    variance: String,
                    caloriesBurned: Double,
                    avgHeartRate: Double) {
        homeDelegate?.saveRecord(url: url,
                                 duration: duration,
                                 hitFail: hitFail,
                                 hitPerfect: hitPerfect,
                                 hitSuccess: hitSuccess,
                                 hitTarget: hitTarget,
                                 hitTotal: hitTotal,
                                 level: level,
                                 result: result,
                                 minDistance: minDistance,
                                 avgDistance: avgDistance,
                                 variance: variance,
                                 caloriesBurned: caloriesBurned,
                                 avgHeartRate: avgHeartRate)
    }
    
    weak var homeDelegate: HomeDelegate?
    
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
    
    @IBAction func startCameraForAnalysis(_ sender: Any) {
        performSegue(withIdentifier: ContentAnalysisViewController.segueDestinationId,
                     sender: self)
    }
    
    var boxView = UIView()
    var textSteady = UILabel()
    var isSteady = false
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupView()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStateMenu), userInfo: nil, repeats: true)
        contentAnalysisViewController.contentAnalysisDelegate = self
        
        contentAnalysisViewController.counter.typeSend(type: String(techniqueId))
        contentAnalysisViewController.counter.levelSend(level: techniqueName)
        
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
    
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        playerViewController.player = nil
        timer?.invalidate()
        timer = nil
        stopVideoPlayer()
        removeSubview(boxView)
        removeSubview(boxPathColor)
        removeSubview(setupViewChild)
        removeSubview(setupViewParent)
        removeSubview(boxCountdown)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let presentingVC = self.presentingViewController {
            presentingVC.dismiss(animated: false) {
                print("Previous view controller has been dismissed")
            }
        }
    }
    
    @objc func appDidBecomeActive() {
        if player != nil && player.timeControlStatus == .paused {
            player.play()
        }
    }

    @objc func appDidEnterBackground() {
        if player != nil && player.timeControlStatus == .playing {
            player.pause()
        }
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func removeSubview(_ subview: UIView) {
        subview.removeFromSuperview()
    }
    
    let boxPathColor = UIView()
    
    @objc func setupPathColorView() {
        hideUIElements()
        setupPathColorViewFrame()
        
        if techniqueId == 0 {
            setupTechnique0()
        } else if techniqueId == 1 {
            setupTechnique1()
        }
        
        setupBoxPathColor()
        setupButtons()
    }

    private func hideUIElements() {
        boxNet.isHidden = true
        boxView.isHidden = true
        buttonClose.isHidden = true
        buttonPathColor.isHidden = true
        buttonWhite.isHidden = true
        buttonSetUp.isHidden = true
    }

    private func setupPathColorViewFrame() {
        pathColorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(pathColorView)
    }

    private func setupTechnique0() {
        let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 14)
        let cornerRadius = size / 2
        let shape: CGFloat = CGFloat((1 - ((1.1 - Float(localStorage.loadSize(forKey: String(techniqueId))!)) * 2.5)) * 8)
        
        addPath(to: pathGreen, strokeColor: localStorage.loadColor(forKey: "Green"), lineWidth: shape)
        addPath(to: pathYellow, strokeColor: localStorage.loadColor(forKey: "Yellow"), lineWidth: shape)
        addPath(to: pathRed, strokeColor: localStorage.loadColor(forKey: "Red"), lineWidth: shape)
        
        addCircle(to: circleGreen, color: localStorage.loadColor(forKey: "Green"), size: size, cornerRadius: cornerRadius, position: CGPoint(x: pathColorView.frame.width/2.4 - size/2, y: pathColorView.frame.height/2.44 - size/2))
        addCircle(to: circleYellow, color: localStorage.loadColor(forKey: "Yellow"), size: size, cornerRadius: cornerRadius, position: CGPoint(x: pathColorView.frame.width/1.9 - size/2, y: pathColorView.frame.height/3.22 - size/2))
        addCircle(to: circleRed, color: localStorage.loadColor(forKey: "Red"), size: size, cornerRadius: cornerRadius, position: CGPoint(x: pathColorView.frame.width/2.2 - size/2, y: pathColorView.frame.height/1.90 - size/2))
    }

    private func setupTechnique1() {
        let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 20)
        let cornerRadius = size / 2
        
        addCircle(to: circleGreen, color: localStorage.loadColor(forKey: "Green"), size: size, cornerRadius: cornerRadius, position: CGPoint(x: pathColorView.frame.width * 0.28 - size/2, y: pathColorView.frame.height * 0.4 - size/2))
        addCircle(to: circleYellow, color: localStorage.loadColor(forKey: "Yellow"), size: size, cornerRadius: cornerRadius, position: CGPoint(x: pathColorView.frame.width * 0.38 - size/2, y: pathColorView.frame.height * 0.4 - size/2))
        addCircle(to: circleRed, color: localStorage.loadColor(forKey: "Red"), size: size, cornerRadius: cornerRadius, position: CGPoint(x: pathColorView.frame.width * 0.18 - size/2, y: pathColorView.frame.height * 0.4 - size/2))
    }

    private func addPath(to path: UIBezierPath, strokeColor: UIColor?, lineWidth: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = strokeColor?.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        pathColorView.layer.addSublayer(shapeLayer)
    }

    private func addCircle(to circleView: UIView, color: UIColor?, size: CGFloat, cornerRadius: CGFloat, position: CGPoint) {
        circleView.frame = CGRect(origin: position, size: CGSize(width: size, height: size))
        circleView.layer.cornerRadius = cornerRadius
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = color
        pathColorView.addSubview(circleView)
    }

    private func setupBoxPathColor() {
        boxPathColor.frame = CGRect(x: 0, y: pathColorView.frame.height - 20, width: pathColorView.frame.width / 1.5, height: 154)
        boxPathColor.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        boxPathColor.layer.cornerRadius = 12
        pathColorView.addSubview(boxPathColor)
        boxPathColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boxPathColor.widthAnchor.constraint(equalToConstant: pathColorView.frame.width / 1.5),
            boxPathColor.heightAnchor.constraint(equalToConstant: 154),
            boxPathColor.centerXAnchor.constraint(equalTo: pathColorView.centerXAnchor, constant: -0.47),
            boxPathColor.bottomAnchor.constraint(equalTo: pathColorView.bottomAnchor, constant: -20)
        ])
    }

    private func setupButtons() {
        let buttonWidth = boxPathColor.frame.width / 2 - 50
        
        let doneButton = createButton(title: buttonSaveText, backgroundColor: UIColor(red: 33/255.0, green: 191/255.0, blue: 115/255.0, alpha: 1.0), action: #selector(save))
        doneButton.frame = CGRect(x: buttonWidth + 74, y: 100, width: buttonWidth, height: 40)
        
        let closeButton = createButton(title: closeButtonText, backgroundColor: UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), action: #selector(close))
        closeButton.frame = CGRect(x: 30, y: 100, width: buttonWidth, height: 40)
        
        boxPathColor.addSubview(closeButton)
        boxPathColor.addSubview(doneButton)
    }

    private func createButton(title: String, backgroundColor: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc func close() {
    }
    
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        print("Slider value: \(sender.value)")
        
        localStorage.saveSize(sender.value, forKey: String(techniqueId))
        guard let savedSize = localStorage.loadSize(forKey: String(techniqueId)) else { return }
        
        let sizeMultiplier: CGFloat = techniqueId == 0 ? 14 : 20
        let size: CGFloat = CGFloat(savedSize) * sizeMultiplier

        let cornerRadius = size / 2
        
        if techniqueId == 0 {
            adjustShapeLayerSize(for: size)
            adjustShapeLayerLineWidth(for: savedSize)
            adjustCircleFrames(size: size, xMultiplier: [2.4, 1.9, 2.2], yMultiplier: [2.44, 3.22, 1.90])
        } else if techniqueId == 1 {
            adjustCircleFrames(size: size, xMultiplier: [0.28, 0.38, 0.18], yMultiplier: [0.4, 0.4, 0.4])
        }
        
        circleGreen.layer.cornerRadius = cornerRadius
        circleYellow.layer.cornerRadius = cornerRadius
        circleRed.layer.cornerRadius = cornerRadius
    }

    private func adjustShapeLayerSize(for size: CGFloat) {
        shapeLayerGreen.lineWidth = size
        shapeLayerYellow.lineWidth = size
        shapeLayerRed.lineWidth = size
    }

    private func adjustShapeLayerLineWidth(for savedSize: Float) {
        let shape: CGFloat = CGFloat((1 - ((1.1 - savedSize) * 2.5)) * 8)
        shapeLayerGreen.lineWidth = shape
        shapeLayerYellow.lineWidth = shape
        shapeLayerRed.lineWidth = shape
    }

    private func adjustCircleFrames(size: CGFloat, xMultiplier: [CGFloat], yMultiplier: [CGFloat]) {
        let xCoordinates = xMultiplier.map { pathColorView.frame.width / $0 - size / 2 }
        let yCoordinates = yMultiplier.map { pathColorView.frame.height / $0 - size / 2 }
        
        circleGreen.frame = CGRect(x: xCoordinates[0], y: yCoordinates[0], width: size, height: size)
        circleYellow.frame = CGRect(x: xCoordinates[1], y: yCoordinates[1], width: size, height: size)
        circleRed.frame = CGRect(x: xCoordinates[2], y: yCoordinates[2], width: size, height: size)
    }

    
    func playerViewControllerDidDismiss(_ playerViewController: AVPlayerViewController) {
        print("Stop Fullscreen")
    }
    
    var tempX:Double = 0.0
    var tempY:Double = 0.0
    var tempZ:Double = 0.0
    
    
    func setupSteady() {
        guard motionManager.isAccelerometerAvailable else {
            updateSteadyStatus(isSteady: true)
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let self = self, let acceleration = data?.acceleration else { return }
            
            let absX = abs(Int((acceleration.x - self.tempX) * 1000))
            let absY = abs(Int((acceleration.y - self.tempY) * 1000))
            let absZ = abs(Int((acceleration.z - self.tempZ) * 1000))
            
            self.tempX = acceleration.x
            self.tempY = acceleration.y
            self.tempZ = acceleration.z
            
            let isSteady = absX < 30 && absY < 30 && absZ < 30
            self.updateSteadyStatus(isSteady: isSteady)
        }
    }

    private func updateSteadyStatus(isSteady: Bool) {
        textSteady.text = isSteady ? "Device is steady" : "Device is not steady"
        self.isSteady = isSteady
        button.isEnabled = true
        buttonWhite.isEnabled = true
        button.backgroundColor = isSteady ? UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0) : UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
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
    
    
    @objc func setupSetUp(){
        
        
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
        if(techniqueId == 0){
            setupName = "Placement"
            netName = "Level1"
        }else if(techniqueId == 1){
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
        
        if let containerView = playerViewController.view.superview {
               containerView.removeFromSuperview()
           }
        playerViewController.player = nil
        
        playerViewController.player?.pause()
        playerViewController.view.removeFromSuperview()
        setupViewParent.removeFromSuperview()
        setupViewChild.removeFromSuperview()
        thumbnailImageView.removeFromSuperview()
    }
    
    
    
    var latestStatus = ""
    @objc func updateStateMenu(){
        if(latestStatus != menuStateApp){
            print("DBUGGGGG : \(latestStatus) - \(menuStateApp)")
            if(menuStateApp == "stillPlay"){
                latestStatus = menuStateApp
                print("DBUGGGGG : PLAY")
                startRecording()
            } else  if(menuStateApp == "result"){
                latestStatus = menuStateApp
                print("DBUGGGGG : STOP")
                contentAnalysisViewController.stop()
//                self.stopCalorieTracking()
            }
        }
    }
    
    let pathColorView = UIView()
    
    
    
    @objc func setColorGreen() {
        colorType = "Green"
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        if let popoverPresentationController = colorPicker.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 1.5)
            popoverPresentationController.permittedArrowDirections = [.up]
        }
        present(colorPicker, animated: true, completion: nil)
    }
    @objc func setColorYellow(){
        colorType = "Yellow"
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        if let popoverPresentationController = colorPicker.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 1.5)
            popoverPresentationController.permittedArrowDirections = [.up]
        }
        present(colorPicker, animated: true, completion: nil)
    }
    @objc func setColorRed(){
        colorType = "Red"
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        if let popoverPresentationController = colorPicker.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 1.5)
            popoverPresentationController.permittedArrowDirections = [.up]
        }
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func save(){
        
        
        
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
    
    func setupView(){
        
        imageNetView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        boxNet.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //        boxNet.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        boxNet.layer.cornerRadius = 4
        
        
        
        
        if(techniqueId == 0){
            netName = "NetLevel2"
            if let image = UIImage(named: netName) {
                imageNetView.image = image
            }
            view.addSubview(imageNetView)
            view.addSubview(boxNet)
            
            
            guideBox1.frame = CGRect(x: view.frame.width * 0.5 - 320/2, y: view.frame.height * 0.1, width: 320, height: 60)
            guideBox1.alpha = 1
            guideBox1.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            guideBox1.layer.cornerRadius = 32
            boxNet.addSubview(guideBox1)
            
            guideText1 = UILabel(frame: CGRect(x: 0, y: 0, width: guideBox1.frame.width, height: guideBox1.frame.height))
            guideText1.text = trajectoryTutorialTextOne
            guideText1.textColor = UIColor.white
            guideText1.textAlignment = .center
            guideText1.font = UIFont(name: "Urbanist", size: 17)
            guideText1.numberOfLines = 2
            guideText1.lineBreakMode = .byWordWrapping
            guideBox1.addSubview(guideText1)
            
            let pathLine = UIBezierPath()
            pathLine.move(to: CGPoint(x: view.frame.width * 0.471, y: view.frame.height * 0.45))
            pathLine.addLine(to: CGPoint(x: view.frame.width * 0.5 + 50, y: view.frame.height * 0.45))
            
            let shapeLayer = CAShapeLayer()
            let pathView = UIView()
            
            shapeLayer.path = pathLine.cgPath
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 2.0
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineDashPattern = [4, 2]
            //            shapeLayer.lineCap = .round
            
            pathView.layer.addSublayer(shapeLayer)
            
            boxNet.addSubview(pathView)
            
            guideBox2.frame = CGRect(x: view.frame.width * 0.5 + 50, y: view.frame.height * 0.4, width: 130, height: 36)
            guideBox2.alpha = 1
            guideBox2.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            guideBox2.layer.cornerRadius = 18
            boxNet.addSubview(guideBox2)
            guideText2 = UILabel(frame: CGRect(x: 0, y: 0, width: guideBox2.frame.width, height: guideBox2.frame.height))
            guideText2.text = trajectoryTutorialTextTwo
            guideText2.textColor = UIColor.white
            guideText2.textAlignment = .center
            guideText2.font = UIFont(name: "Urbanist", size: 17)
            guideText2.numberOfLines = 2
            guideText2.lineBreakMode = .byWordWrapping
            guideBox2.addSubview(guideText2)
            
            
            
            
            
        }else if(techniqueId == 1){
            netName = "NetLevel3"
            if let image = UIImage(named: netName) {
                imageNetView.image = image
            }
            view.addSubview(imageNetView)
            view.addSubview(boxNet)
            
            
            guideBox1.frame = CGRect(x: view.frame.width - 400 - 97, y: view.frame.height - 90 - 20, width: 400, height: 90)
            guideBox1.alpha = 0.9
            guideBox1.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            guideBox1.layer.cornerRadius = 32
            boxNet.addSubview(guideBox1)
            
            guideText1 = UILabel(frame: CGRect(x: 0, y: 0, width: guideBox1.frame.width, height: guideBox1.frame.height))
            guideText1.text = servePlacementGuidlineText
            guideText1.textColor = UIColor.white
            guideText1.textAlignment = .center
            guideText1.font = UIFont(name: "Urbanist", size: 17)
            guideText1.numberOfLines = 3
            guideText1.lineBreakMode = .byWordWrapping
            guideBox1.addSubview(guideText1)
            
        }
        
        
        let image2 = UIImage(named: "CPButtonID")
        buttonSetUp.setImage(image2, for: .normal)
        buttonSetUp.imageView?.contentMode = .scaleAspectFit
        buttonSetUp.frame = CGRect(x: view.frame.width - 130 - 90, y: 20, width: 130, height: 40)
        buttonSetUp.addTarget(self, action: #selector(setupSetUp), for: .touchUpInside)
        view.addSubview(buttonSetUp)
        
        
        let image3 = UIImage(named: "CloseButton")
        buttonClose.setImage(image3, for: .normal)
        buttonClose.imageView?.contentMode = .scaleAspectFit
        buttonClose.frame = CGRect(x: 20 + 70, y: 20, width: 40, height: 40)
        buttonClose.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(buttonClose)
        
        
        let image4 = UIImage(named: "PathColorButtonID")
        buttonPathColor.setImage(image4, for: .normal)
        buttonPathColor.imageView?.contentMode = .scaleAspectFit
        buttonPathColor.frame = CGRect(x: 20 + 70, y: view.frame.height-20-40, width: 130, height: 40)
        buttonPathColor.addTarget(self, action: #selector(setupPathColorView), for: .touchUpInside)
        view.addSubview(buttonPathColor)
        
        
        let iconClose = UIImage(systemName: "xmark")
        let iconImageView = UIImageView(image: iconClose)
        iconImageView.tintColor = .white
        iconImageView.frame = CGRect(x:10, y: 10, width: 20, height: 20)
        buttonClose.addSubview(iconImageView)
        
        buttonWhite.frame = CGRect(x: view.frame.size.width - 70 + 18 - (32/2), y: (view.frame.size.height/2) - (32/2), width: 64, height: 64)
        buttonWhite.backgroundColor = nil
        buttonWhite.layer.cornerRadius = 32
        buttonWhite.clipsToBounds = true
        buttonWhite.layer.borderWidth = 3.0
        buttonWhite.layer.borderColor = UIColor.white.cgColor
        buttonWhite.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        view.addSubview(buttonWhite)
        
        
        
        button.frame = CGRect(x: 5, y: 5, width: 54, height: 54)
        button.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0)
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        
        buttonWhite.addSubview(button)
        
        
        
    }
    
    @objc func liveCamera(){
        if(!isSteady){
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
