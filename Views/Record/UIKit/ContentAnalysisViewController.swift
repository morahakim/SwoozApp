/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The app's view controller that handles the trajectory analysis.
 */

import UIKit
import AVFoundation
import Vision
import SwiftUI
import ReplayKit


// TODO: buat delegate function save
protocol ContentAnalysisDelegate: AnyObject {
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
                    variance: String
    )
}

class ContentAnalysisViewController: UIViewController,
                                     AVCaptureVideoDataOutputSampleBufferDelegate {
    let counter = Counter()
    let localStorage = LocalStorage()
    
    var averageOfDistance: Double = 0.0
    var minDistance: Double = 0.0
    var variance: String = ""
    
    @AppStorage("type") var type: String = "Low Serve"
    @AppStorage("techniqueName") var techniqueName: String = ""
    @AppStorage("techniqueId") var techniqueId: Int = 0
    @AppStorage("isOnRecord") var isOnRecord = true
    @AppStorage("dataUrl") var dataUrl: String = ""
    
    @AppStorage("arrResult") var arrResult: String = ""
    
    // TODO: variable delegate untuk panggil function delegate
    var contentAnalysisDelegate: ContentAnalysisDelegate?
    
    func startRecordScreen(
        enableMic: Bool = false,
        completion: @escaping (Error?) -> ()
    ) {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = enableMic
        recorder.startRecording(handler: completion)
    }
    
    func stopRecordScreen() async throws -> URL {
        let name = "\(UUID().uuidString).mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        let nameCropped = "\(UUID().uuidString)-cropped.mov"
        let urlCropped = FileManager.default.temporaryDirectory.appendingPathComponent(nameCropped)
        let recorder = RPScreenRecorder.shared()
        
        try await recorder.stopRecording(withOutput: url)
        
        
        cropVideoToSize(inputURL: url, outputURL: urlCropped, cropRect: CGRect(x: -120, y: 0, width: view.frame.width + 210, height: view.frame.height+210))
        
        
        return urlCropped
        //        return url
    }
    
    
    func cropVideoToSize(inputURL: URL, outputURL: URL, cropRect: CGRect) {
        // Create an AVAsset from the input video URL
        let asset = AVAsset(url: inputURL)
        
        // Create an AVAssetTrack for the video track
        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            print("Video track not found")
            return
        }
        
        // Create a mutable composition for the video
        let composition = AVMutableComposition()
        
        // Add a video track to the composition
        guard let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            print("Failed to add video track to composition")
            return
        }
        
        do {
            // Insert the video track from the asset into the composition
            try compositionVideoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration),
                                                      of: videoTrack,
                                                      at: .zero)
        } catch {
            print("Error inserting video track into composition: \(error)")
            return
        }
        
        // Create a video composition instruction
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: asset.duration)
        
        // Set up the transformer to crop the video
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        let scale = max(cropRect.width / videoTrack.naturalSize.width, cropRect.height / videoTrack.naturalSize.height)
        let transform = CGAffineTransform(translationX: cropRect.origin.x, y: cropRect.origin.y)
            .scaledBy(x: scale, y: scale)
        transformer.setTransform(transform, at: .zero)
        
        // Set the instructions for the composition
        instruction.layerInstructions = [transformer]
        
        // Create a video composition
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = [instruction]
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30) // Assuming 30 frames per second
        videoComposition.renderSize = CGSize(width: cropRect.width, height: cropRect.height)
        
        // Export the composition to the output URL
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            print("Failed to create export session")
            return
        }
        
        exporter.outputURL = outputURL
        exporter.outputFileType = .mp4
        exporter.videoComposition = videoComposition
        
        exporter.exportAsynchronously {
            switch exporter.status {
            case .completed:
                print("Video export successful")
            case .failed:
                print("Video export failed: \(exporter.error?.localizedDescription ?? "Unknown error")")
            case .cancelled:
                print("Video export cancelled")
            default:
                break
            }
        }
    }
    
    
    
    
    func save(url: URL,
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
        
        
        contentAnalysisDelegate?.saveRecord(url: url,
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
    
    // MARK: - Static Properties
    static let segueDestinationId = "ShowAnalysisView"
    
    // MARK: - IBOutlets
    @IBOutlet var closeButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func closeRootViewTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Public Properties
    var recordedVideoSource: AVAsset?
    
    // MARK: - Private Properties
    private var cameraViewController: CameraViewController!
    private var trajectoryView = TrajectoryView()
    private var setupComplete = false
    private var detectTrajectoryRequest: VNDetectTrajectoriesRequest!
    
    
    // A dictionary that stores all trajectories.
    private var trajectoryDictionary: [String: [VNPoint]] = [:]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        hitFailApp = 0
        hitTotalApp = 0
        hitSuccessApp = 0
        hitPerfectApp = 0
        durationApp = "00:00"
        arrResult = ""
        
        configureView()
        setupView()
        startCountdown()
    }
    
    
    let setupViewParent = UIView()
    let setupViewChild = UIView()
    let boxScore = UIView()
    
    var text0a = UILabel()
    let text0b = UILabel()
    var text1a = UILabel()
    let text1b = UILabel()
    var text2a = UILabel()
    let text2b = UILabel()
    var text3a = UILabel()
    let text3b = UILabel()
    var text4a = UILabel()
    let text4b = UILabel()
    var text5a = UILabel()
    let text5b = UILabel()
    var text6a = UILabel()
    let text6b = UILabel()
    let box0 = UIView()
    let box1 = UIView()
    let box2 = UIView()
    let box3 = UIView()
    let box4 = UIView()
    let box5 = UIView()
    let box6 = UIView()
    
    
    @objc func back(){
        print("Back!")
        //        let menuState = "result"
        //        counter.menuStateSend(menuState:menuState)
        menuStateApp = ""
        isOnRecord = false
    }
    
    var arrHitStatistics : [HitStatistics] = [
    ]
    struct HitStatistics: Identifiable, Hashable {
        var id = UUID()
        var hitNumber: String
        var hitStatus: String
        var hitDistance: Double
        var hitMinDistance: Double
        var hitAverageOfDistance: Double
        var hitVariance: String
    }
    
    
    func setupResultView(){
        
        setupViewParent.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        setupViewParent.backgroundColor = .black
        setupViewParent.alpha = 0.5
        view.addSubview(setupViewParent)
        
        
        setupViewChild.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        setupViewChild.backgroundColor = nil
        view.addSubview(setupViewChild)
        
        
        
        
        let setupView1 = UIView()
        setupView1.backgroundColor = nil
        setupView1.frame = CGRect(x: 0, y: 0, width: view.frame.width/1.5, height: view.frame.height/1.1)
        setupView1.center = view.center
        setupViewChild.addSubview(setupView1)
        
        setupView1.translatesAutoresizingMaskIntoConstraints = false
        setupView1.heightAnchor.constraint(equalToConstant: view.frame.height/1.1).isActive = true
        setupView1.widthAnchor.constraint(equalToConstant: view.frame.width/1.5).isActive = true
        setupView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupView1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //        techniqueName = "Servis Rendah - Lintasan"
        let textLevel = UILabel()
        textLevel.text = techniqueName
        textLevel.font = UIFont(name: "Urbanist", size: 17)
        textLevel.textColor = UIColor.white
        textLevel.textAlignment = .center
        textLevel.frame = CGRect(x: 0, y: 0, width: setupView1.frame.width, height: 20)
        setupView1.addSubview(textLevel)
        
        box0.frame = CGRect(x: 0, y: 50, width: setupView1.frame.width/5, height: 65)
        //        box0.backgroundColor = UIColor.red
        setupView1.addSubview(box0)
        
        
        
        //        text0a.text = String(format: "%02d", Int(successRate))+"%"
        //        text0a.font = UIFont(name: "Urbanist-Medium", size: 34)
        //        text0a.textColor = UIColor.white
        //        text0a.textAlignment = .center
        //        text0a.frame = CGRect(x: 0, y: 5, width: box0.frame.width, height: 30)
        //
        //        text0b.text = "Success Rate"
        //        text0b.font = UIFont(name: "Urbanist", size: 17)
        //        text0b.textColor = UIColor.white
        //        text0b.textAlignment = .center
        //        text0b.frame = CGRect(x: 0, y: box0.frame.height-20, width: box0.frame.width, height: 20)
        //
        //        box0.addSubview(text0a)
        //        box0.addSubview(text0b)
        
        box1.frame = CGRect(x: (setupView1.frame.width/4)*0, y:  50, width: setupView1.frame.width/4, height: 65)
        //        box1.backgroundColor = UIColor.red
        setupView1.addSubview(box1)
        
        text1a.text = String(format: "%02d",hitTotal)
        text1a.font = UIFont(name: "Urbanist-Medium", size: 34)
        text1a.textColor = UIColor.white
        text1a.textAlignment = .center
        text1a.frame = CGRect(x: 0, y: 5, width: box1.frame.width, height: 30)
        
        text1b.text = tryingText
        text1b.font = UIFont(name: "Urbanist", size: 17)
        text1b.textColor = UIColor.white
        text1b.textAlignment = .center
        text1b.frame = CGRect(x: 0, y: box1.frame.height-20, width: box1.frame.width, height: 20)
        
        box1.addSubview(text1a)
        box1.addSubview(text1b)
        
        
        box2.frame = CGRect(x: (setupView1.frame.width/4)*1, y:  50, width: setupView1.frame.width/4, height: 65)
        //        box2.backgroundColor = UIColor.red
        setupView1.addSubview(box2)
        
        text2a.text = String(format: "%02d", hitPerfect)
        text2a.font = UIFont(name: "Urbanist-Medium", size: 34)
        text2a.textColor = UIColor.white
        text2a.textAlignment = .center
        text2a.frame = CGRect(x: 0, y: 5, width: box2.frame.width, height: 30)
        
        text2b.text = goodTextTrajectory
        text2b.font = UIFont(name: "Urbanist", size: 17)
        text2b.textColor = UIColor.white
        text2b.textAlignment = .center
        text2b.frame = CGRect(x: 0, y: box2.frame.height-20, width: box2.frame.width, height: 20)
        
        box2.addSubview(text2a)
        box2.addSubview(text2b)
        
        box3.frame = CGRect(x: (setupView1.frame.width/4)*2, y:  50, width: setupView1.frame.width/4, height: 65)
        //        box3.backgroundColor = UIColor.red
        setupView1.addSubview(box3)
        
        text3a.text = String(format: "%02d", hitSuccess)
        text3a.font = UIFont(name: "Urbanist-Medium", size: 34)
        text3a.textColor = UIColor.white
        text3a.textAlignment = .center
        text3a.frame = CGRect(x: 0, y: 5, width: box3.frame.width, height: 30)
        
        text3b.text = riskyTextTrajectory
        text3b.font = UIFont(name: "Urbanist", size: 17)
        text3b.textColor = UIColor.white
        text3b.textAlignment = .center
        text3b.frame = CGRect(x: 0, y: box3.frame.height-20, width: box3.frame.width, height: 20)
        
        box3.addSubview(text3a)
        box3.addSubview(text3b)
        
        
        box4.frame = CGRect(x: (setupView1.frame.width/4)*3, y:  50, width: setupView1.frame.width/4, height: 65)
        //        box4.backgroundColor = UIColor.red
        setupView1.addSubview(box4)
        
        text4a.text = String(format: "%02d", hitFail)
        text4a.font = UIFont(name: "Urbanist-Medium", size: 34)
        text4a.textColor = UIColor.white
        text4a.textAlignment = .center
        text4a.frame = CGRect(x: 0, y: 5, width: box4.frame.width, height: 30)
        
        text4b.text = badTextTrajectory
        text4b.font = UIFont(name: "Urbanist", size: 17)
        text4b.textColor = UIColor.white
        text4b.textAlignment = .center
        text4b.frame = CGRect(x: 0, y: box4.frame.height-20, width: box4.frame.width, height: 20)
        
        box4.addSubview(text4a)
        box4.addSubview(text4b)
        
        
        
        box5.frame = CGRect(x: (setupView1.frame.width/2)*0, y:  50+90, width: setupView1.frame.width/2, height: 65)
        //        box5.backgroundColor = UIColor.red
        setupView1.addSubview(box5)
        text5a.text = String(format: "%.2f cm",minDistance)
        text5a.font = UIFont(name: "Urbanist-Medium", size: 34)
        text5a.textColor = UIColor.white
        text5a.textAlignment = .center
        text5a.frame = CGRect(x: 0, y: 5, width: box5.frame.width, height: 30)
        
        if(techniqueId == 0){
            text5b.text = lowestText
        }else if(techniqueId == 1){
            text5b.text = closestText
        }
        text5b.font = UIFont(name: "Urbanist", size: 17)
        text5b.textColor = UIColor.white
        text5b.textAlignment = .center
        text5b.frame = CGRect(x: 0, y: box5.frame.height-20, width: box5.frame.width, height: 20)
        
        let text5c = UILabel()
        text5c.text = "kok di atas net"
        text5c.font = UIFont(name: "Urbanist", size: 17)
        text5c.textColor = UIColor.white
        text5c.textAlignment = .center
        text5c.frame = CGRect(x: 0, y: box5.frame.height+0, width: box5.frame.width, height: 20)
        
        box5.addSubview(text5a)
        box5.addSubview(text5b)
        //        box5.addSubview(text5c)
        
        
        box6.frame = CGRect(x: (setupView1.frame.width/2)*1, y:  50+90, width: setupView1.frame.width/2, height: 65)
        //        box6.backgroundColor = UIColor.red
        setupView1.addSubview(box6)
        
        text6a.text = String(format: "%.2f cm", averageOfDistance)
        text6a.font = UIFont(name: "Urbanist-Medium", size: 34)
        text6a.textColor = UIColor.white
        text6a.textAlignment = .center
        text6a.frame = CGRect(x: 0, y: 5, width: box6.frame.width, height: 30)
        
        if(techniqueId == 0){
            text6b.text = averageHeightText
        }else if(techniqueId == 1){
            text5b.text = averageDrillText
        }
        
        text6b.font = UIFont(name: "Urbanist", size: 17)
        text6b.textColor = UIColor.white
        text6b.textAlignment = .center
        text6b.frame = CGRect(x: 0, y: box6.frame.height-20, width: box6.frame.width, height: 20)
        
        let text6c = UILabel()
        text6c.text = "kok di atas net"
        text6c.font = UIFont(name: "Urbanist", size: 17)
        text6c.textColor = UIColor.white
        text6c.textAlignment = .center
        text6c.frame = CGRect(x: 0, y: box6.frame.height+0, width: box6.frame.width, height: 20)
        
        box6.addSubview(text6a)
        box6.addSubview(text6b)
        //        box6.addSubview(text6c)
        
        
        
        //      let imageIconView = UIImageView(frame: CGRect(x: 0, y: box4.frame.height+85+75, width: 14.2227, height: 23.99989))
        //
        //       let imageName = "IconBadminton"
        //       if let image = UIImage(named: imageName) {
        //           imageIconView.image = image
        //       }
        //        setupView1.addSubview(imageIconView)
        
        let textYour = UILabel()
        textYour.text = completeChallengeText
        textYour.font = UIFont(name: "Urbanist", size: 17)
        textYour.textColor = UIColor.white
        textYour.textAlignment = .center
        textYour.frame = CGRect(x: 0, y: box4.frame.height+85+105, width: setupView1.frame.width, height: 20)
        setupView1.addSubview(textYour)
        //
        //        let hitTotal = arrHitStatistics.count
        //        let itemWidth = setupView1.frame.width / 10
        //
        //
        //
        //        for groupStartIndex in stride(from: 0, to: hitTotal, by: 10) {
        //            let groupEndIndex = min(groupStartIndex + 10, hitTotal)
        //
        //            let parent = groupStartIndex/10
        //
        //            let y = box4.frame.height+105 + CGFloat((parent * 40))
        //
        //            let containerView = UIView()
        //            containerView.frame = CGRect(x: 0, y: y, width: setupView1.frame.width, height: 20)
        //            var i = 0
        //
        //            var startX:Double = 0.0
        //            if(groupEndIndex%10 != 0){
        //                startX  = (10.0 - Double(groupEndIndex%10)) * (setupView1.frame.width / 10.0) / 2
        //            }else{
        //                startX  = 0
        //            }
        //
        //            print(startX)
        //
        //            for index in groupStartIndex..<groupEndIndex {
        //                let hitStat = arrHitStatistics[index]
        //                let textHit = UILabel()
        //                textHit.text = hitStat.hitNumber
        //                textHit.font = UIFont(name: "Urbanist-Medium", size: 20)
        //                if(hitStat.hitStatus == "Success"){
        //                    textHit.textColor = UIColor.white
        //                }else{
        //                    textHit.textColor = UIColor.black
        //                }
        //                textHit.textAlignment = .center
        //                textHit.frame = CGRect(x: ((itemWidth) * CGFloat(i)) + startX, y: 20, width: itemWidth, height: 20)
        //                containerView.addSubview(textHit)
        //                i += 1
        //            }
        //
        //            setupView1.addSubview(containerView)
        //        }
        
        
        
        buttonWhite.removeFromSuperview()
        boxCountdown.removeFromSuperview()
        boxScore.removeFromSuperview()
        boxNet.removeFromSuperview()
        
        
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stopRecording()
            
            let view1 = UIView()
            view1.frame = CGRect(x: self.setupViewChild.frame.width * 0.19, y: setupView1.frame.height-40, width: setupView1.frame.width/2, height: 50)
            self.setupViewChild.addSubview(view1)
            let view2 = UIView()
            view2.frame = CGRect(x: self.setupViewChild.frame.width * 0.51, y: setupView1.frame.height-40, width: setupView1.frame.width/2, height: 50)
            self.setupViewChild.addSubview(view2)
            
            self.doneButton.setTitle(doneText, for: .normal)
            self.doneButton.setTitleColor(UIColor(red: 33/255.0, green: 191/255.0, blue: 115/255.0, alpha: 1.0), for: .normal)
            self.doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            self.doneButton.backgroundColor = .white
            self.doneButton.layer.cornerRadius = 12
            self.doneButton.frame = CGRect(x: 0, y: 0, width: view1.frame.width * 0.9, height: 50)
            self.doneButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
            view1.addSubview(self.doneButton)
            self.detailButton.setTitle("Detail", for: .normal)
            self.detailButton.setTitleColor(.white, for: .normal)
            self.detailButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            self.detailButton.backgroundColor = UIColor(red: 33/255.0, green: 191/255.0, blue: 115/255.0, alpha: 1.0)
            self.detailButton.layer.cornerRadius = 12
            self.detailButton.frame = CGRect(x: 0, y: 0, width: view1.frame.width * 0.9, height: 50)
            self.detailButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
            view2.addSubview(self.detailButton)
            
        }
    }
    
    let doneButton = UIButton(type: .system)
    let detailButton = UIButton(type: .system)
    
    var textClear = UILabel()
    var text1 = UILabel()
    var text2 = UILabel()
    var text7 = UILabel()
    var text3 = UILabel()
    var textCountdown = UILabel()
    var boxCourtArea = UIView()
    var countdown = 0
    let boxCountdown = UIView()
    
    var labelCountdown = UILabel()
    var countdownTimer: Timer?
    var countdownValue = 3
    var timer: Timer?
    var remainingTime = 20 * 60 + 1
    
    var remainingTimeFix = 20 * 60 + 1
    //    var remainingTime = 1 * 10 + 1
    
    //    var hitTarget = 3
    @AppStorage("hitTarget") var hitTarget: Int = 0
    
    
    var isRecording = false
    
    let buttonWhite = UIButton(type: .custom)
    let button = UIButton(type: .custom)
    
    
    func startCountdown() {
        if urlVideoSource != nil {
            // Start reading the video.
            countdownValue = 0
            labelCountdown.text = String("")
        } else {
            // Start live camera capture.
            labelCountdown.text = String(countdownValue)
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    func startRecording(){
        startRecordScreen { error in
            if let e = error {
                print(e.localizedDescription)
                return
            }
        }
        print("Start Recording!")
    }
    
    func stopRecording(){
        Task {
            do {
                let url = try await stopRecordScreen()
                save(url: url,
                     duration: durationApp,
                     hitFail: hitFailApp,
                     hitPerfect: hitPerfectApp,
                     hitSuccess: hitSuccessApp,
                     hitTarget: hitTargetApp,
                     hitTotal: hitTotalApp,
                     level: techniqueName,
                     result: arrResult,
                     minDistance: minDistance,
                     avgDistance: averageOfDistance,
                     variance: variance)
            } catch {
                print(error.localizedDescription)
            }
        }
        print("Stop Recording!")
    }
    
    @objc func updateCountdownLabel() {
        countdownValue -= 1
        if countdownValue > 0 {
            labelCountdown.text = String(countdownValue)
        } else if countdownValue == 0 {
            labelCountdown.text = goText
        }else {
            if(isRecording == false){
                startRecording()
                isRecording = true
            }
            //            boxCountdown.backgroundColor = UIColor(red: 0.99, green: 0.37, blue: 0.33, alpha: 1.0)
            labelCountdown.text = ""
            self.remainingTime -= 1
            if self.remainingTime > -1 {
                let minutes = remainingTime / 60
                let seconds = remainingTime % 60
                textCountdown.text = String(format: "%02d:%02d", minutes, seconds)
                buttonWhite.layer.borderWidth = 3.0
                button.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0)
            } else {
                self.timer?.invalidate()
                countdownTimer?.invalidate()
                boxCountdown.backgroundColor = nil
                textCountdown.text = ""
                boxCountdown.removeFromSuperview()
                stop()
            }
        }
    }
    
    @objc func stopManual(){
        
        urlVideoSource = nil
        detectTrajectoryRequest = nil
        
        hitFailApp = hitFail
        hitTotalApp = hitTotal
        hitSuccessApp = hitSuccess
        hitPerfectApp = hitPerfect
        
        var arr: String = ""
        for val in arrHitStatistics {
            arr += "\(val.hitNumber):\(val.hitStatus):\(val.hitDistance),"
        }
        if(arrHitStatistics.count > 0){
            arr.removeLast()
        }
        arrResult = arr
        dismiss(animated: true, completion: nil)
        counter.menuStateSend(menuState: "result")
        self.setupResultView()
    }
    
    @objc func stop(){
        
        urlVideoSource = nil
        detectTrajectoryRequest = nil
        
        hitFailApp = hitFail
        hitTotalApp = hitTotal
        hitSuccessApp = hitSuccess
        hitPerfectApp = hitPerfect
        
        var arr: String = ""
        for val in arrHitStatistics {
            arr += "\(val.hitNumber):\(val.hitStatus):\(val.hitDistance),"
        }
        if(arrHitStatistics.count > 0){
            arr.removeLast()
        }
        arrResult = arr
        dismiss(animated: true, completion: nil)
        counter.menuStateSend(menuState: "result")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupResultView()
        }
    }
    
    func restart(){
        //ada fungsi untuk stop recording tanpa ubah status
        startRecording()
        dismiss(animated: true, completion: nil)
        hitFailApp = 0
        hitTotalApp = 0
        hitSuccessApp = 0
        hitPerfectApp = 0
        counter.menuStateSend(menuState: "stillPlay")
    }
    
    
    let boxNet = UIView()
    
    let rightArea = UIView()
    
    func setupView(){
        
        boxNet.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //        boxNet.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        boxNet.layer.cornerRadius = 4
        
        let imageNetView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        var netName = "NetLevel1B"
        if(techniqueId == 0){
            //            netName = "NetLevel2B"
            //            if let image = UIImage(named: netName) {
            //                imageNetView.image = image
            //            }
            //            boxNet.addSubview(imageNetView)
            //            view.addSubview(boxNet)
        }else if(techniqueId == 1){
            netName = "NetLevel3B"
            if let image = UIImage(named: netName) {
                imageNetView.image = image
            }
            boxNet.addSubview(imageNetView)
            view.addSubview(boxNet)
        }
        
        let duration = "00:00"
        counter.hitTotalSend(hitTotal: hitTotal)
        counter.hitTargetSend(hitTarget: hitTargetApp)
        counter.hitSuccessSend(hitSuccess: hitSuccess)
        counter.hitPerfectSend(hitPerfect: hitPerfect)
        counter.hitFailSend(hitFail: hitFail)
        counter.durationSend(duration: duration)
        counter.averageSend(average: averageOfDistance)
        counter.minSend(min: minDistance)
        
        var menuState = "result"
        
        if(hitTargetApp > 0){
            if(hitTotal >= hitTargetApp){
                counter.menuStateSend(menuState:menuState)
                stop()
            }else{
                menuState = "stillPlay"
                counter.menuStateSend(menuState:menuState)
            }
        }else{
            menuState = "stillPlay"
            counter.menuStateSend(menuState:menuState)
        }
        
        menuStateApp = menuState
        
        //        let buttonClose = UIButton(type: .custom)
        //        buttonClose.frame = CGRect(x: view.frame.width - 20, y: 10, width: 40, height: 40)
        //        buttonClose.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        //        buttonClose.layer.cornerRadius = 20
        //        buttonClose.clipsToBounds = true
        //
        //        buttonClose.addTarget(self, action: #selector(back), for: .touchUpInside)
        //
        //        view.addSubview(buttonClose)
        //
        //        let iconClose = UIImage(systemName: "xmark")
        //        let iconImageView = UIImageView(image: iconClose)
        //        iconImageView.tintColor = .white
        //        iconImageView.frame = CGRect(x:10, y: 10, width: 20, height: 20)
        //        buttonClose.addSubview(iconImageView)
        
        
        labelCountdown.textColor = UIColor.white
        labelCountdown.textAlignment = .center
        labelCountdown.translatesAutoresizingMaskIntoConstraints = false
        labelCountdown.font = UIFont(name: "Urbanist-Medium", size: 120)
        labelCountdown.font = UIFont(name: "Urbanist", size: 120)
        boxNet.insertSubview(labelCountdown, at: 2)
        
        labelCountdown.centerXAnchor.constraint(equalTo: boxNet.centerXAnchor).isActive = true
        labelCountdown.centerYAnchor.constraint(equalTo: boxNet.centerYAnchor).isActive = true
        
        let boxWidth: CGFloat = 82
        let boxHeight: CGFloat = 36
        
        boxCountdown.frame = CGRect(x: (view.frame.width - boxWidth) / 2, y: view.frame.height - boxHeight - 10, width: boxWidth, height: boxHeight)
        boxCountdown.backgroundColor = nil
        boxCountdown.layer.cornerRadius = 12
        boxNet.addSubview(boxCountdown)
        
        textCountdown.text = ""
        textCountdown.font = UIFont(name: "Urbanist", size: 20)
        textCountdown.textColor = UIColor.black
        textCountdown.alpha = 0.3
        textCountdown.textAlignment = .center
        textCountdown.frame = CGRect(x: 0, y: 0, width: boxCountdown.frame.width, height: boxCountdown.frame.height)
        
        boxCountdown.addSubview(textCountdown)
        
        
        buttonWhite.frame = CGRect(x: view.frame.size.width - 70 + 20 - (32/2), y: (view.frame.size.height/2) - (32/2), width: 64, height: 64)
        buttonWhite.backgroundColor = nil
        buttonWhite.layer.cornerRadius = 32
        buttonWhite.clipsToBounds = true
        buttonWhite.layer.borderWidth = 0.0
        buttonWhite.layer.borderColor = UIColor.white.cgColor
        buttonWhite.addTarget(self, action: #selector(stopManual), for: .touchUpInside)
        boxNet.addSubview(buttonWhite)
        
        button.frame = CGRect(x: 5, y: 5, width: 54, height: 54)
        button.backgroundColor = UIColor(red: 1, green: 0.2, blue: 0.15, alpha: 1.0)
        button.backgroundColor = nil
        button.layer.cornerRadius = 27
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(stopManual), for: .touchUpInside)
        
        buttonWhite.addSubview(button)
        
        //        let netFirstX = view.bounds.maxX * 0.258
        //        let netFirstY = view.bounds.maxY * 0.41
        //
        //        let netLastX = view.bounds.maxX * 0.89
        //        let netLastY = view.bounds.maxY * 0.39
        //
        //        let circleViewFirst = UIView(frame: CGRect(x: netFirstX, y: netFirstY, width: 10, height: 10))
        //        circleViewFirst.backgroundColor = UIColor.green
        //        circleViewFirst.layer.cornerRadius = circleViewFirst.frame.size.width / 2
        //        circleViewFirst.clipsToBounds = true
        //        self.view.addSubview(circleViewFirst)
        //
        //        let circleViewLast = UIView(frame: CGRect(x: netLastX, y: netLastY, width: 10, height: 10))
        //        circleViewLast.backgroundColor = UIColor.green
        //        circleViewLast.layer.cornerRadius = circleViewLast.frame.size.width / 2
        //        circleViewLast.clipsToBounds = true
        //        self.view.addSubview(circleViewLast)
        
        
        //        let view = UIView()
        //        view.frame = CGRect(x: 20, y: 20, width: 100, height: 30)
        //        view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        //        let label = UILabel()
        //        label.text = "CLEAR"
        //        label.textColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        //        label.textAlignment = .center
        //        label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //
        //        view.addSubview(label)
        //
        //        self.view.addSubview(view)
        
        
        //        let boxNet = UIView()
        //                boxNet.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //        //        boxNet.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        //                boxNet.layer.cornerRadius = 4
        //
        //                let imageNetView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        //                if let image = UIImage(named: "Net") {
        //                    imageNetView.image = image
        //                }
        //                boxNet.addSubview(imageNetView)
        
        
        if(techniqueId == 1){
            let boxCourtView = UIView()
            boxCourtView.frame = CGRect(x: view.frame.width - 20 - 110 - 75, y: view.frame.height - 20 - 140, width: 110, height: 140)
            boxCourtView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
            boxCourtView.layer.cornerRadius = 4
            
            let imageCourtView = UIImageView(frame: CGRect(x: 5, y: 5, width: 100, height: 135))
            if let image = UIImage(named: "CourtBox") {
                imageCourtView.image = image
            }
            boxCourtView.addSubview(imageCourtView)
            boxNet.addSubview(boxCourtView)
            
            
            rightArea.frame = CGRect(x:boxCourtView.frame.width * 0.49,y:10,width:boxCourtView.frame.width * 0.37,height:boxCourtView.frame.height * 0.63)
            print("DBUGG : ",rightArea.frame)
            //            rightArea.backgroundColor = .blue
            //            rightArea.layer.opacity = 0.3
            boxCourtView.addSubview(rightArea)
            
        }
        
        let boxCourt = UIView()
        boxCourt.frame = CGRect(x: 20, y: 20, width: 0, height: 0)
        
        boxScore.frame = CGRect(x: boxCourt.frame.width + 30 + 70, y: 20, width: 240, height: 69)
        boxScore.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        boxScore.layer.cornerRadius = 4
        
        textClear.text = String(format: "%02d", hitPerfect)
        textClear.font = UIFont(name: "Urbanist-Medium", size: 34)
        textClear.textColor = UIColor.white
        textClear.textAlignment = .center
        textClear.frame = CGRect(x: 0, y: 10, width: (boxScore.frame.width/4), height: 30)
        
        text7.text = String(format: "%02d", hitSuccess)
        text7.font = UIFont(name: "Urbanist-Medium", size: 34)
        text7.textColor = UIColor.white
        text7.textAlignment = .center
        text7.frame = CGRect(x: (boxScore.frame.width/4), y: 10, width: (boxScore.frame.width/4), height: 30)
        
        text1.text = String(format: "%02d", hitTotal)
        text1.font = UIFont(name: "Urbanist-Medium", size: 34)
        text1.textColor = UIColor.white
        text1.textAlignment = .center
        text1.frame = CGRect(x: (boxScore.frame.width/4) * 2, y: 10, width: (boxScore.frame.width/4), height: 30)
        
        
        
        text2.text = "/"
        text2.font = UIFont(name: "Urbanist-Medium", size: 34)
        text2.textColor = UIColor.white
        text2.textAlignment = .center
        text2.frame = CGRect(x: (boxScore.frame.width/4) * 2.85, y: 10, width: 20, height: 30)
        
        text3.text = String(format: "%02d", hitTargetApp)
        text3.font = UIFont(name: "Urbanist-Medium", size: 34)
        text3.textColor = UIColor.white
        text3.textAlignment = .center
        text3.frame = CGRect(x: (boxScore.frame.width/4) * 3, y: 10, width: (boxScore.frame.width/4), height: 30)
        
        let text4 = UILabel()
        text4.text = goodTextTrajectory
        text4.font = UIFont(name: "Urbanist", size: 15)
        text4.textColor = UIColor.white
        text4.textAlignment = .center
        text4.frame = CGRect(x: 0, y: 40, width: (boxScore.frame.width/4) * 1, height: 30)
        
        let text6 = UILabel()
        text6.text = riskyTextTrajectory
        text6.font = UIFont(name: "Urbanist", size: 15)
        text6.textColor = UIColor.white
        text6.textAlignment = .center
        text6.frame = CGRect(x: (boxScore.frame.width/4) * 1, y: 40, width: (boxScore.frame.width/4) * 1, height: 30)
        
        
        let text5 = UILabel()
        text5.text = tryingText
        text5.font = UIFont(name: "Urbanist", size: 15)
        text5.textColor = UIColor.white
        text5.textAlignment = .center
        text5.frame = CGRect(x: (boxScore.frame.width/4) * 2, y: 40, width: (boxScore.frame.width/4) * 2, height: 30)
        
        let imageView = UIImageView(frame: CGRect(x: (boxScore.frame.width/4)-1, y: 15, width: 2, height: boxScore.frame.height-30))
        if let image = UIImage(named: "Divider") {
            imageView.image = image
        }
        boxScore.addSubview(imageView)
        
        let imageView2 = UIImageView(frame: CGRect(x: (boxScore.frame.width/2)-1, y: 15, width: 2, height: boxScore.frame.height-30))
        if let image = UIImage(named: "Divider") {
            imageView2.image = image
        }
        boxScore.addSubview(imageView2)
        
        
        let imageLogo = UIImageView(frame: CGRect(x: boxNet.frame.width - 30 - 70 - (172/3.5), y: 20, width: 172/3.5, height: 244/3.5))
        if let image = UIImage(named: "LogoLabel") {
            imageLogo.image = image
        }
        boxNet.addSubview(imageLogo)
        
        // Add the labels to the boxScore
        boxScore.addSubview(textClear)
        boxScore.addSubview(text1)
        boxScore.addSubview(text2)
        boxScore.addSubview(text3)
        boxScore.addSubview(text7)
        boxScore.addSubview(text4)
        boxScore.addSubview(text5)
        boxScore.addSubview(text6)
        
        self.view.addSubview(boxScore)
        self.view.addSubview(boxCourt)
        self.view.addSubview(boxNet)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        urlVideoSource = nil
        detectTrajectoryRequest = nil
    }
    
    // MARK: - Public Methods
    
    
    // The sample app calls this when the camera view delegate begins reading
    // frames of a video buffer.
    func setUpDetectTrajectoriesRequestWithMaxDimension() {
        
        guard setupComplete == false else {
            return
        }
        
        /**
         Define what the sample app looks for, and how to handle the output trajectories.
         Setting the frame time spacing to (10, 600) so the framework looks for trajectories after each 1/60 second of video.
         Setting the trajectory length to 6 so the framework returns trajectories of a length of 6 or greater.
         Use a shorter length for real-time apps, and use longer lengths to observe finer and longer curves.
         */
        detectTrajectoryRequest = VNDetectTrajectoriesRequest(frameAnalysisSpacing: CMTime(value: 10, timescale: 600),
                                                              trajectoryLength: 1) { [weak self] (request: VNRequest, error: Error?) -> Void in
            
            guard let results = request.results as? [VNTrajectoryObservation] else {
                return
            }
            
            DispatchQueue.main.async {
                if(self!.techniqueId == 0){
                    self?.processTrajectoryObservation(results: results)
                }else if(self!.techniqueId == 1){
                    self?.processTrajectoryObservationLevel3(results: results)
                }
            }
            
        }
        setupComplete = true
        
    }
    
    // MARK: - Private Methods
    
    var prevPoints: [VNPoint] = []
    var prevCount: Int = 0
    var currentPoints: [VNPoint] = []
    var correctPoints: [VNPoint] = []
    var trajectoryCount = 0
    var isTrajectory = false
    
    var delay = 0
    
    var delayCorrect = 0
    var delayIncorrect = 0
    
    var isCorrect = false
    
    
    var correctPath: [Int] = []
    var incorrectPath: [Int] = []
    
    var hitTotal = 0
    var hitSuccess = 0
    var hitPerfect = 0
    var hitFail = 0
    
    
    @AppStorage("hitFailApp") var hitFailApp = 0
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("hitPerfectApp") var hitPerfectApp = 0
    @AppStorage("duration") var durationApp = ""
    @AppStorage("menuStateApp") var menuStateApp = ""
    
    var response : [String:Double] = [:]
    
    var summaryClear:[Int] = []
    var summaryPerfect:[Int] = []
    var summaryFail:[Int] = []
    
    var latestState = ""
    
    
    var existingTrajectory:[String] = []
    var arrTrajectory: [String: [VNPoint]] = [:]
    
    var lastTrajectory = VNTrajectoryObservation()
    
    private func processTrajectoryObservation(results: [VNTrajectoryObservation]) {
        
        if(!isRecording){
            return
        }
        
        if menuStateApp == "result" {
            stopManual()
        }
        
        //        guard !results.isEmpty else {
        //            existingTrajectory.removeAll()
        //            trajectoryView.resetPath()
        //            return
        //        }
        
        var arrResult:[String] = []
        for trajectory in results {
            arrResult.append(trajectory.uuid.uuidString)
            if filterParabola(trajectory: trajectory) {
                currentPoints = correctTrajectoryPath(trajectoryToCorrect: trajectory)
                let firstX = currentPoints.first?.x ?? 0.0
                let lastX = currentPoints.last?.x ?? 0.0
                let trajectoryLength = lastX - firstX
                print("***")
                print(trajectoryLength)
                print(firstX)
                if(!existingTrajectory.contains(trajectory.uuid.uuidString) && trajectoryLength > 0.3 && firstX < 0.1){
                    existingTrajectory.append(trajectory.uuid.uuidString)
                }
            }else{
                
            }
        }
        
        Task {
            do {
                try await getResult(results:arrResult)
            } catch {
                print("Error: \(error)")
            }
        }
        
        
    }
    
    private func getResult(results: [String]) async throws{
        for (index, val) in existingTrajectory.enumerated() {
            if(!results.contains(val)){
                currentPoints = trajectoryDictionary[val]!
                trajectoryView.performTransition(.fadeIn, duration: 0.05)
                trajectoryView.points = currentPoints
                let response = trajectoryView.updatePathLayer()
                print(response)
                if existingTrajectory.indices.contains(index) {
                    existingTrajectory.remove(at: index)
                } else {
                    print("Index out of bounds")
                }
                if(techniqueId == 0){
                    if(response.1){
                        hitTotal += 1
                        if(response.0 == "Perfect"){
                            hitPerfect += 1
                        }else if(response.0 == "Success"){
                            hitSuccess += 1
                        }else if(response.0 == "Fail"){
                            hitFail += 1
                        }
                        let newData:HitStatistics = HitStatistics(hitNumber: String(hitTotal), hitStatus: response.0, hitDistance: response.2, hitMinDistance: 0, hitAverageOfDistance: 0, hitVariance: "")
                        arrHitStatistics.append(newData)
                    }
                }
                
                print("HIT : \(hitTotal) SUCCESS : \(hitSuccess) FAIL : \(hitFail)")
                
                text1.text = String(format: "%02d", hitTotal)
                textClear.text = String(format: "%02d", hitPerfect)
                text7.text = String(format: "%02d", hitSuccess)
                text3.text = String(format: "%02d", hitTargetApp)
                
                
                let durationTime = remainingTimeFix - remainingTime
                let minutes = durationTime / 60
                let seconds = durationTime % 60
                let duration = String(format: "%02d:%02d", minutes, seconds)
                
                
                    var value = 0.0
                    var min = Double.infinity
                   
                
                    for val in arrHitStatistics {
                        if(val.hitStatus == "Perfect" || val.hitStatus == "Success"){
                            if val.hitDistance < min {
                                min = val.hitDistance
                            }
                        }
                    }
                    minDistance = min
                    
                print("bugis: \(value) - \(index) - \(Double(value) / Double(index)) - \(minDistance)")
                
                    value = 0
                    var index = 0
                
                    for val in arrHitStatistics {
                        if(val.hitStatus == "Perfect" || val.hitStatus == "Success"){
                            value += val.hitDistance
                            index += 1
                        }
                    }
                
                    value = Double(value) / Double(index)
                    averageOfDistance = value
                    
                print("bugi: \(value) - \(index) - \(Double(value) / Double(index)) - \(averageOfDistance)")
                
                    variance = ""
                    
                print("***")
                print("DBUGGG : \(minDistance)")
                print("DBUGGG : \(averageOfDistance)")
                print("DBUGGG : \(variance)")
                
                
                counter.hitTotalSend(hitTotal: hitTotal)
                counter.hitTargetSend(hitTarget: hitTargetApp)
                counter.hitSuccessSend(hitSuccess: hitSuccess)
                counter.hitPerfectSend(hitPerfect: hitPerfect)
                counter.hitFailSend(hitFail: hitFail)
                counter.durationSend(duration: duration)
                counter.averageSend(average: averageOfDistance)
                counter.minSend(min: minDistance)
                
                durationApp = duration
                
                var menuState = "result"
                
                if(hitTargetApp > 0){
                    if(hitTotal >= hitTargetApp){
                        counter.menuStateSend(menuState:menuState)
                        stop()
                    }else{
                        menuState = "stillPlay"
                        counter.menuStateSend(menuState:menuState)
                    }
                }else{
                    menuState = "stillPlay"
                    counter.menuStateSend(menuState:menuState)
                }
                
                menuStateApp = menuState
                
            }
        }
        //        if(results.count < 1){
        //            existingTrajectory.removeAll()
        //        }
    }
    
    
    private func processTrajectoryObservationLevel3(results: [VNTrajectoryObservation]) {
        
        if(!isRecording){
            return
        }
        
        if menuStateApp == "result" {
            stopManual()
        }
        
        //        guard !results.isEmpty else {
        //            existingTrajectory.removeAll()
        //            trajectoryView.resetPath()
        //            return
        //        }
        
        var arrResult:[String] = []
        for trajectory in results {
            arrResult.append(trajectory.uuid.uuidString)
            
            if filterParabolaLevel3(trajectory: trajectory) {
                currentPoints = trajectoryDictionary[trajectory.uuid.uuidString]!
                let firstX = currentPoints.first?.x ?? 0.0
                let lastX = currentPoints.last?.x ?? 0.0
                let firstY = currentPoints.first?.y ?? 0.0
                let lastY = currentPoints.last?.y ?? 0.0
                let trajectoryLength = lastX - firstX
                let trajectoryHeight = firstY - lastY
                
                
                if(!existingTrajectory.contains(trajectory.uuid.uuidString)
                   && (trajectoryHeight > 0.05 || trajectoryLength > 0.05)
                ){
                    existingTrajectory.append(trajectory.uuid.uuidString)
                }
            }else{
                
            }
        }
        
        Task {
            do {
                try await getResultLevel3(results:arrResult)
            } catch {
                print("Error: \(error)")
            }
        }
        
        
    }
    
    private func getResultLevel3(results: [String]) async throws{
        for (index, val) in existingTrajectory.enumerated() {
            if(!results.contains(val)){
                currentPoints = trajectoryDictionary[val]!
                trajectoryView.performTransition(.fadeIn, duration: 0.05)
                trajectoryView.points = currentPoints
                let response = trajectoryView.updatePathLayer()
                print(response)
                if existingTrajectory.indices.contains(index) {
                    existingTrajectory.remove(at: index)
                } else {
                    print("Index out of bounds")
                }
                if(techniqueId == 1){
                    if(response.1){
                        
                        hitTotal = 0
                        hitPerfect = 0
                        hitSuccess = 0
                        hitFail = 0
                        
                        arrHitStatistics = []
                        
                        for i in 0..<response.3.count {
                            hitTotal += 1
                            let x = response.3[i].x
                            let y = response.3[i].y
                            
                            let circleNet = CALayer()
                            circleNet.opacity = 1
                            circleNet.frame = CGRect(x: x-6, y:y-6, width: 6, height: 6)
                            circleNet.cornerRadius = 5.0
                            circleNet.masksToBounds = true
                            rightArea.layer.addSublayer(circleNet)
                            var status = ""
                            switch(response.4[i]){
                            case "BAGUS":
                                status = "Perfect"
                                hitPerfect += 1
                                circleNet.backgroundColor = localStorage.loadColor(forKey: "Green")?.cgColor
                            case "KURANG":
                                status = "Success"
                                hitSuccess += 1
                                circleNet.backgroundColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
                            case "BURUK":
                                status = "Fail"
                                hitFail += 1
                                circleNet.backgroundColor = localStorage.loadColor(forKey: "Red")?.cgColor
                            default:
                                print(0)
                            }
                            
                            
                            
                            let newData:HitStatistics = HitStatistics(hitNumber: String(hitTotal), hitStatus: status, hitDistance: response.5[i], hitMinDistance: response.6[i], hitAverageOfDistance: response.7[i], hitVariance: response.8[i])
                            arrHitStatistics.append(newData)
                        }
                        
                        minDistance = response.9
                        averageOfDistance = response.10
                        variance = response.11
                        
                        //                        print("DBUGGG : ",response)
                        
                        print(arrHitStatistics)
                        
                    }
                }
                
                
                
                text1.text = String(format: "%02d", hitTotal)
                textClear.text = String(format: "%02d", hitPerfect)
                text7.text = String(format: "%02d", hitSuccess)
                text3.text = String(format: "%02d", hitTargetApp)
                
                
                let durationTime = remainingTimeFix - remainingTime
                let minutes = durationTime / 60
                let seconds = durationTime % 60
                let duration = String(format: "%02d:%02d", minutes, seconds)
                
                counter.hitTotalSend(hitTotal: hitTotal)
                counter.hitTargetSend(hitTarget: hitTargetApp)
                counter.hitSuccessSend(hitSuccess: hitSuccess)
                counter.hitPerfectSend(hitPerfect: hitPerfect)
                counter.hitFailSend(hitFail: hitFail)
                counter.durationSend(duration: duration)
                counter.averageSend(average: averageOfDistance)
                counter.minSend(min: minDistance)
                
                durationApp = duration
                
                var menuState = "result"
                
                if(hitTargetApp > 0){
                    if(hitTotal >= hitTargetApp){
                        counter.menuStateSend(menuState:menuState)
                        stop()
                    }else{
                        menuState = "stillPlay"
                        counter.menuStateSend(menuState:menuState)
                    }
                }else{
                    menuState = "stillPlay"
                    counter.menuStateSend(menuState:menuState)
                }
                
                menuStateApp = menuState
                
            }
        }
        //        if(results.count < 1){
        //            existingTrajectory.removeAll()
        //        }
    }
    
    
    private var hitSummary: [String: [Int]] = [:]
    
    
    private func filterParabola(trajectory: VNTrajectoryObservation) -> Bool {
        
        if trajectoryDictionary[trajectory.uuid.uuidString] == nil {
            // Add the new trajectories to the dictionary.
            trajectoryDictionary[trajectory.uuid.uuidString] = trajectory.projectedPoints
        } else {
            // Increase the points on the existing trajectory.
            // The framework returns the last five projected points, so check whether a trajectory is
            // increasing, and update it.
            if trajectoryDictionary[trajectory.uuid.uuidString]!.last != trajectory.projectedPoints[4] {
                trajectoryDictionary[trajectory.uuid.uuidString]!.append(trajectory.projectedPoints[4])
            }
        }
        
        if trajectoryDictionary[trajectory.uuid.uuidString]!.first!.x < trajectoryDictionary[trajectory.uuid.uuidString]!.last!.x
            && trajectoryDictionary[trajectory.uuid.uuidString]!.first!.x < 0.5
            && trajectoryDictionary[trajectory.uuid.uuidString]!.count >= 8
            && trajectory.equationCoefficients[0] <= 0
            && trajectory.confidence > 0.9 {
            return true
        } else {
            return false
        }
        
    }
    
    private func correctTrajectoryPath(trajectoryToCorrect: VNTrajectoryObservation) -> [VNPoint] {
        
        guard var basePoints = trajectoryDictionary[trajectoryToCorrect.uuid.uuidString],
              var basePointX = basePoints.first?.x else {
            return []
        }
        
        if basePointX > 0.1 {
            
            // Compute the initial trajectory location points based on the average
            // change in the x direction of the first five points.
            var sum = 0.0
            for i in 0..<5 {
                sum = sum + basePoints[i + 1].x - basePoints[i].x
            }
            let averageDifferenceInX = sum / 5.0
            
            while basePointX > 0.1 {
                let nextXValue = basePointX - averageDifferenceInX
                let aXX = Double(trajectoryToCorrect.equationCoefficients[0]) * nextXValue * nextXValue
                let bX = Double(trajectoryToCorrect.equationCoefficients[1]) * nextXValue
                let c = Double(trajectoryToCorrect.equationCoefficients[2])
                
                let nextYValue = aXX + bX + c
                if nextYValue > 0 {
                    // Insert values into the trajectory path present in the positive Cartesian space.
                    basePoints.insert(VNPoint(x: nextXValue, y: nextYValue), at: 0)
                }
                basePointX = nextXValue
            }
            trajectoryDictionary[trajectoryToCorrect.uuid.uuidString] = basePoints
            
        }
        return basePoints
        
    }
    
    private func filterParabolaLevel3(trajectory: VNTrajectoryObservation) -> Bool {
        
        if trajectoryDictionary[trajectory.uuid.uuidString] == nil {
            trajectoryDictionary[trajectory.uuid.uuidString] = trajectory.projectedPoints
        } else {
            trajectoryDictionary[trajectory.uuid.uuidString] = trajectory.projectedPoints
        }
        
        if trajectoryDictionary[trajectory.uuid.uuidString]!.first!.y > trajectoryDictionary[trajectory.uuid.uuidString]!.last!.y
            && trajectoryDictionary[trajectory.uuid.uuidString]!.first!.x < trajectoryDictionary[trajectory.uuid.uuidString]!.last!.x
            && trajectoryDictionary[trajectory.uuid.uuidString]!.first!.x < 0.5
        {
            return true
        } else {
            return false
        }
        
    }
    
    private func correctTrajectoryPathLevel3(trajectoryToCorrect: VNTrajectoryObservation) -> [VNPoint] {
        
        guard var basePoints = trajectoryDictionary[trajectoryToCorrect.uuid.uuidString],
              var basePointX = basePoints.first?.x else {
            return []
        }
        
        if basePointX > 0.1 {
            
            // Compute the initial trajectory location points based on the average
            // change in the x direction of the first five points.
            var sum = 0.0
            for i in 0..<5 {
                sum = sum + basePoints[i + 1].x - basePoints[i].x
            }
            let averageDifferenceInX = sum / 5.0
            
            while basePointX > 0.1 {
                let nextXValue = basePointX - averageDifferenceInX
                let aXX = Double(trajectoryToCorrect.equationCoefficients[0]) * nextXValue * nextXValue
                let bX = Double(trajectoryToCorrect.equationCoefficients[1]) * nextXValue
                let c = Double(trajectoryToCorrect.equationCoefficients[2])
                
                let nextYValue = aXX + bX + c
                if nextYValue > 0 {
                    // Insert values into the trajectory path present in the positive Cartesian space.
                    basePoints.insert(VNPoint(x: nextXValue, y: nextYValue), at: 0)
                }
                basePointX = nextXValue
            }
            trajectoryDictionary[trajectoryToCorrect.uuid.uuidString] = basePoints
            
        }
        return basePoints
        
    }
    
    var urlVideoSource : AVAsset?
    var urlVideo : URL? {
        didSet {
            updateVideoSource()
        }
    }
    
    func updateVideoSource(){
        if(urlVideo != nil){
            urlVideoSource = AVAsset(url: urlVideo!)
            counter.videoUrlSend(videoUrl: "exist")
        }else{
            urlVideoSource = nil
            counter.videoUrlSend(videoUrl: "not exist")
        }
        
    }
    private func configureView() {
        
        // Set up the video layers.
        cameraViewController = CameraViewController()
        cameraViewController.view.frame = view.bounds
        addChild(cameraViewController)
        cameraViewController.beginAppearanceTransition(true, animated: true)
        view.addSubview(cameraViewController.view)
        cameraViewController.endAppearanceTransition()
        cameraViewController.didMove(toParent: self)
        
        do {
            if urlVideoSource != nil {
                // Start reading the video.
                cameraViewController.startReadingAsset(urlVideoSource!)
            } else {
                // Start live camera capture.
                try cameraViewController.setupAVSession()
            }
        } catch {
            AppError.display(error, inViewController: self)
        }
        
        cameraViewController.outputDelegate = self
        
        // Add a custom trajectory view for overlaying trajectories.
        view.addSubview(trajectoryView)
        //        view.addSubview(closeButton)
        //        view.bringSubviewToFront(closeButton)
        
    }
    
}

