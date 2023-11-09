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
    func saveRecord(url: URL)
}

class ContentAnalysisViewController: UIViewController,
                                     AVCaptureVideoDataOutputSampleBufferDelegate {
    let counter = Counter()
    @AppStorage("name") var name: String = "Intermediate"
    @AppStorage("isOnRecord") var isOnRecord = true
    @AppStorage("dataUrl") var dataUrl: String = ""
    
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
        let recorder = RPScreenRecorder.shared()
        
        try await recorder.stopRecording(withOutput: url)
        
        return url
    }
    
    func save(url: URL) {
        contentAnalysisDelegate?.saveRecord(url: url)
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
        configureView()
        setupView()
        startCountdown()
    }
    
    
    let setupViewParent = UIView()
    let setupViewChild = UIView()
    let boxScore = UIView()
    
    var text1a = UILabel()
    let text1b = UILabel()
    var text2a = UILabel()
    let text2b = UILabel()
    var text3a = UILabel()
    let text3b = UILabel()
    var text4a = UILabel()
    let text4b = UILabel()
    let box1 = UIView()
    let box2 = UIView()
    let box3 = UIView()
    let box4 = UIView()
    
    
    @objc func back(){
        print("Back!")
        let menuState = "done"
        counter.menuStateSend(menuState:menuState)
        isOnRecord = false
    }
    
    var arrHitStatistics : [HitStatistics] = [
//        HitStatistics(hitNumber: "1", hitStatus: "Success"),
//        HitStatistics(hitNumber: "2", hitStatus: "Success"),
//        HitStatistics(hitNumber: "3", hitStatus: "Fail"),
//        HitStatistics(hitNumber: "4", hitStatus: "Success"),
//        HitStatistics(hitNumber: "5", hitStatus: "Success"),
//        HitStatistics(hitNumber: "6", hitStatus: "Success"),
//        HitStatistics(hitNumber: "7", hitStatus: "Success"),
//        HitStatistics(hitNumber: "8", hitStatus: "Fail"),
//        HitStatistics(hitNumber: "9", hitStatus: "Fail"),
//        HitStatistics(hitNumber: "10", hitStatus: "Success"),
//        HitStatistics(hitNumber: "11", hitStatus: "Success"),
//        HitStatistics(hitNumber: "12", hitStatus: "Fail"),
//        HitStatistics(hitNumber: "13", hitStatus: "Success"),
//        HitStatistics(hitNumber: "14", hitStatus: "Success"),
//        HitStatistics(hitNumber: "15", hitStatus: "Fail"),
//        HitStatistics(hitNumber: "16", hitStatus: "Fail"),
//        HitStatistics(hitNumber: "17", hitStatus: "Fail"),
//        HitStatistics(hitNumber: "18", hitStatus: "Success"),
//        HitStatistics(hitNumber: "19", hitStatus: "Success"),
//        HitStatistics(hitNumber: "20", hitStatus: "Success")
    ]
    struct HitStatistics: Identifiable {
        var id = UUID()
        var hitNumber: String
        var hitStatus: String
    }
    
    
    func setupResultView(){
        
        setupViewParent.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        setupViewParent.backgroundColor = .black
        setupViewParent.alpha = 0.5
        view.addSubview(setupViewParent)
        
        
        setupViewChild.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        setupViewChild.backgroundColor = nil
        view.addSubview(setupViewChild)
        
        let buttonClose = UIButton(type: .custom)
        let image3 = UIImage(named: "CloseButton")
        buttonClose.setImage(image3, for: .normal)
        buttonClose.imageView?.contentMode = .scaleAspectFit
        buttonClose.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        buttonClose.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(buttonClose)
        
        
        let setupView1 = UIView()
        setupView1.backgroundColor = nil
        setupView1.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height/2)
        setupView1.center = view.center
        setupViewChild.addSubview(setupView1)
        
        setupView1.translatesAutoresizingMaskIntoConstraints = false
        setupView1.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        setupView1.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        setupView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupView1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let textLevel = UILabel()
        textLevel.text = "Intermediate"
        textLevel.font = UIFont.systemFont(ofSize: 17)
        textLevel.textColor = UIColor.white
        textLevel.textAlignment = .center
        textLevel.frame = CGRect(x: 0, y: 0, width: setupView1.frame.width, height: 20)
        setupView1.addSubview(textLevel)
        
        box1.frame = CGRect(x: 0, y: 50, width: setupView1.frame.width/4, height: 65)
