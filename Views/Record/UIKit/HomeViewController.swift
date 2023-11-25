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
                    variance: String)
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
    
    let playerViewController = AVPlayerViewController()
    
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
                    variance: String) {
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
                                 variance: variance)
    }
    
    var homeDelegate: HomeDelegate?
    
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("menuStateApp") var menuStateApp = ""
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
    
    @objc func setupPathColorView(){
        
        
        boxNet.isHidden = true
        
        
        boxView.isHidden = true
        buttonClose.isHidden = true
        buttonPathColor.isHidden = true
        buttonWhite.isHidden = true
        buttonSetUp.isHidden = true
        
        buttonPathColor.isHidden = true
        
        pathColorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(pathColorView)
        
        
        if(techniqueId == 0){
            
            let size:CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 14)
            let cornerRadius = size / 2
            let shape:CGFloat = CGFloat((1-((1.1-Float(localStorage.loadSize(forKey: String(techniqueId))!)) * 2.5)) * 8)
            
            
            
            pathGreen.move(to: CGPoint(x: pathColorView.frame.width/4, y: pathColorView.frame.height/1.7))
            pathGreen.addQuadCurve(to: CGPoint(x: pathColorView.frame.width/1.5, y: pathColorView.frame.height/1.8),
                                   controlPoint: CGPoint(x: pathColorView.frame.width/2.5, y: pathColorView.frame.height/4))
            
            shapeLayerGreen.path = pathGreen.cgPath
            shapeLayerGreen.strokeColor = localStorage.loadColor(forKey: "Green")?.cgColor
            shapeLayerGreen.lineWidth = shape
            shapeLayerGreen.fillColor = UIColor.clear.cgColor
            pathColorView.layer.addSublayer(shapeLayerGreen)
            
            pathYellow.move(to: CGPoint(x: pathColorView.frame.width/5, y: pathColorView.frame.height/1.7))
            pathYellow.addQuadCurve(to: CGPoint(x: pathColorView.frame.width/1.6, y: pathColorView.frame.height/2.3),
                                    controlPoint: CGPoint(x: pathColorView.frame.width/1.8, y: pathColorView.frame.height/8))
            
            shapeLayerYellow.path = pathYellow.cgPath
            shapeLayerYellow.strokeColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
            shapeLayerYellow.lineWidth = shape
            shapeLayerYellow.fillColor = UIColor.clear.cgColor
            pathColorView.layer.addSublayer(shapeLayerYellow)
            
            pathRed.move(to: CGPoint(x: pathColorView.frame.width/3.5, y: pathColorView.frame.height/1.7))
            pathRed.addQuadCurve(to: CGPoint(x: pathColorView.frame.width/2.2, y: pathColorView.frame.height/1.9),
                                 controlPoint: CGPoint(x: pathColorView.frame.width/2.7, y: pathColorView.frame.height/1.8))
            
            shapeLayerRed.path = pathRed.cgPath
            shapeLayerRed.strokeColor = localStorage.loadColor(forKey: "Red")?.cgColor
            shapeLayerRed.lineWidth = shape
            shapeLayerRed.fillColor = UIColor.clear.cgColor
            pathColorView.layer.addSublayer(shapeLayerRed)
            
            
            circleGreen.frame = CGRect(x: (pathColorView.frame.width/2.4) - size/2, y: (pathColorView.frame.height/2.44) - size/2, width: size, height: size)
            circleGreen.layer.cornerRadius = cornerRadius
            circleGreen.layer.masksToBounds = true
            circleGreen.backgroundColor = localStorage.loadColor(forKey: "Green")
            pathColorView.addSubview(circleGreen)
            
            
            
            circleYellow.frame = CGRect(x: (pathColorView.frame.width/1.9) - size/2, y: (pathColorView.frame.height/3.22) - size/2, width: size, height: size)
            circleYellow.layer.opacity = 1
            circleYellow.layer.cornerRadius = cornerRadius
            circleYellow.layer.masksToBounds = true
            circleYellow.backgroundColor = localStorage.loadColor(forKey: "Yellow")
            pathColorView.addSubview(circleYellow)
            
            
            
            circleRed.frame = CGRect(x: (pathColorView.frame.width/2.2) - size/2, y: (pathColorView.frame.height/1.90) - size/2, width: size, height: size)
            circleRed.layer.cornerRadius = cornerRadius
            circleRed.layer.masksToBounds = true
            circleRed.backgroundColor = localStorage.loadColor(forKey: "Red")
            pathColorView.addSubview(circleRed)
            
            pathColorView.addSubview(circleGreen)
            pathColorView.addSubview(circleYellow)
            pathColorView.addSubview(circleRed)
            
        }else if(techniqueId == 1){
            
            let size:CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 20)
            let cornerRadius = size / 2
            
            
            
            circleGreen.frame = CGRect(x: (pathColorView.frame.width * 0.28) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            
            circleGreen.layer.cornerRadius = cornerRadius
            circleGreen.layer.masksToBounds = true
            circleGreen.backgroundColor = localStorage.loadColor(forKey: "Green")
            pathColorView.addSubview(circleGreen)
            
            circleYellow.frame = CGRect(x: (pathColorView.frame.width * 0.38) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            circleYellow.layer.opacity = 1
            circleYellow.layer.cornerRadius = cornerRadius
            circleYellow.layer.masksToBounds = true
            circleYellow.backgroundColor = localStorage.loadColor(forKey: "Yellow")
            pathColorView.addSubview(circleYellow)
            
            circleRed.frame = CGRect(x: (pathColorView.frame.width * 0.18) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            circleRed.layer.opacity = 1
            circleRed.layer.cornerRadius = cornerRadius
            circleRed.layer.masksToBounds = true
            circleRed.backgroundColor = localStorage.loadColor(forKey: "Red")
            pathColorView.addSubview(circleRed)
            
            pathColorView.addSubview(circleGreen)
            pathColorView.addSubview(circleYellow)
            pathColorView.addSubview(circleRed)
            
        }
        
        
        
        boxPathColor.frame = CGRect(x: 0, y: pathColorView.frame.height - 20, width: pathColorView.frame.width / 1.5, height: 154)
        boxPathColor.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        boxPathColor.layer.cornerRadius = 12
        pathColorView.addSubview(boxPathColor)
        boxPathColor.translatesAutoresizingMaskIntoConstraints = false
        boxPathColor.widthAnchor.constraint(equalToConstant: pathColorView.frame.width / 1.5).isActive = true
        boxPathColor.heightAnchor.constraint(equalToConstant: 154).isActive = true
        boxPathColor.centerXAnchor.constraint(equalTo: pathColorView.centerXAnchor, constant: -0.47).isActive = true
        boxPathColor.bottomAnchor.constraint(equalTo: pathColorView.bottomAnchor, constant: -20).isActive = true
        
        let box1 = UIView()
        box1.frame = CGRect(x: 0, y: 15, width: boxPathColor.frame.width/3, height: 34)
        //        box1.backgroundColor = .blue
        
        let text1 = UILabel()
        text1.text = goodTextTrajectory
        text1.font = UIFont(name: "Urbanist", size: 20)
        text1.textColor = UIColor.white
        text1.textAlignment = .right
        text1.frame = CGRect(x: 0, y: 0, width: box1.frame.width/2 - 10, height: 34)
        box1.addSubview(text1)
        let select1 = UIView()
        select1.frame = CGRect(x: (box1.frame.width/2) * 1, y: 0, width: box1.frame.width/3, height: 34)
        select1.backgroundColor = .white
        select1.layer.cornerRadius = 6
        box1.addSubview(select1)
        
        circleGreenPath.frame = CGRect(x: (select1.frame.height-24)/2, y: (select1.frame.height-24)/2, width: 24, height: 24)
        circleGreenPath.layer.opacity = 1
        circleGreenPath.layer.cornerRadius = 12
        circleGreenPath.layer.masksToBounds = true
        circleGreenPath.backgroundColor = localStorage.loadColor(forKey: "Green")
        select1.addSubview(circleGreenPath)
        
        let arrow1 = UIImageView()
        arrow1.frame = CGRect(x: select1.frame.width - 20 - (select1.frame.height-24)/2, y: (select1.frame.height-12)/2, width: 20, height: 12)
        arrow1.image = UIImage(systemName: "chevron.down")
        arrow1.tintColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        arrow1.contentMode = .scaleAspectFit
        select1.addSubview(arrow1)
        
        let box2 = UIView()
        box2.frame = CGRect(x: (boxPathColor.frame.width/3) * 1, y: 15, width: boxPathColor.frame.width/3, height: 34)
        
        let text2 = UILabel()
        text2.text = riskyTextTrajectory
        text2.font = UIFont(name: "Urbanist", size: 20)
        text2.textColor = UIColor.white
        text2.textAlignment = .right
        text2.frame = CGRect(x: 0, y: 0, width: box2.frame.width/2 - 10, height: 34)
        box2.addSubview(text2)
        let select2 = UIView()
        select2.frame = CGRect(x: (box2.frame.width/2) * 1, y: 0, width: box2.frame.width/3, height: 34)
        select2.backgroundColor = .white
        select2.layer.cornerRadius = 6
        box2.addSubview(select2)
        
        
        circleYellowPath.frame = CGRect(x: (select2.frame.height-24)/2, y: (select2.frame.height-24)/2, width: 24, height: 24)
        circleYellowPath.layer.opacity = 1
        circleYellowPath.layer.cornerRadius = 12
        circleYellowPath.layer.masksToBounds = true
        circleYellowPath.backgroundColor = localStorage.loadColor(forKey: "Yellow")
        select2.addSubview(circleYellowPath)
        
        let arrow2 = UIImageView()
        arrow2.frame = CGRect(x: select2.frame.width - 20 - (select2.frame.height-24)/2, y: (select2.frame.height-12)/2, width: 20, height: 12)
        arrow2.image = UIImage(systemName: "chevron.down")
        arrow2.tintColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        arrow2.contentMode = .scaleAspectFit
        select2.addSubview(arrow2)
        
        let box3 = UIView()
        box3.frame = CGRect(x: (boxPathColor.frame.width/3) * 2, y: 15, width: boxPathColor.frame.width/3, height: 34)
        let text3 = UILabel()
        text3.text = badTextTrajectory
        text3.font = UIFont(name: "Urbanist", size: 20)
        text3.textColor = UIColor.white
        text3.textAlignment = .right
        text3.frame = CGRect(x: 0, y: 0, width: box3.frame.width/2 - 10, height: 34)
        box3.addSubview(text3)
        let select3 = UIView()
        select3.frame = CGRect(x: (box3.frame.width/2) * 1, y: 0, width: box3.frame.width/3, height: 34)
        select3.backgroundColor = .white
        select3.layer.cornerRadius = 6
        box3.addSubview(select3)
        
        circleRedPath.frame = CGRect(x: (select3.frame.height-24)/2, y: (select3.frame.height-24)/2, width: 24, height: 24)
        circleRedPath.layer.opacity = 1
        circleRedPath.layer.cornerRadius = 12
        circleRedPath.layer.masksToBounds = true
        circleRedPath.backgroundColor = localStorage.loadColor(forKey: "Red")
        select3.addSubview(circleRedPath)
        
        let arrow3 = UIImageView()
        arrow3.frame = CGRect(x: select3.frame.width - 20 - (select3.frame.height-24)/2, y: (select3.frame.height-12)/2, width: 20, height: 12)
        arrow3.image = UIImage(systemName: "chevron.down")
        arrow3.tintColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        arrow3.contentMode = .scaleAspectFit
        select3.addSubview(arrow3)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(setColorGreen))
        box1.addGestureRecognizer(tap1)
        box1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(setColorYellow))
        box2.addGestureRecognizer(tap2)
        box2.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(setColorRed))
        box3.addGestureRecognizer(tap3)
        box3.isUserInteractionEnabled = true
        
        
        
        let box4 = UIView()
        box4.frame = CGRect(x: 0, y: 35, width: boxPathColor.frame.width/3, height: 34)
        //        box1.backgroundColor = .blue
        
        let text4 = UILabel()
        text4.text = sizeTrajectoryText
        text4.font = UIFont(name: "Urbanist", size: 20)
        text4.textColor = UIColor.white
        text4.textAlignment = .right
        text4.frame = CGRect(x: 0, y: 20, width: box4.frame.width/2 - 10, height: 34)
        box4.addSubview(text4)
        
        let slider = UISlider()
        slider.frame = CGRect(x: pathColorView.frame.width * 0.275, y: pathColorView.frame.height * 0.7, width: pathColorView.frame.width * 0.525, height: 34)
        slider.minimumValue = 0.8
        slider.maximumValue = 1
        slider.value = Float(localStorage.loadSize(forKey: String(techniqueId)) ?? 0.2)
        slider.tintColor = .white
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        pathColorView.addSubview(slider)
        
        
        
        boxPathColor.addSubview(box1)
        boxPathColor.addSubview(box2)
        boxPathColor.addSubview(box3)
        boxPathColor.addSubview(box4)
        
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle(buttonSaveText, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        doneButton.backgroundColor = UIColor(red: 33/255.0, green: 191/255.0, blue: 115/255.0, alpha: 1.0)
        doneButton.layer.cornerRadius = 12
        
        doneButton.frame = CGRect(x: (boxPathColor.frame.width-350)/2, y: 90, width: 350, height: 50)
        doneButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        boxPathColor.addSubview(doneButton)
        
        
    }
    
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        print("Slider value: \(sender.value)")
        if(techniqueId == 0){
            localStorage.saveSize(sender.value, forKey: String(techniqueId))
            let size:CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 14)
            let cornerRadius = size / 2
            let shape:CGFloat = CGFloat((1-((1.1-Float(localStorage.loadSize(forKey: String(techniqueId))!)) * 2.5)) * 8)
            
            shapeLayerGreen.lineWidth = shape
            shapeLayerYellow.lineWidth = shape
            shapeLayerRed.lineWidth = shape
            circleGreen.frame = CGRect(x: (pathColorView.frame.width/2.4) - size/2, y: (pathColorView.frame.height/2.44) - size/2, width: size, height: size)
            circleYellow.frame = CGRect(x: (pathColorView.frame.width/1.9) - size/2, y: (pathColorView.frame.height/3.22) - size/2, width: size, height: size)
            circleRed.frame = CGRect(x: (pathColorView.frame.width/2.2) - size/2, y: (pathColorView.frame.height/1.90) - size/2, width: size, height: size)
            circleGreen.layer.cornerRadius = cornerRadius
            circleYellow.layer.cornerRadius = cornerRadius
            circleRed.layer.cornerRadius = cornerRadius
        }else if(techniqueId == 1){
            localStorage.saveSize(sender.value, forKey: String(techniqueId))
            let size:CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 20)
            let cornerRadius = size / 2
            circleGreen.frame = CGRect(x: (pathColorView.frame.width * 0.28) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            circleYellow.frame = CGRect(x: (pathColorView.frame.width * 0.38) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            circleRed.frame = CGRect(x: (pathColorView.frame.width * 0.18) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            
            circleGreen.layer.cornerRadius = cornerRadius
            circleYellow.layer.cornerRadius = cornerRadius
            circleRed.layer.cornerRadius = cornerRadius
        }
    }
    
    func playerViewControllerDidDismiss(_ playerViewController: AVPlayerViewController) {
        print("Stop Fullscreen")
    }
    
    var tempX:Double = 0.0
    var tempY:Double = 0.0
    var tempZ:Double = 0.0
    
    
    func setupSteady() {
        
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if let acceleration = data?.acceleration {
                    
                    
                    let absX = abs(Int((acceleration.x - self.tempX) * 1000))
                    let absY = abs(Int((acceleration.y - self.tempY) * 1000))
                    let absZ = abs(Int((acceleration.z - self.tempZ) * 1000))
                    self.tempX = acceleration.x
                    self.tempY = acceleration.y
                    self.tempZ = acceleration.z
                    
                    if(absX < 30 && absY < 30 && absZ < 30){
                        self.textSteady.text = "Device is steady"
                        self.isSteady = true
                        self.button.isEnabled = true
                        self.buttonWhite.isEnabled = true
                        self.button.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0)
                    }else{
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
            let player = AVPlayer(url: videoURL)
            
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
        
        
        menuStateApp = "placement"
        
        
        //        boxView.isHidden = false
        buttonClose.isHidden = false
        buttonPathColor.isHidden = false
        buttonWhite.isHidden = false
        buttonSetUp.isHidden = false
        boxNet.isHidden = false
        print("skipVideo")
        contentAnalysisViewController.counter.menuStateSend(menuState: "placement")
        playerViewController.player?.pause()
        setupViewParent.removeFromSuperview()
        setupViewChild.removeFromSuperview()
    }
    
    
    
    var latestStatus = ""
    @objc func updateStateMenu(){
        if(latestStatus != menuStateApp){
            latestStatus = menuStateApp
            if(menuStateApp == "stillPlay"){
                print("DBUGGGGG : PLAY")
                liveCamera()
            } else if(menuStateApp == "result"){
                print("DBUGGGGG : STOP")
                contentAnalysisViewController.stop()
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
            
            //            guideBox2.frame = CGRect(x: view.frame.width * 0.5 - 450/2, y: view.frame.height * 0.5, width: 450, height: 58)
            //            guideBox2.alpha = 0.9
            //            guideBox2.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            //            guideBox2.layer.cornerRadius = 32
            //            boxNet.addSubview(guideBox2)
            //            guideText2 = UILabel(frame: CGRect(x: 0, y: 0, width: guideBox2.frame.width, height: guideBox2.frame.height))
            //            guideText2.text = "Place the tripod facing the shuttlecock placement area.\nAdjust the camera according to the guide lines."
            //            guideText2.textColor = UIColor.white
            //            guideText2.textAlignment = .center
            //            guideText2.font = UIFont(name: "Urbanist", size: 17)
            //            guideText2.numberOfLines = 2
            //            guideText2.lineBreakMode = .byWordWrapping
            //            guideBox2.addSubview(guideText2)
            
            
        }
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDir))
        //        view.isUserInteractionEnabled = true
        //        view.addGestureRecognizer(tapGesture)
        
        
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
        
        buttonWhite.frame = CGRect(x: view.frame.size.width - 70 + 20 - (32/2), y: (view.frame.size.height/2) - (32/2), width: 64, height: 64)
        buttonWhite.backgroundColor = nil
        buttonWhite.layer.cornerRadius = 32
        buttonWhite.clipsToBounds = true
        buttonWhite.layer.borderWidth = 3.0
        buttonWhite.layer.borderColor = UIColor.white.cgColor
        buttonWhite.addTarget(self, action: #selector(liveCamera), for: .touchUpInside)
        view.addSubview(buttonWhite)
        
        
        
        button.frame = CGRect(x: 5, y: 5, width: 54, height: 54)
        button.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0)
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(liveCamera), for: .touchUpInside)
        
        buttonWhite.addSubview(button)
        
        
        
    }
    
    @objc func openDir() {
        //        print("Open Dir!")
        let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.movie,
                                                                                UTType.video], asCopy: true)
        docPicker.delegate = self
        docPicker.allowsMultipleSelection = false
        present(docPicker, animated: true, completion: nil)
    }
    @objc func liveCamera(){
        if(!isSteady){
            return
        }
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
