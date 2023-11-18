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
    
    let localStorage = LocalStorage()
    
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
    
    private var yMinLine:Double = 0.0
    private var yMaxLine:Double = 0.0
    private var xMinLine:Double = 0.0
    private var xMaxLine:Double = 0.0
    
    // MARK: - Life Cycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    
    var status:String = ""
    var isTrajectory:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        allowsTransparency = true
        backgroundColor = UIColor.clear
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
    
    
    
    
    let verticalLayer = CAShapeLayer()
    let horizontalLayer = CAShapeLayer()
    
    let verticalView = UIView()
    let horizontalView = UIView()
    
    private func setupLayer() {
        
        //        verticalLayer.strokeColor = UIColor.yellow.cgColor
        //        verticalLayer.lineWidth = 2.0
        //        verticalLayer.lineDashPattern = [4, 2]
        //        verticalView.layer.addSublayer(verticalLayer)
        //        addSubview(verticalView)
        //
        //        horizontalLayer.strokeColor = UIColor.yellow.cgColor
        //        horizontalLayer.lineWidth = 2.0
        //        horizontalLayer.lineDashPattern = [4, 2]
        //        horizontalView.layer.addSublayer(horizontalLayer)
        //        let transformBox = CATransform3DMakeScale(1, -1, 1)
        //        horizontalView.layer.transform = transformBox
        //        addSubview(horizontalView)
        
    }
    
    
    func getHighestPoint(points: [VNPoint], bounds: CGRect) -> (String,Bool) {
        
        isTrajectory = false
        
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
            
            
            if(points.last!.x * bounds.width > xNet && highestY > yNet){
                status = "Success"
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Green")?.cgColor
                isTrajectory = true
            }else{
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Red")?.cgColor
                isTrajectory = true
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
            circlePoint.frame = CGRect(x: x-7, y: y-7, width: 14, height: 14)
            
            //            circlePoint.opacity = 0.5
            circlePoint.cornerRadius = 7.0
            circlePoint.masksToBounds = true
            
            highestX = highestX * bounds.maxX
            highestY = highestY * bounds.maxY
            
            
            if(points.last!.x * bounds.width > xNet && highestY > yNet){
                if(highestX < xNet){
                    status = "Perfect"
                    circlePoint.backgroundColor = localStorage.loadColor(forKey: "Green")?.cgColor
                    isTrajectory = true
                }else{
                    status = "Success"
                    circlePoint.backgroundColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
                    isTrajectory = true
                }
            }else{
                status = "Fail"
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Red")?.cgColor
                isTrajectory = true
            }
            print("DBUGGG : ",status)
            // Apply a vertical flip transformation
            let transform = CATransform3DMakeScale(1, -1, 1)
            circlePoint.transform = transform
            
            layer.addSublayer(circlePoint)
        }else if(name == "Advanced"){
            var xTopLeft:CGFloat = 0
            var yTopLeft:CGFloat = 0
            var xTopRight:CGFloat = 0
            var yTopRight:CGFloat = 0
            var xBottomRight:CGFloat = 0
            var yBottomRight:CGFloat = 0
            var xBottomLeft:CGFloat = 0
            var yBottomLeft:CGFloat = 0
            
            var xTopLeftLimit:CGFloat = 0
            var yTopLeftLimit:CGFloat = 0
            var xTopRightLimit:CGFloat = 0
            var yTopRightLimit:CGFloat = 0
            
            xTopLeft = 0.35 * bounds.width
            yTopLeft = 0.91 * bounds.height
            xTopRight = 0.65 * bounds.width
            yTopRight = 0.91 * bounds.height
            xBottomRight = 0.85 * bounds.width
            yBottomRight = 0.48 * bounds.height
            xBottomLeft = 0.15 * bounds.width
            yBottomLeft = 0.48 * bounds.height
            print("***")
            print(xTopLeft)
            print(yTopLeft)
            print(xTopRight)
            print(yTopRight)
            print(xBottomRight)
            print(yBottomRight)
            print(xBottomLeft)
            print(yBottomLeft)
            
            let target = 0.6
            
            xTopLeftLimit = xBottomLeft + (xTopLeft - xBottomLeft) * target
            yTopLeftLimit = yBottomLeft + (yTopLeft - yBottomLeft) * target
            xTopRightLimit = xBottomRight + (xTopRight - xBottomRight) * target
            yTopRightLimit = yBottomRight + (yTopRight - yBottomRight) * target
            
            
            let box = UIView()
            box.frame = CGRect(x: 0, y: 0, width: bounds.width,height: bounds.height)
            //                box.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.3)
            //                box.layer.cornerRadius = 4
            
            let transformBox = CATransform3DMakeScale(1, -1, 1)
            box.layer.transform = transformBox
            
            addSubview(box)
            
            
            
            let xSelected: CGFloat = points.last!.x * bounds.maxX
            let ySelected: CGFloat = points.last!.y * bounds.maxY
            
            let x = points.last!.x * bounds.maxX
            let y = (1 - points.last!.y) * bounds.maxY
            let circlePoint = CALayer()
            circlePoint.frame = CGRect(x: x-7, y: y-7, width: 14, height: 14)
            
            //                circlePoint.opacity = 0.5
            circlePoint.cornerRadius = 7.0
            circlePoint.masksToBounds = true
            
            
            
            
            
            
            
            // Define the four corners of the quadrilateral
            let topLeft = CGPoint(x: xTopLeft, y: yTopLeft)
            let topRight = CGPoint(x: xTopRight, y: yTopRight)
            let bottomRight = CGPoint(x: xBottomRight, y: yBottomRight)
            let bottomLeft = CGPoint(x: xBottomLeft, y: yBottomLeft)
            
            // Create a UIBezierPath representing the quadrilateral
            let path = UIBezierPath()
            path.move(to: topLeft)
            path.addLine(to: topRight)
            path.addLine(to: bottomRight)
            path.addLine(to: bottomLeft)
            path.close()
            
            // Define the four corners of the quadrilateral
            let topLeftLimit = CGPoint(x: xTopLeftLimit, y: yTopLeftLimit)
            let topRightLimit = CGPoint(x: xTopRightLimit, y: yTopRightLimit)
            let bottomRightLimit = CGPoint(x: xBottomRight, y: yBottomRight)
            let bottomLeftLimit = CGPoint(x: xBottomLeft, y: yBottomLeft)
            
            // Create a UIBezierPath representing the quadrilateral
            let pathLimit = UIBezierPath()
            pathLimit.move(to: topLeftLimit)
            pathLimit.addLine(to: topRightLimit)
            pathLimit.addLine(to: bottomRightLimit)
            pathLimit.addLine(to: bottomLeftLimit)
            pathLimit.close()
            
            // Create a CAShapeLayer
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = pathLimit.cgPath
            shapeLayer.fillColor = UIColor.green.cgColor
            shapeLayer.opacity = 0.3
            
            // Add the CAShapeLayer to your view's layer
            //                box.layer.addSublayer(shapeLayer)
            
            
            
            
            
            
            
            
            status = "Fail"
            
            
            // Intersection point
            let intersectionPoint = CGPoint(x: xSelected, y: ySelected)
            
            // Vertical Line
            let verticalLineView = UIBezierPath()
            verticalLineView.move(to: CGPoint(x: intersectionPoint.x, y: 0))
            verticalLineView.addLine(to: CGPoint(x: intersectionPoint.x, y: bounds.height))
            let verticalDashes: [CGFloat] = [4, 2]
            verticalLineView.setLineDash(verticalDashes, count: verticalDashes.count, phase: 0)
            verticalLineView.lineWidth = 2.0
            UIColor.yellow.setStroke()
            verticalLineView.stroke()
            verticalLayer.path = verticalLineView.cgPath
            
            // Horizontal Line
            let horizontalLineView = UIBezierPath()
            horizontalLineView.move(to: CGPoint(x: 0, y: intersectionPoint.y))
            horizontalLineView.addLine(to: CGPoint(x: bounds.width, y: intersectionPoint.y))
            let horizontalDashes: [CGFloat] = [4, 2]
            horizontalLineView.setLineDash(horizontalDashes, count: horizontalDashes.count, phase: 0)
            horizontalLineView.lineWidth = 2.0
            UIColor.yellow.setStroke()
            horizontalLineView.stroke()
            horizontalLayer.path = horizontalLineView.cgPath
            
            
            
            // Check if the selected point is inside the quadrilateral
            if pathLimit.contains(CGPoint(x: xSelected, y: ySelected)) {
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Green")?.cgColor
                status = "Perfect"
                isTrajectory = true
            } else  if path.contains(CGPoint(x: xSelected, y: ySelected)) {
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
                status = "Success"
                isTrajectory = true
            }else {
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Red")?.cgColor
                isTrajectory = true
            }
            // Apply a vertical flip transformation
            let transform = CATransform3DMakeScale(1, -1, 1)
            circlePoint.transform = transform
            
            layer.addSublayer(circlePoint)
        }
        
        return (status,isTrajectory)
    }
    
    func updatePathLayer() -> (String,Bool) {
        
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
        pathLayer.lineWidth = 3
        pathLayer.fillColor = UIColor.clear.cgColor
        
        
        if(name == "Intermediate"){
            if(status == "Success"){
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Green")?.cgColor
            }else{
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Red")?.cgColor
            }
        }else if(name == "Experienced"){
            if(status == "Perfect"){
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Green")?.cgColor
            }else if(status == "Success"){
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
            }else{
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Red")?.cgColor
            }
        }else if(name == "Advanced"){
            
        }
        
        //        pathLayer.opacity = 1
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
        
        return (status,isTrajectory)
    }
    
}