//        box1.backgroundColor = UIColor.red
        setupView1.addSubview(box1)
        
        text1a.text = String(format: "%02d",hitTargetApp)
        text1a.font = UIFont.systemFont(ofSize: 34)
        text1a.textColor = UIColor.white
        text1a.textAlignment = .center
        text1a.frame = CGRect(x: 0, y: 5, width: box1.frame.width, height: 30)
        
        text1b.text = "Target Shot"
        text1b.font = UIFont.systemFont(ofSize: 17)
        text1b.textColor = UIColor.white
        text1b.textAlignment = .center
        text1b.frame = CGRect(x: 0, y: box1.frame.height-20, width: box1.frame.width, height: 20)
        
        box1.addSubview(text1a)
        box1.addSubview(text1b)
        

        box2.frame = CGRect(x: (setupView1.frame.width/4)*1, y:  50, width: setupView1.frame.width/4, height: 65)
//        box2.backgroundColor = UIColor.red
        setupView1.addSubview(box2)
        
        text2a.text = String(format: "%02d", hitTotal)
        text2a.font = UIFont.systemFont(ofSize: 34)
        text2a.textColor = UIColor.white
        text2a.textAlignment = .center
        text2a.frame = CGRect(x: 0, y: 5, width: box2.frame.width, height: 30)
        
        text2b.text = "Total Shot"
        text2b.font = UIFont.systemFont(ofSize: 17)
        text2b.textColor = UIColor.white
        text2b.textAlignment = .center
        text2b.frame = CGRect(x: 0, y: box2.frame.height-20, width: box2.frame.width, height: 20)
        
        box2.addSubview(text2a)
        box2.addSubview(text2b)
        
        box3.frame = CGRect(x: (setupView1.frame.width/4)*2, y:  50, width: setupView1.frame.width/4, height: 65)
//        box3.backgroundColor = UIColor.red
        setupView1.addSubview(box3)
        
        text3a.text = String(format: "%02d", hitSuccess)
        text3a.font = UIFont.systemFont(ofSize: 34)
        text3a.textColor = UIColor.white
        text3a.textAlignment = .center
        text3a.frame = CGRect(x: 0, y: 5, width: box3.frame.width, height: 30)
        
        text3b.text = "Success"
        text3b.font = UIFont.systemFont(ofSize: 17)
        text3b.textColor = UIColor.white
        text3b.textAlignment = .center
        text3b.frame = CGRect(x: 0, y: box3.frame.height-20, width: box3.frame.width, height: 20)
        
        box3.addSubview(text3a)
        box3.addSubview(text3b)
        
        
        box4.frame = CGRect(x: (setupView1.frame.width/4)*3, y:  50, width: setupView1.frame.width/4, height: 65)
