//
//  View+Ext.swift
//  Swooz
//
//  Created by mora hakim on 16/10/23.
//

import SwiftUI
import ReplayKit

extension View {
    // MARK: - Screen Util
    var isLandscape: Bool {
        return getScreenBound().width > getScreenBound().height
    }
    
    func getScreenBound() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getSafeArea() -> UIEdgeInsets {
        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return null
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return null
        }
        
        return safeArea
    }
    
    // MARK: - Record Util
    func startRecord(
        enableMic: Bool = false,
        completion: @escaping (Error?) -> ()
    ) {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = enableMic
        recorder.startRecording(handler: completion)
    }
    
    func stopRecord() async throws -> URL {
        let name = "\(UUID().uuidString).mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        let recorder = RPScreenRecorder.shared()
        
        try await recorder.stopRecording(withOutput: url)
        
        return url
    }
    
    func cancelRecord() {
        let recorder = RPScreenRecorder.shared()
        recorder.discardRecording {}
    }
    
    // MARK: - Share Sheer Util
    func shareSheet(show: Binding<Bool>, items: [Any?]) -> some View {
        return self
            .sheet(isPresented: show) {
                let items = items.compactMap { item -> Any? in
                    return item
                }
                
                if !items.isEmpty {
                    SheetShare(items: items)
                }
            }
    }
}