extension ContentAnalysisViewController: CameraViewControllerOutputDelegate {
    
    func cameraViewController(_ controller: CameraViewController,
                              didReceiveBuffer buffer: CMSampleBuffer,
                              orientation: CGImagePropertyOrientation) {
        
        
        let visionHandler = VNImageRequestHandler(cmSampleBuffer: buffer,
                                                  orientation: orientation,
                                                  options: [:])
        
        var normalizedFrame = CGRect()
        if(techniqueId == 0){
            normalizedFrame = CGRect(x: 0.21, y: 0.0, width: 0.77, height: 1)
        }else if(techniqueId == 1){
            normalizedFrame = CGRect(x: 0.0, y: 0.0, width:1, height: 1)
        }
        
        
        //        print("DBUG : ",menuStateApp)
        //        print(buffer)
        DispatchQueue.main.async {
            if(self.menuStateApp == "restart"){
                self.restart()
                //                   print("DBUG : REST")
            }
            // Get the frame of the rendered view.
            self.trajectoryView.frame = controller.viewRectForVisionRect(normalizedFrame)
        }
        
        setUpDetectTrajectoriesRequestWithMaxDimension()
        
        guard let detectTrajectoryRequest = detectTrajectoryRequest else {
            print("Failed to retrieve a trajectory request.")
            return
        }
        
        do {
            // Following optional bounds by checking for the moving average radius
            // of the trajectories the app is looking for.
            detectTrajectoryRequest.objectMinimumNormalizedRadius = 10.0 / Float(1920.0)
            detectTrajectoryRequest.objectMaximumNormalizedRadius = 50.0 / Float(1920.0)
            
            // Help manage the real-time use case to improve the precision versus delay tradeoff.
            detectTrajectoryRequest.targetFrameTime = CMTimeMake(value: 1, timescale: 60)
            
            // The region of interest where the object is moving in the normalized image space.
            detectTrajectoryRequest.regionOfInterest = normalizedFrame
            
            try visionHandler.perform([detectTrajectoryRequest])
        } catch {
            print("Failed to perform the trajectory request: \(error.localizedDescription)")
            return
        }
        
    }
    
}