//        box4.backgroundColor = UIColor.red
        setupView1.addSubview(box4)
        
        text4a.text = String(format: "%02d", hitFail)
        text4a.font = UIFont.systemFont(ofSize: 34)
        text4a.textColor = UIColor.white
        text4a.textAlignment = .center
        text4a.frame = CGRect(x: 0, y: 5, width: box4.frame.width, height: 30)
        
        text4b.text = "Fail"
        text4b.font = UIFont.systemFont(ofSize: 17)
        text4b.textColor = UIColor.white
        text4b.textAlignment = .center
        text4b.frame = CGRect(x: 0, y: box4.frame.height-20, width: box4.frame.width, height: 20)
        
        box4.addSubview(text4a)
        box4.addSubview(text4b)
        
        let textYour = UILabel()
        textYour.text = "Your shot is successful on attempts to:"
        textYour.font = UIFont.systemFont(ofSize: 17)
        textYour.textColor = UIColor.white
        textYour.textAlignment = .center
        textYour.frame = CGRect(x: 0, y: box4.frame.height+85, width: setupView1.frame.width, height: 20)
        setupView1.addSubview(textYour)

        let hitTotal = arrHitStatistics.count
        let itemWidth = setupView1.frame.width / 10
     
        
        
        for groupStartIndex in stride(from: 0, to: hitTotal, by: 10) {
            let groupEndIndex = min(groupStartIndex + 10, hitTotal)
            
            let parent = groupStartIndex/10
            
            let y = box4.frame.height+105 + CGFloat((parent * 40))
            
            let containerView = UIView()
            containerView.frame = CGRect(x: 0, y: y, width: setupView1.frame.width, height: 20)
            var i = 0
            
            var startX:Double = 0.0
            if(groupEndIndex%10 != 0){
                startX  = (10.0 - Double(groupEndIndex%10)) * (setupView1.frame.width / 10.0) / 2
            }else{
                startX  = 0
            }
            
            print(startX)
            
            for index in groupStartIndex..<groupEndIndex {
                let hitStat = arrHitStatistics[index]
                let textHit = UILabel()
                textHit.text = hitStat.hitNumber
                textHit.font = UIFont.systemFont(ofSize: 20)
                if(hitStat.hitStatus == "Success"){
                    textHit.textColor = UIColor.white
                }else{
                    textHit.textColor = UIColor.black
                }
                textHit.textAlignment = .center
                textHit.frame = CGRect(x: ((itemWidth) * CGFloat(i)) + startX, y: 20, width: itemWidth, height: 20)
                containerView.addSubview(textHit)
                i += 1
            }
            
            setupView1.addSubview(containerView)
        }
        
        
        
        buttonWhite.removeFromSuperview()
        boxCountdown.removeFromSuperview()
        boxScore.removeFromSuperview()
    }
    
    var textClear = UILabel()
    var text1 = UILabel()
    var text2 = UILabel()
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
                save(url: url)
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
            labelCountdown.text = "GO"
        }else {
            if(isRecording == false){
                startRecording()
                isRecording = true
            }
            boxCountdown.backgroundColor = UIColor(red: 0.99, green: 0.37, blue: 0.33, alpha: 1.0)
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

    @objc func stop(){
        stopRecording()
        urlVideoSource = nil
        detectTrajectoryRequest = nil
        dismiss(animated: true, completion: nil)
        counter.menuStateSend(menuState: "result")
        setupResultView()
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
    
    
    func setupView(){
        let duration = "00:00"
        print("DBUG : ",String(hitTarget))
        counter.hitTotalSend(hitTotal: hitTotal)
        counter.hitTargetSend(hitTarget: hitTarget)
        counter.hitSuccessSend(hitSuccess: hitSuccess)
        counter.hitPerfectSend(hitPerfect: hitPerfect)
        counter.hitFailSend(hitFail: hitFail)
        counter.durationSend(duration: duration)
        
        var menuState = "result"
       
        if(hitTotal > 0){
            if(hitTotal >= hitTarget){
                counter.menuStateSend(menuState:menuState)
            }else{
                menuState = "stillPlay"
                counter.menuStateSend(menuState:menuState)
            }
        }
        
//        menuStateApp = menuState
        
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
        labelCountdown.font = UIFont.systemFont(ofSize: 120)
        view.addSubview(labelCountdown)
        labelCountdown.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelCountdown.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        let boxWidth: CGFloat = 82
        let boxHeight: CGFloat = 36
        
        boxCountdown.frame = CGRect(x: (view.frame.width - boxWidth) / 2, y: view.frame.height - boxHeight - 20, width: boxWidth, height: boxHeight)
        boxCountdown.backgroundColor = nil
        boxCountdown.layer.cornerRadius = 12
        view.addSubview(boxCountdown)
        
        textCountdown.text = ""
        textCountdown.font = UIFont.systemFont(ofSize: 20)
        textCountdown.textColor = UIColor.white
        textCountdown.textAlignment = .center
        textCountdown.frame = CGRect(x: 0, y: 0, width: boxCountdown.frame.width, height: boxCountdown.frame.height)
        
        boxCountdown.addSubview(textCountdown)
        
        
        buttonWhite.frame = CGRect(x: view.frame.size.width - 68 - (34/2), y: (view.frame.size.height/2) - (34/2), width: 68, height: 68)
        buttonWhite.backgroundColor = nil
        buttonWhite.layer.cornerRadius = 34
        buttonWhite.clipsToBounds = true
        buttonWhite.layer.borderWidth = 0.0
        buttonWhite.layer.borderColor = UIColor.white.cgColor
        buttonWhite.addTarget(self, action: #selector(stop), for: .touchUpInside)
        view.addSubview(buttonWhite)
        
        button.frame = CGRect(x: (68-28)/2, y: (68-28)/2, width: 28, height: 28)
        button.backgroundColor = nil
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(stop), for: .touchUpInside)
        
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
        //        boxNet.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        ////        boxNet.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        //        boxNet.layer.cornerRadius = 4
        //
        //        let imageNetView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        //        if let image = UIImage(named: "Net") {
        //            imageNetView.image = image
        //        }
        //        boxNet.addSubview(imageNetView)
        
        
        
//        let boxCourt = UIView()
//        boxCourt.frame = CGRect(x: 20, y: 20, width: 110, height: 135)
//        boxCourt.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
//        boxCourt.layer.cornerRadius = 4
//        
//        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 100, height: 108))
//        if let image = UIImage(named: "Court") {
//            imageView.image = image
//        }
//        boxCourt.addSubview(imageView)
//        
//        let textNet = UILabel()
//        textNet.text = "NET"
//        textNet.font = UIFont.systemFont(ofSize: 15)
//        textNet.textColor = UIColor(red: 0.86, green: 0.79, blue: 0.15, alpha: 1)
//        textNet.textAlignment = .center
//        textNet.frame = CGRect(x: 0, y: 114, width: boxCourt.frame.width, height: 20)
//        boxCourt.addSubview(textNet)
//        
//        
//        boxCourtArea.frame = CGRect(x: 0, y: 0, width: boxCourt.frame.width, height: boxCourt.frame.height-15)
//        //        boxCourtArea.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.4)
//        boxCourtArea.layer.cornerRadius = 4
//        boxCourt.addSubview(boxCourtArea)
//        
//        let boxScore = UIView()
//        boxScore.frame = CGRect(x: boxCourt.frame.width + 30, y: 20, width: 150, height: 69)
//        boxScore.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
//        boxScore.layer.cornerRadius = 4
//        
//        
//        text1.text = String(format: "%02d", hitTotal)
//        text1.font = UIFont.systemFont(ofSize: 34)
//        text1.textColor = UIColor.white
//        text1.textAlignment = .center
//        text1.frame = CGRect(x: 0, y: 10, width: (boxScore.frame.width - 20) / 2, height: 30)
//        
//        text2.text = "/"
//        text2.font = UIFont.systemFont(ofSize: 34)
//        text2.textColor = UIColor.white
//        text2.textAlignment = .center
//        text2.frame = CGRect(x: ((boxScore.frame.width - 20) / 2), y: 10, width: 20, height: 30)
//        
//        text3.text = String(format: "%02d", hitTargetApp)
//        text3.font = UIFont.systemFont(ofSize: 34)
//        text3.textColor = UIColor.white
//        text3.textAlignment = .center
//        text3.frame = CGRect(x: ((boxScore.frame.width - 20) / 2) + 20, y: 10, width: (boxScore.frame.width - 20) / 2, height: 30)
//        
//        let text4 = UILabel()
//        text4.text = "Attemp"
//        text4.font = UIFont.systemFont(ofSize: 15)
//        text4.textColor = UIColor.white
//        text4.textAlignment = .center
//        text4.frame = CGRect(x: 0, y: 40, width: (boxScore.frame.width - 20) / 2, height: 30)
//        
//        
//        let text5 = UILabel()
//        text5.text = "Target"
//        text5.font = UIFont.systemFont(ofSize: 15)
//        text5.textColor = UIColor.white
//        text5.textAlignment = .center
//        text5.frame = CGRect(x: ((boxScore.frame.width - 20) / 2) + 20, y: 40, width: (boxScore.frame.width - 20) / 2, height: 30)
//        
//        // Add the labels to the boxScore
//        boxScore.addSubview(text1)
//        boxScore.addSubview(text2)
//        boxScore.addSubview(text3)
//        boxScore.addSubview(text4)
//        boxScore.addSubview(text5)
//        
//        self.view.addSubview(boxScore)
//        self.view.addSubview(boxCourt)
//        self.view.addSubview(boxNet)
        
        let boxNet = UIView()
        
        let boxCourt = UIView()
        boxCourt.frame = CGRect(x: 20, y: 20, width: 0, height: 0)
        
        boxScore.frame = CGRect(x: boxCourt.frame.width + 30, y: 20, width: 180, height: 69)
        boxScore.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        boxScore.layer.cornerRadius = 4
        
        textClear.text = String(format: "%02d", hitSuccess)
        textClear.font = UIFont.systemFont(ofSize: 34)
        textClear.textColor = UIColor.white
        textClear.textAlignment = .center
        textClear.frame = CGRect(x: 0, y: 10, width: (boxScore.frame.width/3), height: 30)
        
        text1.text = String(format: "%02d", hitTotal)
        text1.font = UIFont.systemFont(ofSize: 34)
        text1.textColor = UIColor.white
        text1.textAlignment = .center
        text1.frame = CGRect(x: (boxScore.frame.width/3), y: 10, width: (boxScore.frame.width/3), height: 30)
        
        text2.text = "/"
        text2.font = UIFont.systemFont(ofSize: 34)
        text2.textColor = UIColor.white
        text2.textAlignment = .center
        text2.frame = CGRect(x: (boxScore.frame.width/3) * 1.85, y: 10, width: 20, height: 30)
        
        text3.text = String(format: "%02d", hitTargetApp)
        text3.font = UIFont.systemFont(ofSize: 34)
        text3.textColor = UIColor.white
        text3.textAlignment = .center
        text3.frame = CGRect(x: (boxScore.frame.width/3) * 2, y: 10, width: (boxScore.frame.width/3), height: 30)
        
        let text4 = UILabel()
        text4.text = "Clear"
        text4.font = UIFont.systemFont(ofSize: 15)
        text4.textColor = UIColor.white
        text4.textAlignment = .center
        text4.frame = CGRect(x: 0, y: 40, width: (boxScore.frame.width/3) * 1, height: 30)
        
        
        let text5 = UILabel()
        text5.text = "Target"
        text5.font = UIFont.systemFont(ofSize: 15)
        text5.textColor = UIColor.white
        text5.textAlignment = .center
        text5.frame = CGRect(x: (boxScore.frame.width/3), y: 40, width: (boxScore.frame.width/3) * 2, height: 30)
        
        let imageView = UIImageView(frame: CGRect(x: (boxScore.frame.width/3)-1, y: 5, width: 2, height: boxScore.frame.height-10))
        if let image = UIImage(named: "Divider") {
            imageView.image = image
        }
        boxScore.addSubview(imageView)
        
        // Add the labels to the boxScore
        boxScore.addSubview(textClear)
        boxScore.addSubview(text1)
        boxScore.addSubview(text2)
        boxScore.addSubview(text3)
        boxScore.addSubview(text4)
        boxScore.addSubview(text5)
        
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
                self?.processTrajectoryObservation(results: results)
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
    @AppStorage("menuStateApp") var menuStateApp = ""
    @AppStorage("duration") var durationApp = ""
    
    var response : [String:Double] = [:]
    
    var summaryClear:[Int] = []
    var summaryPerfect:[Int] = []
    var summaryFail:[Int] = []
    
    
    
    private func processTrajectoryObservation(results: [VNTrajectoryObservation]) {
        
       
        
        // Clear and reset the trajectory view if there are no trajectories.
        guard !results.isEmpty else {
            trajectoryView.resetPath()
            return
        }
        
        delayCorrect = 0
        delayIncorrect = 0
        
        for trajectory in results {
            // Filter the trajectory.
            if filterParabola(trajectory: trajectory) {
                currentPoints = correctTrajectoryPath(trajectoryToCorrect: trajectory)
                correctPoints = currentPoints
                delayCorrect += 1
            } else {
                delayIncorrect += 1
            }
        }
        
        correctPath.append(delayCorrect)
        incorrectPath.append(delayIncorrect)
        
        if(correctPath.count > 1){
            if(correctPath[correctPath.count-2] > 0 && correctPath[correctPath.count-1] == 0 && incorrectPath[incorrectPath.count-2] > 0){
                let firstX = correctPoints.first?.x ?? 0.0
                let lastX = correctPoints.last?.x ?? 0.0
                let trajectoryLength = lastX - firstX
                if(trajectoryLength > 0.22){
                    trajectoryView.performTransition(.fadeIn, duration: 0.05)
                    trajectoryView.points = correctPoints
                    let response = trajectoryView.updatePathLayer()
                    print(response)
                    trajectoryCount += 1
                    //                    print("DBUG: \(trajectoryCount)")
                    //
                    //                    print(trajectoryLength)
                    //                    print(highestPoint)
                    correctPath.removeAll()
                    incorrectPath.removeAll()
                    
                    
                    
                    
                    var x = boxCourtArea.bounds.maxX * correctPoints.last!.x
                    var y = boxCourtArea.bounds.maxY * correctPoints.last!.y
                    if(y < 20){
                        y = boxCourtArea.bounds.maxY / abs(y)
                    }
                    let circle = UIView()
                    
                    //                    y = Double.random(in: (boxCourtArea.frame.width*0.5)...(boxCourtArea.frame.width * 0.75))
                    
                    hitTotal += 1
                    print("HIT : \(hitTotal) SUCCESS : \(hitSuccess) FAIL : \(hitFail)")
                    
                    var status = "Success"
                    
                    if(response["distance"]! < 3){
                        circle.backgroundColor = UIColor(displayP3Red: 255, green: 0, blue: 0, alpha: 0.3)
                        circle.frame = CGRect(x: x, y: boxCourtArea.frame.height - 15, width: 8, height: 8)
                        summaryFail.append(hitTotal)
                        hitFail += 1
                        status = "Fail"
                    }else{
                        hitSuccess += 1
                        if(response["distance"]! < 20){
                            circle.backgroundColor = UIColor(displayP3Red: 0, green: 255, blue: 0, alpha: 0.3)
                            hitPerfect += 1
                            y = Double.random(in: (boxCourtArea.frame.height*0.5)...(boxCourtArea.frame.height * 0.65))
                            x = Double.random(in: (boxCourtArea.frame.width*0.5)...(boxCourtArea.frame.width * 0.65))
                            summaryPerfect.append(hitTotal)
                        }else{
                            circle.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3)
                            y = Double.random(in: (boxCourtArea.frame.height*0.4)...(boxCourtArea.frame.height * 0.5))
                            x = Double.random(in: (boxCourtArea.frame.width*0.5)...(boxCourtArea.frame.width * 0.75))
                            summaryClear.append(hitTotal)
                        }
                        circle.frame = CGRect(x: x, y: y, width: 8, height: 8)
                    }
                    
                    
                    let newData:HitStatistics = HitStatistics(hitNumber: String(hitTotal), hitStatus: status)
                    arrHitStatistics.append(newData)
                
                    text1.text = String(format: "%02d", hitTotal)
                    textClear.text = String(format: "%02d", hitSuccess)
                    text3.text = String(format: "%02d", hitTargetApp)
                    
                   
                    
                    circle.layer.cornerRadius = circle.frame.size.width / 2
                    circle.clipsToBounds = true
                    self.boxCourtArea.addSubview(circle)
                    
                    let durationTime = remainingTimeFix - remainingTime
                    let minutes = durationTime / 60
                    let seconds = durationTime % 60
                    let duration = String(format: "%02d:%02d", minutes, seconds)
                    
                    durationApp = duration
                    
                    
                    counter.hitTotalSend(hitTotal: hitTotal)
                    counter.hitTargetSend(hitTarget: hitTarget)
                    counter.hitSuccessSend(hitSuccess: hitSuccess)
                    counter.hitPerfectSend(hitPerfect: hitPerfect)
                    counter.hitFailSend(hitFail: hitFail)
                    counter.durationSend(duration: duration)
                    
                    var menuState = "result"
                    
                    if(hitTotal > 0){
                        if(hitTotal >= hitTargetApp){
                            counter.menuStateSend(menuState:menuState)
                            stop()
                        }else{
                            menuState = "stillPlay"
                            counter.menuStateSend(menuState:menuState)
                        }
                    }
                    
                    menuStateApp = menuState
                    
                }
            }
        }
//        print("SUMMARY")
//        print(summaryFail)
//        print(summaryClear)
//        print(summaryPerfect)
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
        
        /**
         Filter the trajectory with the following conditions:
         - The trajectory moves from left to right.
         - The trajectory starts in the first half of the region of interest.
         - The trajectory length increases to 8.
         - The trajectory contains a parabolic equation constant a, less than or equal to 0, and implies there
         are either straight lines or downward-facing lines.
         - The trajectory confidence is greater than 0.9.
         
         Add additional filters based on trajectory speed, location, and properties.
         */
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
        
        /**
         This is inside region-of-interest space where both x and y range between 0.0 and 1.0.
         If a left-to-right moving trajectory begins too far from a fixed region, extrapolate it back
         to that region using the available quadratic equation coefficients.
         */
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
            // Update the dictionary with the corrected path.
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
        }else{
            urlVideoSource = nil
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
       
        
        let normalizedFrame = CGRect(x: 0.25, y: 0.4, width: 0.65, height: 0.5)
        
        print("DBUG : ",menuStateApp)
//        print(buffer)
        DispatchQueue.main.async {
            if(self.menuStateApp == "restart"){
                self.restart()
                   print("DBUG : REST")
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
            detectTrajectoryRequest.objectMinimumNormalizedRadius = 5.0 / Float(1920.0)
            detectTrajectoryRequest.objectMaximumNormalizedRadius = 30.0 / Float(1920.0)
            
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
