/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A scene that displays a trajectory.
 */

import UIKit
import SpriteKit
import Vision
import SwiftUI

import CoreGraphics

class TrajectoryView: SKView, AnimatedTransitioning {

    let localStorage = LocalStorage()

    @AppStorage("type") var type: String = "Low Serve"
    @AppStorage("techniqueName") var techniqueName: String = ""
    @AppStorage("techniqueId") var techniqueId: Int = 0

    // MARK: - Public Properties
    var glowingBallScene: BallScene?
    var outOfROIPoints = 0
    var points: [VNPoint] = []

    // MARK: - Private Properties
    private let pathLayer = CAShapeLayer()
    private let shadowLayer = CAShapeLayer()
    private let gradientMask = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()

    private var yMinLine: Double = 0.0
    private var yMaxLine: Double = 0.0
    private var xMinLine: Double = 0.0
    private var xMaxLine: Double = 0.0

    private var distance: Double = 0.0
    private var cgpoint: [CGPoint] = []

    var xNet: CGFloat = 0
    var yNet: CGFloat = 0

    var selectedPoint = VNPoint(x: 0.0, y: 0.0)
    var highestY = 0.0
    var highestX = 0.0

    let box = UIView()
    let transformBox = CATransform3DMakeScale(1, -1, 1)

    var xTopLeft: CGFloat = 0
    var yTopLeft: CGFloat = 0
    var xTopRight: CGFloat = 0
    var yTopRight: CGFloat = 0
    var xBottomRight: CGFloat = 0
    var yBottomRight: CGFloat = 0
    var xBottomLeft: CGFloat = 0
    var yBottomLeft: CGFloat = 0

    var xTopRightLimit: CGFloat = 0
    var yTopRightLimit: CGFloat = 0
    var xBottomRightLimit: CGFloat = 0
    var yBottomRightLimit: CGFloat = 0

    // MARK: - Life Cycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }

