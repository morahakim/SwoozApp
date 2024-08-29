//
//  ShuttlecockTrackingView.swift
//  ascenttt
//
//  Created by mora hakim on 08/08/24.
//

import SwiftUI
import AVFoundation
import OpenCV

struct ShuttlecockTrackingView: View {
    @StateObject private var viewModel = ShuttlecockTrackingViewModel()
    
    var body: some View {
        VStack {
            if let uiImage = viewModel.currentUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Loading video...")
            }
        }
        .onAppear {
            viewModel.startProcessing()
        }
        .onDisappear {
            viewModel.stopProcessing()
        }
    }
}

class ShuttlecockTrackingViewModel: ObservableObject {
    @Published var currentUIImage: UIImage?
    
    private var videoCapture: VideoCapture!
    private var previousFrame: Mat?
    private var shuttlecockTrajectory: [Point2f] = []
    private var processingQueue = DispatchQueue(label: "com.shuttlecock.tracking")
    private var isProcessing = false
    
    func startProcessing() {
        guard !isProcessing else { return }
        isProcessing = true
        
        videoCapture = VideoCapture()
        videoCapture.open(0) // Open the first camera (use a file path for video files)
        
        if !videoCapture.isOpened() {
            print("Unable to open video capture")
            return
        }
        
        processingQueue.async {
            self.processVideo()
        }
    }
    
    func stopProcessing() {
        isProcessing = false
        videoCapture.release()
    }
    
    private func processVideo() {
        while isProcessing {
            let currentFrame = Mat()
            if !videoCapture.read(currentFrame) {
                break
            }
            
            var currentGray = Mat()
            cvtColor(src: currentFrame, dst: &currentGray, code: COLOR_BGR2GRAY)
            
            if let previousGray = previousFrame {
                var prevCorners = [Point2f]()
                var currCorners = [Point2f]()
                var status = [UInt8]()
                var err = [Float]()
                
                let corners = previousGray.goodFeaturesToTrack(maxCorners: 100, qualityLevel: 0.3, minDistance: 7.0, mask: Mat(), blockSize: 7)
                prevCorners.append(contentsOf: corners)
                
                calcOpticalFlowPyrLK(prevImg: previousGray, nextImg: currentGray, prevPts: prevCorners, nextPts: &currCorners, status: &status, err: &err)
                
                for i in 0..<prevCorners.count {
                    if status[i] == 1 {
                        let p0 = prevCorners[i]
                        let p1 = currCorners[i]
                        
                        shuttlecockTrajectory.append(p1)
                        
                        line(img: &currentFrame, pt1: p0, pt2: p1, color: Scalar(0, 255, 0), thickness: 2)
                        circle(img: &currentFrame, center: p1, radius: 3, color: Scalar(0, 0, 255), thickness: -1)
                    }
                }
            }
            
            previousFrame = currentGray.clone()
            DispatchQueue.main.async {
                self.currentUIImage = UIImage(mat: currentFrame)
            }
        }
    }
}

extension UIImage {
    convenience init?(mat: Mat) {
        guard let cgImage = UIImage.convertMatToCGImage(mat: mat) else { return nil }
        self.init(cgImage: cgImage)
    }
    
    private static func convertMatToCGImage(mat: Mat) -> CGImage? {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue).union(.byteOrder32Little)
        let context = CGContext(data: mat.dataPtr(), width: mat.cols, height: mat.rows, bitsPerComponent: 8, bytesPerRow: mat.step, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        return context?.makeImage()
    }
}
