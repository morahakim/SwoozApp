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
    
    
    var status:String = ""
    
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

    
    func getHighestPoint(points: [VNPoint], bounds: CGRect) -> (String,String) {
        
        var xNet:CGFloat = 0
        var yNet:CGFloat = 0
  
        var selectedPoint = VNPoint(x: 0.0, y: 0.0)
        var highestY = 0.0
        var highestX = 0.0
        for point in points {
            if point.y > highestY {
                highestY = point.y
                highestX = point.x
                selectedPoint = point
            }
        }
        
        if(name == "Intermediate"){
            yNet = 0.55 * bounds.height
            xNet = bounds.width/2.7
            
            let box = UIView()
            box.frame = CGRect(x: 0, y: 0, width: bounds.width,height: bounds.height)
//            box.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
//            box.layer.cornerRadius = 4
            
            let transformBox = CATransform3DMakeScale(1, -1, 1)
            box.layer.transform = transformBox
            
            addSubview(box)
            
            let circleNet = CALayer()
            circleNet.frame = CGRect(x: xNet, y:yNet, width: 8, height: 8)
            circleNet.backgroundColor = UIColor.green.cgColor
            circleNet.opacity = 1
            circleNet.cornerRadius = 5.0
            circleNet.masksToBounds = true
//            box.layer.addSublayer(circleNet)

            
            let x = selectedPoint.x * bounds.maxX
            let y = (1 - selectedPoint.y) * bounds.maxY
            let circlePoint = CALayer()
            circlePoint.frame = CGRect(x: x, y: y-3, width: 8, height: 8)
            
            circlePoint.opacity = 0.0
            circlePoint.cornerRadius = 5.0
            circlePoint.masksToBounds = true
            
            highestX = highestX * bounds.maxX
            highestY = highestY * bounds.maxY
            status = "Fail"
            
            print("DBUG : \(highestY) -  \(yNet)")
            
            if(points.last!.x * bounds.width > xNet && highestY > yNet){
                status = "Success"
                circlePoint.backgroundColor = UIColor.green.cgColor
            }else{
                circlePoint.backgroundColor = UIColor.red.cgColor
            }

            // Apply a vertical flip transformation
            let transform = CATransform3DMakeScale(1, -1, 1)
            circlePoint.transform = transform

            layer.addSublayer(circlePoint)
        }else if(name == "Experienced"){
            yNet = 0.55 * bounds.height
            xNet = bounds.width/2.7
            
            let box = UIView()
            box.frame = CGRect(x: 0, y: 0, width: bounds.width,height: bounds.height)
//            box.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
//            box.layer.cornerRadius = 4
            
            let transformBox = CATransform3DMakeScale(1, -1, 1)
            box.layer.transform = transformBox
            
            addSubview(box)
            
            let circleNet = CALayer()
            circleNet.frame = CGRect(x: xNet, y:yNet, width: 8, height: 8)
            circleNet.backgroundColor = UIColor.green.cgColor
            circleNet.opacity = 1
            circleNet.cornerRadius = 5.0
            circleNet.masksToBounds = true
//            box.layer.addSublayer(circleNet)

            
            let x = selectedPoint.x * bounds.maxX
            let y = (1 - selectedPoint.y) * bounds.maxY
            let circlePoint = CALayer()
            circlePoint.frame = CGRect(x: x, y: y-3, width: 8, height: 8)
            
            circlePoint.opacity = 0.5
            circlePoint.cornerRadius = 5.0
            circlePoint.masksToBounds = true
            
            highestX = highestX * bounds.maxX
            highestY = highestY * bounds.maxY
            status = "Fail"
            
            print("DBUG : \(highestY) -  \(yNet)")
            
            if(points.last!.x * bounds.width > xNet && highestY > yNet){
                if(highestX < xNet){
                    status = "Success"
                    circlePoint.backgroundColor = UIColor.green.cgColor
                }else{
                    circlePoint.backgroundColor = UIColor.red.cgColor
                }
            }else{
                circlePoint.backgroundColor = UIColor.red.cgColor
            }
            
            // Apply a vertical flip transformation
            let transform = CATransform3DMakeScale(1, -1, 1)
            circlePoint.transform = transform

            layer.addSublayer(circlePoint)
        }else if(name == "Advanced"){
           
        }
        
        return (status,status)
    }
    
    func updatePathLayer() -> (String,String) {
       
        let result = getHighestPoint(points: points, bounds: bounds)
        let status = result.0
        
        let trajectory = UIBezierPath()
//        guard let startingPoint = points.first else {
//            return
//        }
        let startingPoint = points.first
        trajectory.move(to: startingPoint?.location ?? CGPoint(x: 0, y: 0))
        for point in points.dropFirst() {
            trajectory.addLine(to: point.location)
        }
        
        
        let flipVertical = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
        trajectory.apply(flipVertical)
        trajectory.apply(CGAffineTransform(scaleX: bounds.width, y: bounds.height))
//        print(bounds)

//        print(bounds)
        
        let pathLayer = CAShapeLayer()
        pathLayer.lineWidth = 2.5
        pathLayer.fillColor = UIColor.clear.cgColor
        
        
        if(name == "Intermediate"){
            if(status == "Success"){
                pathLayer.strokeColor = UIColor.green.cgColor
            }else{
                pathLayer.strokeColor = UIColor.red.cgColor
            }
        }else if(name == "Experienced"){
            if(status == "Success"){
                pathLayer.strokeColor = UIColor.green.cgColor
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
//        return ["distance": distance, "highestX": highestX, "highestY": highestY, "length": trajectoryLength, "status": status]
        
        return (status,status)
    }
    
}
