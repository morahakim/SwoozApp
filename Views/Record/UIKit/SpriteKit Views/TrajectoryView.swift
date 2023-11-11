/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A scene that displays a trajectory.
*/

import UIKit
import SpriteKit
import Vision
import SwiftUI

class TrajectoryView: SKView, AnimatedTransitioning {
    
    @AppStorage("type") var type: String = "Low Serve"
    @AppStorage("name") var name: String = "Intermediate"
    
    // MARK: - Public Properties
    var glowingBallScene: BallScene?
    var outOfROIPoints = 0
    var points: [VNPoint] = []
    //    var points: [VNPoint] = [] {
//        didSet {
//            updatePathLayer()
//        }
//    }
    
    // MARK: - Private Properties
    private let pathLayer = CAShapeLayer()
    private let shadowLayer = CAShapeLayer()
    private let gradientMask = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    var yFirst:CGFloat = 0
    var yLast:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        allowsTransparency = true
        backgroundColor = UIColor.clear
        setupLayer()
        glowingBallScene = BallScene(size: CGSize(width: frame.size.width, height: frame.size.height))
        presentScene(glowingBallScene!)
        setupLayer()
        
    }

    // MARK: - Public Methods
    
    func resetPath() {
        let trajectory = UIBezierPath()
        pathLayer.path = trajectory.cgPath
        shadowLayer.path = trajectory.cgPath
        glowingBallScene?.removeAllChildren()
        
    }

    // MARK: - Private Methods
    
    private func setupLayer() {
         
        
        
    }

    
    func getHighestPoint(points: [VNPoint], bounds: CGRect) -> Double {
        var selectedPoint = VNPoint(x: 0.0, y: 0.0) // Initialize with a default value
        var highestY = 0.0
        for point in points {
            if point.y > highestY {
                highestY = point.y
                selectedPoint = point
            }
        }
        var distance:Double = 0.0
        if(name == "Intermediate"){
            yFirst = 0.43 * bounds.height
            yLast = 0.45 * bounds.height
            
            
            let box = UIView()
            box.frame = CGRect(x: 0, y: 0, width: bounds.width,height: bounds.height)
    //        box.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
    //        box.layer.cornerRadius = 4
            
            let transformBox = CATransform3DMakeScale(1, -1, 1)
            box.layer.transform = transformBox
            
            addSubview(box)
            
            let circlePointFirst = CALayer()
            circlePointFirst.frame = CGRect(x: 0, y: yFirst, width: 8, height: 8)
            circlePointFirst.backgroundColor = UIColor.green.cgColor
            circlePointFirst.opacity = 1
            circlePointFirst.cornerRadius = 5.0
            circlePointFirst.masksToBounds = true
//            box.layer.addSublayer(circlePointFirst)
            
            let circlePointLast = CALayer()
            circlePointLast.frame = CGRect(x: bounds.width, y:yLast, width: 8, height: 8)
            circlePointLast.backgroundColor = UIColor.green.cgColor
            circlePointLast.opacity = 1
            circlePointLast.cornerRadius = 5.0
            circlePointLast.masksToBounds = true
//            box.layer.addSublayer(circlePointLast)
            
            let xFirst: CGFloat = 0
            let xLast: CGFloat = bounds.width

            let xNet: CGFloat = selectedPoint.x

            // Calculate the y-coordinate using linear interpolation
            let yNet: CGFloat = yFirst + (xNet - xFirst) * (yLast - yFirst) / (xLast - xFirst)
            
            let circlePointNet = CALayer()
            circlePointNet.frame = CGRect(x: selectedPoint.x * bounds.maxX, y: yNet, width: 8, height: 8)
           
            circlePointNet.opacity = 0.3
            circlePointNet.cornerRadius = 5.0
            circlePointNet.masksToBounds = true
            
            let x = selectedPoint.x * bounds.maxX
            let y = (1 - selectedPoint.y) * bounds.maxY
            let circlePoint = CALayer()
            circlePoint.frame = CGRect(x: x, y: y-3, width: 8, height: 8)
            
            circlePoint.opacity = 0.3
            circlePoint.cornerRadius = 5.0
            circlePoint.masksToBounds = true
            
            let yBall = (selectedPoint.y) * bounds.maxY
            distance = yBall - yNet
            if(distance < 3){
                circlePoint.backgroundColor = UIColor.red.cgColor
                circlePointNet.backgroundColor = UIColor.red.cgColor
            }else if(distance < 20){
                circlePoint.backgroundColor = UIColor.green.cgColor
                circlePointNet.backgroundColor = UIColor.green.cgColor
            }else{
                circlePoint.backgroundColor = UIColor.green.cgColor
                circlePointNet.backgroundColor = UIColor.green.cgColor
            }
            print("\(yBall) - \(yNet) = \(yBall - yNet)")

            // Apply a vertical flip transformation
            let transform = CATransform3DMakeScale(1, -1, 1)
            circlePoint.transform = transform

            layer.addSublayer(circlePoint)
        }else if(name == "Experienced"){
            yLast = 0.55 * bounds.height
            
            
            let box = UIView()
            box.frame = CGRect(x: 0, y: 0, width: bounds.width,height: bounds.height)
//            box.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
//            box.layer.cornerRadius = 4
            
            let transformBox = CATransform3DMakeScale(1, -1, 1)
            box.layer.transform = transformBox
            
            addSubview(box)
            
            let circlePointLast = CALayer()
            circlePointLast.frame = CGRect(x: bounds.width/2.7, y:yLast, width: 8, height: 8)
            circlePointLast.backgroundColor = UIColor.green.cgColor
            circlePointLast.opacity = 1
            circlePointLast.cornerRadius = 5.0
            circlePointLast.masksToBounds = true
//            box.layer.addSublayer(circlePointLast)

            let yNet: CGFloat = yLast
            
            let circlePointNet = CALayer()
            circlePointNet.frame = CGRect(x: selectedPoint.x * bounds.maxX, y: yNet, width: 8, height: 8)
           
            circlePointNet.opacity = 0.3
            circlePointNet.cornerRadius = 5.0
            circlePointNet.masksToBounds = true
            
            let x = selectedPoint.x * bounds.maxX
            let y = (1 - selectedPoint.y) * bounds.maxY
            let circlePoint = CALayer()
            circlePoint.frame = CGRect(x: x, y: y-3, width: 8, height: 8)
            
            circlePoint.opacity = 0.3
            circlePoint.cornerRadius = 5.0
            circlePoint.masksToBounds = true
            
            let yBall = (selectedPoint.y) * bounds.maxY
            distance = yBall - yNet
            if(distance < 3){
                circlePoint.backgroundColor = UIColor.red.cgColor
                circlePointNet.backgroundColor = UIColor.red.cgColor
            }else if(distance < 30){
                circlePoint.backgroundColor = UIColor.green.cgColor
                circlePointNet.backgroundColor = UIColor.green.cgColor
            }else if(distance < 50){
                circlePoint.backgroundColor = UIColor.yellow.cgColor
                circlePointNet.backgroundColor = UIColor.yellow.cgColor
            }else{
                circlePoint.backgroundColor = UIColor.red.cgColor
                circlePointNet.backgroundColor = UIColor.red.cgColor
            }

            // Apply a vertical flip transformation
            let transform = CATransform3DMakeScale(1, -1, 1)
            circlePoint.transform = transform

            layer.addSublayer(circlePoint)
        }else if(name == "Advanced"){
           
        }
        
       
        
        return distance
    }
    
    func updatePathLayer() -> [String: Double] {
        
        let firstX = points.first?.x ?? 0.0
        let lastX = points.last?.x ?? 0.0
        let trajectoryLength = lastX - firstX
       
        let distance = getHighestPoint(points: points, bounds: bounds)
        
        let trajectory = UIBezierPath()
//        guard let startingPoint = points.first else {
//            return
//        }
        let startingPoint = points.first
        trajectory.move(to: startingPoint?.location ?? CGPoint(x: 0, y: 0))
        for point in points.dropFirst() {
            trajectory.addLine(to: point.location)
        }
        
        
        // Scale the trajectory.
        let flipVertical = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
        trajectory.apply(flipVertical)
        trajectory.apply(CGAffineTransform(scaleX: bounds.width, y: bounds.height))
//        print(bounds)

//        print(bounds)
        
        let pathLayer = CAShapeLayer()
        pathLayer.lineWidth = 2.5
        pathLayer.fillColor = UIColor.clear.cgColor
        
        
        if(name == "Intermediate"){
            if(distance < 3){
                pathLayer.strokeColor = UIColor.red.cgColor
            }else if(distance < 20){
                pathLayer.strokeColor = UIColor.green.cgColor
            }else{
                pathLayer.strokeColor = UIColor.green.cgColor
            }
        }else if(name == "Experienced"){
            if(distance < 3){
                pathLayer.strokeColor = UIColor.red.cgColor
            }else if(distance < 30){
                pathLayer.strokeColor = UIColor.green.cgColor
            }else if(distance < 50){
                pathLayer.strokeColor = UIColor.yellow.cgColor
            }else{
                pathLayer.strokeColor = UIColor.red.cgColor
            }
        }else if(name == "Advanced"){
            
        }
        
        pathLayer.opacity = 0.3
        layer.addSublayer(pathLayer)
        
        shadowLayer.path = trajectory.cgPath
        pathLayer.path = trajectory.cgPath
        
      
        
        // Scale up a normalized scene.
        if glowingBallScene!.size.width <= 1.0 || glowingBallScene!.size.height <= 1.0 {
            glowingBallScene = BallScene(size: CGSize(width: frame.size.width, height: frame.size.height))
            presentScene(glowingBallScene!)
        }
        
        // Scale up the trajectory points.
        var scaledPoints: [CGPoint] = []
        for point in points {
            scaledPoints.append(point.location.applying(CGAffineTransform(scaleX: frame.size.width, y: frame.size.height)))
        }
        
        // Animate the ball across the scene.
//        if scaledPoints.last != nil {
//            glowingBallScene!.flyBall(points: scaledPoints)
//        }
        return ["distance": distance, "length": trajectoryLength]
    }
    
}