    var status: String = ""
    var isTrajectory: Bool = false

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
    }

    let homographyMatrix: [[Double]] = [
        [ 2.41126359e-02, -1.39130066e-01, 3.81772342e+01],
        [-7.41214343e-02, -1.40321499e-01, 8.57792552e+01],
        [-5.14769358e-05, -1.83348553e-03, 1.00000000e+00]
    ]
    func transformPoint(_ point: CGPoint, withHomographyMatrix matrix: [[Double]]) -> CGPoint {
        let x = Double(point.x)
        let y = Double(point.y)

        let matrixOne = (matrix[0][0] * x + matrix[0][1] * y + matrix[0][2]) / (matrix[2][0] * x + matrix[2][1] * y + matrix[2][2])
        let matrixTwo = (matrix[1][0] * x + matrix[1][1] * y + matrix[1][2]) / (matrix[2][0] * x + matrix[2][1] * y + matrix[2][2])

        return CGPoint(x: round(matrixOne * 100) / 100, y: round(matrixTwo * 100) / 100)
    }

    let homographyMatrixCourt: [[Double]] = [
        [ 1.53444044e-01, -8.85373130e-01, 2.42946031e+02],
        [ 3.60811081e-01, -4.40684754e-03, -4.51504551e+01],
        [-5.14769358e-05, -1.83348553e-03, 1.00000000e+00]
    ]

    var XValues: [Double] = []
    var YValues: [Double] = []

    var transformedXValues: [Double] = []
    var transformedYValues: [Double] = []

    var transformedXValuesMissed: [Double] = []
    var transformedYValuesMissed: [Double] = []

    var transformedXValuesAccepted: [Double] = []
    var transformedYValuesAccepted: [Double] = []

    var transformedXValuesGood: [Double] = []
    var transformedYValuesGood: [Double] = []

    var transformedYValuesAcceptedArr: [Double] = []
    var minDistanceArr: [Double] = []
    var averageOfDistanceArr: [Double] = []
    var varianceArr: [String] = []

    var label: [String] = []

    var averageOfDistance = 0.0
    var minDistance = 0.0
    var variance = ""

    var inputPoints: [CGPoint] = []
    var inputPointsUI: [CGPoint] = []

    func transformPointCourt(_ point: CGPoint, withHomographyMatrix matrix: [[Double]]) -> CGPoint {
        let x = Double(point.x)
        let y = Double(point.y)

        let matrixOne = (matrix[0][0] * x + matrix[0][1] * y + matrix[0][2]) / (matrix[2][0] * x + matrix[2][1] * y + matrix[2][2])
        let matrixTwo = (matrix[1][0] * x + matrix[1][1] * y + matrix[1][2]) / (matrix[2][0] * x + matrix[2][1] * y + matrix[2][2])

        return CGPoint(x: round(matrixOne * 100) / 100, y: round(matrixTwo * 100) / 100)
    }

    func isAccepted(x: Double, y: Double) -> Bool {
        if y>474 || x>260 || y<0 || x<0 {
            return false
        }
        return true
    }

    func minDistance(transformedYValues: [Double]) -> Double {
        return transformedYValues.min() ?? 0.0
    }

    func averageOfDistance(transformedYValues: [Double]) -> Double {
        guard !transformedYValues.isEmpty else {
            return 0.0
        }
        let sum = transformedYValues.reduce(0, +)
        let average = sum / Double(transformedYValues.count)
        return round(average * 100)/100
    }

    func variance(transformedXValues: [Double]) -> String {
        guard !transformedXValuesGood.isEmpty else {
            //            return "error"
            return "-"
        }
        let sum = transformedXValuesGood.reduce(0, +)
        let average = (sum / Double(transformedXValuesGood.count))

        var variance = 0.0

        for x in transformedXValuesGood {
            variance += (x-average) * (x-average)
        }

        variance /= Double(transformedXValuesGood.count)
        let convertedAverage = average*26
        let quarterAverage = convertedAverage/4

        print("CA \(convertedAverage)")
        print("QA \(quarterAverage)")
        print("VA \(variance)")

        if variance>convertedAverage {
            return "Sangat Tersebar"
        } else {
            if variance>quarterAverage {
                return "Cukup Tersebar"
            } else {
                if variance<1 {
                    return "Sangat Terpusat"
                } else {
                    return "Cukup Terpusat"
                }
            }
        }
    }

    func printData(YValues: [Double], minDistance: Double, averageOfDistance: Double, variance: String, index: Int) {
        for (index, distance) in YValues.enumerated() {
            print("Kok \(index+1)")
            print("Jarak dengan garis servis  : \(distance)cm")
            print("Jarak Terdekat             : \(minDistance)cm")
            print("Rerata Jarak Drill         : \(averageOfDistance)cm")
            print("Tipe Penempatan            : \(variance)")
            print("")
        }
    }

    func updatePathLayer() -> (String, Bool, Double, [CGPoint], [String], [Double], [Double], [Double], [String], Double, Double, String) {

        let result = getHighestPoint(points: points, bounds: bounds)
        let status = result.0
        let distance = result.2
        let cgpoint = result.3
        let label = result.4

        let trajectory = UIBezierPath()
        let startingPoint = points.first
        trajectory.move(to: startingPoint?.location ?? CGPoint(x: 0, y: 0))
        for point in points.dropFirst() {
            trajectory.addLine(to: point.location)
        }

        let flipVertical = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
        trajectory.apply(flipVertical)
        trajectory.apply(CGAffineTransform(scaleX: bounds.width, y: bounds.height))

        let shape: CGFloat = CGFloat((1-((1.1-Float(localStorage.loadSize(forKey: String(techniqueId))!)) * 2.5)) * 8)

        let pathLayer = CAShapeLayer()
        pathLayer.lineWidth = shape
        pathLayer.fillColor = UIColor.clear.cgColor

        if techniqueId == 0 {
            if status == "Perfect"{
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Green")?.cgColor
            } else if status == "Success"{
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
            } else {
                pathLayer.strokeColor = localStorage.loadColor(forKey: "Red")?.cgColor
            }
        } else if techniqueId == 1 {
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

        return (status, isTrajectory, distance, cgpoint, label, result.5, result.6, result.7, result.8, result.9, result.10, result.11)
    }

}

extension TrajectoryView {

