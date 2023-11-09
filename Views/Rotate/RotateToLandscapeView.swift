//
//  RotateAlertLandscapeView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct RotateToLandscapeView: View {
    @EnvironmentObject var vm: HomeViewModel
    @AppStorage("isOnRecord") var isOnRecord = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            LottieView(name: "Iphone Rotate")
                .scaledToFill()
                .padding(32)
        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isOnRecord = true
                    vm.path.append(.CameraGuide)
                }
            }
        }
    }
}

#Preview {
    RotateToLandscapeView()
}
