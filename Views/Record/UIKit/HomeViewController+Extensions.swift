//
//  HomeViewController+Extensions.swift
//  ascenttt
//
//  Created by Hanifah BN on 05/05/24.
//

import Foundation
import UIKit
import ReplayKit

extension HomeViewController {
    func stopRecordScreen() async throws -> URL {
        let name = "\(UUID().uuidString).mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        let recorder = RPScreenRecorder.shared()
        try await recorder.stopRecording(withOutput: url)
        return url
    }

    @objc func startRecording() {
        startRecordScreen { error in
            if let element = error {
                print(element.localizedDescription)
                return
            }
        }
        print("Start Recording!")
    }

    func startRecordScreen(
        enableMic: Bool = false,
        completion: @escaping (Error?) -> Void
    ) {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = enableMic
        recorder.startRecording(handler: completion)
        if recorder.isRecording {
            print("RECORD")
            stopRecording()
            liveCamera()
        } else {
            print("NOT RECORD")
//            menuStateApp = "placement"
//            contentAnalysisViewController.counter.menuStateSend(menuState: "placement")
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

    @objc func setColorYellow() {
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

    @objc func setColorRed() {
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

    @objc func setUpPathColorViewBasedOnTechnique(techniqueId: Int) {
        if techniqueId == 0 {

            let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 14)
            let cornerRadius = size / 2
            let shape: CGFloat = CGFloat((1-((1.1-Float(localStorage.loadSize(forKey: String(techniqueId))!)) * 2.5)) * 8)

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

        } else if techniqueId == 1 {

            let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 20)
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
    }

    @objc func setCircleGreenPath(xValue: Double, yValue: Double, width: Double, height: Double) {
        self.circleGreenPath.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
        self.circleGreenPath.layer.opacity = 1
        self.circleGreenPath.layer.cornerRadius = 12
        self.circleGreenPath.layer.masksToBounds = true
        self.circleGreenPath.backgroundColor = localStorage.loadColor(forKey: "Green")
    }

    @objc func setCircleRedPath(xValue: Double, yValue: Double, width: Double, height: Double) {
        self.circleRedPath.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
        self.circleRedPath.layer.opacity = 1
        self.circleRedPath.layer.cornerRadius = 12
        self.circleRedPath.layer.masksToBounds = true
        self.circleRedPath.backgroundColor = localStorage.loadColor(forKey: "Red")
    }

    @objc func setCircleYellowPath(xValue: Double, yValue: Double, width: Double, height: Double) {
        self.circleYellowPath.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
        self.circleYellowPath.layer.opacity = 1
        self.circleYellowPath.layer.cornerRadius = 12
        self.circleYellowPath.layer.masksToBounds = true
        self.circleYellowPath.backgroundColor = localStorage.loadColor(forKey: "Yellow")
    }

    @objc func setSlider(xValue: Double, yValue: Double, width: Double, height: Double) -> UISlider {
        let slider = UISlider()
        slider.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
        slider.minimumValue = 0.8
        slider.maximumValue = 1
        slider.value = Float(localStorage.loadSize(forKey: String(techniqueId)) ?? 0.2)
        slider.tintColor = .white
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }

    @objc func setDoneButton(buttonSaveText: String, xValue: Double, yValue: Double, width: Double, height: Double) -> UIButton {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle(buttonSaveText, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        doneButton.backgroundColor = UIColor(red: 33/255.0, green: 191/255.0, blue: 115/255.0, alpha: 1.0)
        doneButton.layer.cornerRadius = 12

        doneButton.frame = CGRect(x: xValue, y: yValue, width: width, height: height)

        return doneButton
    }

    @objc func setFourthBox(sizeTrajectoryText: String, xValue: Double, yValue: Double, width: Double, height: Double) -> UIView {
        let box4 = UIView()

        box4.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
        //        box1.backgroundColor = .blue

        let text4 = UILabel()
        text4.text = sizeTrajectoryText
        text4.font = UIFont(name: "Urbanist", size: 20)
        text4.textColor = UIColor.white
        text4.textAlignment = .right
        text4.frame = CGRect(x: 0, y: 20, width: box4.frame.width/2 - 10, height: 34)
        box4.addSubview(text4)

        return box4
    }

    @objc func setHiddenViews() {
        self.boxNet.isHidden = true

        self.boxView.isHidden = true
        self.buttonClose.isHidden = true
        self.buttonPathColor.isHidden = true
        self.buttonWhite.isHidden = true
        self.buttonSetUp.isHidden = true

        self.buttonPathColor.isHidden = true
    }

    @objc func setupPathColorView() {

        self.setHiddenViews()

        pathColorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(pathColorView)

        self.setUpPathColorViewBasedOnTechnique(techniqueId: techniqueId)

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

        self.setCircleGreenPath(xValue: (select1.frame.height-24)/2, yValue: (select1.frame.height-24)/2, width: 24, height: 24)

        select1.addSubview(self.circleGreenPath)

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

        self.setCircleYellowPath(xValue: (select2.frame.height-24)/2, yValue: (select2.frame.height-24)/2, width: 24, height: 24)

        select2.addSubview(self.circleYellowPath)

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

        self.setCircleRedPath(xValue: (select3.frame.height-24)/2, yValue: (select3.frame.height-24)/2, width: 24, height: 24)

        select3.addSubview(self.circleRedPath)

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

        let box4 = self.setFourthBox(sizeTrajectoryText: sizeTrajectoryText, xValue: 0, yValue: 35, width: boxPathColor.frame.width / 3.0, height: 34)

        let slider = self.setSlider(xValue: pathColorView.frame.width * 0.275, yValue: pathColorView.frame.height * 0.7, width: pathColorView.frame.width * 0.525, height: 34)
        pathColorView.addSubview(slider)

        boxPathColor.addSubview(box1)
        boxPathColor.addSubview(box2)
        boxPathColor.addSubview(box3)
        boxPathColor.addSubview(box4)

        let doneButton = self.setDoneButton(buttonSaveText: buttonSaveText, xValue: (boxPathColor.frame.width-350)/2, yValue: 90, width: 350, height: 50)

        doneButton.addTarget(self, action: #selector(save), for: .touchUpInside)

        boxPathColor.addSubview(doneButton)

    }

    @objc func sliderValueChanged(_ sender: UISlider) {
        print("Slider value: \(sender.value)")
        if techniqueId == 0 {
            localStorage.saveSize(sender.value, forKey: String(techniqueId))
            let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 14)
            let cornerRadius = size / 2
            let shape: CGFloat = CGFloat((1-((1.1-Float(localStorage.loadSize(forKey: String(techniqueId))!)) * 2.5)) * 8)

            shapeLayerGreen.lineWidth = shape
            shapeLayerYellow.lineWidth = shape
            shapeLayerRed.lineWidth = shape
            circleGreen.frame = CGRect(x: (pathColorView.frame.width/2.4) - size/2, y: (pathColorView.frame.height/2.44) - size/2, width: size, height: size)
            circleYellow.frame = CGRect(x: (pathColorView.frame.width/1.9) - size/2, y: (pathColorView.frame.height/3.22) - size/2, width: size, height: size)
            circleRed.frame = CGRect(x: (pathColorView.frame.width/2.2) - size/2, y: (pathColorView.frame.height/1.90) - size/2, width: size, height: size)
            circleGreen.layer.cornerRadius = cornerRadius
            circleYellow.layer.cornerRadius = cornerRadius
            circleRed.layer.cornerRadius = cornerRadius
        } else if techniqueId == 1 {
            localStorage.saveSize(sender.value, forKey: String(techniqueId))
            let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 20)
            let cornerRadius = size / 2
            circleGreen.frame = CGRect(x: (pathColorView.frame.width * 0.28) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            circleYellow.frame = CGRect(x: (pathColorView.frame.width * 0.38) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)
            circleRed.frame = CGRect(x: (pathColorView.frame.width * 0.18) - size/2, y: (pathColorView.frame.height * 0.4) - size/2, width: size, height: size)

            circleGreen.layer.cornerRadius = cornerRadius
            circleYellow.layer.cornerRadius = cornerRadius
            circleRed.layer.cornerRadius = cornerRadius
        }
    }

    func setupViewBasedOnTechnique(techniqueID: Int) {
        if techniqueId == 0 {
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

        } else if techniqueId == 1 {
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
    }

    func setupView() {
        imageNetView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        boxNet.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //        boxNet.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.4)
        boxNet.layer.cornerRadius = 4

        self.setupViewBasedOnTechnique(techniqueID: techniqueId)

//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDir))
//                view.isUserInteractionEnabled = true
//                view.addGestureRecognizer(tapGesture)

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
        iconImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
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
}