    func getHighestPoint(points: [VNPoint], bounds: CGRect) -> (String, Bool, Double, [CGPoint], [String], [Double], [Double], [Double], [String], Double, Double, String) {

        isTrajectory = false

        for point in points where point.y > highestY {
            highestY = point.y
            highestX = point.x
            selectedPoint = point
        }

        if techniqueId == 0 {
            processTechniqueIsEmpty()
        } else if techniqueId == 1 {
            processTechniqueId()
        }

        return (status,
                isTrajectory,
                distance,
                cgpoint,
                label,
                transformedYValuesAcceptedArr,
                minDistanceArr,
                averageOfDistanceArr,
                varianceArr,
                minDistance,
                averageOfDistance,
                variance)
    }

    func processTechniqueIsEmpty() {
        let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 14)
        let cornerRadius = size / 2

        yNet = 0.53 * bounds.height
        xNet = bounds.width/2.7

        let box = UIView()
        box.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)

        let transformBox = CATransform3DMakeScale(1, -1, 1)
        box.layer.transform = transformBox

        addSubview(box)

        let circleNet = CALayer()
        circleNet.frame = CGRect(x: xNet, y: yNet, width: size, height: size)
        circleNet.backgroundColor = UIColor.green.cgColor
        circleNet.opacity = 1
        circleNet.cornerRadius = cornerRadius
        circleNet.masksToBounds = true
        //            box.layer.addSublayer(circleNet)

        let x = selectedPoint.x * bounds.maxX
        let y = (1 - selectedPoint.y) * bounds.maxY
        let circlePoint = CALayer()
        circlePoint.frame = CGRect(x: x-(size/2), y: y-(size/2), width: size, height: size)
        circlePoint.cornerRadius = 7.0
        circlePoint.masksToBounds = true

        highestX *= bounds.maxX
        highestY *= bounds.maxY

        distance = 185 * (highestY - yNet) / 195
        print("DBUGG DISTANCE : \(distance)")

        if points.last!.x * bounds.width > xNet && highestY > yNet {
            if highestX < xNet {
                status = "Perfect"
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Green")?.cgColor
                isTrajectory = true
            } else {
                status = "Success"
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
                isTrajectory = true
            }
        } else {
            status = "Fail"
            circlePoint.backgroundColor = localStorage.loadColor(forKey: "Red")?.cgColor
            isTrajectory = true
        }
        // Apply a vertical flip transformation
        let transform = CATransform3DMakeScale(1, -1, 1)
        circlePoint.transform = transform

        layer.addSublayer(circlePoint)
    }

    func processTechniqueId() {
        isTrajectory = true

        xTopLeft = 0.185 * bounds.width
        yTopLeft = 0.755 * bounds.height
        xTopRight = 0.69 * bounds.width
        yTopRight = 0.91 * bounds.height
        xBottomRight = 1 * bounds.width
        yBottomRight = 0.62 * bounds.height
        xBottomLeft = 0.18 * bounds.width
        yBottomLeft = 0.03 * bounds.height

        xTopRightLimit = 0.23 * bounds.width
        yTopRightLimit = 0.765 * bounds.height
        xBottomRightLimit = 0.35 * bounds.width
        yBottomRightLimit = 0.15 * bounds.height

        box.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        box.layer.transform = transformBox

        addSubview(box)

        let xSelected: CGFloat = points.last!.x * bounds.maxX
        let ySelected: CGFloat = points.last!.y * bounds.maxY

        let x = points.last!.x * bounds.maxX
        _ = (1 - points.last!.y) * bounds.maxY

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
        let topLeftLimit = CGPoint(x: xTopLeft, y: yTopLeft)
        let topRightLimit = CGPoint(x: xTopRightLimit, y: yTopRightLimit)
        let bottomRightLimit = CGPoint(x: xBottomRightLimit, y: yBottomRightLimit)
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

        cgpoint.append(transformPoint(CGPoint(x: xSelected, y: ySelected), withHomographyMatrix: homographyMatrix))

        XValues = []
        YValues = []

        transformedXValues = []
        transformedYValues = []

        transformedXValuesMissed = []
        transformedYValuesMissed = []

        transformedXValuesAccepted = []
        transformedYValuesAccepted = []

        transformedXValuesGood = []
        transformedYValuesGood = []

        label = []

        transformedYValuesAcceptedArr = []
        minDistanceArr = []
        averageOfDistanceArr = []
        varianceArr = []

        averageOfDistance = 0.0
        minDistance = 0.0
        variance = ""
        //            inputPoints.removeAll()

        inputPointsUI.append(CGPoint(x: x, y: x))
        inputPoints.append(CGPoint(x: x, y: ySelected))
        label.removeAll()
        // Transformasi dan tampilkan koordinat lapangan untuk setiap titik

        processPoint()

        drawObjects()
    }

    func processPoint() {
        for (index, inputPoint) in inputPoints.enumerated() {

            let outputPoint = transformPointCourt(inputPoint, withHomographyMatrix: homographyMatrixCourt)
            transformedXValues.append(Double(outputPoint.x))
            transformedYValues.append(Double(outputPoint.y))

            XValues.append(Double(inputPoint.x))
            YValues.append(Double(inputPoint.y))

            if !isAccepted(x: outputPoint.x, y: outputPoint.y) {
                transformedXValuesMissed.append(Double(outputPoint.x))
                transformedYValuesMissed.append(Double(outputPoint.y))

                transformedYValuesAcceptedArr.append(Double(outputPoint.y))
                minDistanceArr.append(0)
                averageOfDistanceArr.append(0)
                varianceArr.append("")

            } else {
                transformedXValuesAccepted.append(Double(outputPoint.x))
                transformedYValuesAccepted.append(Double(outputPoint.y))

                averageOfDistance = averageOfDistance(transformedYValues: transformedYValuesAccepted)
                minDistance = minDistance(transformedYValues: transformedYValuesAccepted)

                transformedYValuesAcceptedArr.append(Double(outputPoint.y))
                minDistanceArr.append(minDistance)
                averageOfDistanceArr.append(averageOfDistance)
                varianceArr.append(variance)

            }
            label = []
            transformedXValuesGood = []
            transformedYValuesGood = []
            for index in 0..<transformedXValues.count {
                let xValue = transformedXValues[index]
                let yValue = transformedYValues[index]
                if !isAccepted(x: xValue, y: yValue) {
                    label.append("Fail")
                } else {
                    if yValue<=averageOfDistance {
                        label.append("Perfect")
                        transformedXValuesGood.append(Double(xValue))
                        transformedYValuesGood.append(Double(yValue))
                    } else {
                        label.append("Success")
                    }
                }
            }

            variance = variance(transformedXValues: transformedXValuesGood)
            printData(YValues: transformedYValuesAccepted,
                      minDistance: minDistance,
                      averageOfDistance: averageOfDistance,
                      variance: variance,
                      index: index)
        }
    }

    func drawObjects() {
        let size: CGFloat = CGFloat(Float(localStorage.loadSize(forKey: String(techniqueId))!) * 20)
        for index in 0..<XValues.count {

            let x = inputPoints[index].x
            let y = inputPoints[index].y

            let circlePoint = CALayer()
            circlePoint.frame = CGRect(x: x-(size/2), y: y-(size/2), width: size, height: size)
            circlePoint.cornerRadius = (size/2)
            circlePoint.masksToBounds = true
            // Apply a vertical flip transformation
            let transform = CATransform3DMakeScale(1, -1, 1)
            layer.transform = transform

            layer.addSublayer(circlePoint)

            let text = UILabel()
            text.text = String(index+1)
            text.font = UIFont(name: "Urbanist-Medium", size: 10)
            text.textColor = UIColor.black
            text.textAlignment = .center
            text.frame = CGRect(x: x-(size/2), y: y-(size/2), width: size, height: size)
            text.transform = CGAffineTransform(scaleX: 1, y: -1)
            addSubview(text)

            switch label[index] {
            case "Perfect":
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Green")?.cgColor
            case "Success":
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Yellow")?.cgColor
            case "Fail":
                circlePoint.backgroundColor = localStorage.loadColor(forKey: "Red")?.cgColor
            default:
                print(0)
            }
        }
    }
}
