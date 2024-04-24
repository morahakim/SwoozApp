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
            LottieView(name: "Iphone Rotate").frame(width: 600, height: 300)
                .padding(32)
//            GifImage("Iphone Portrait to Landscape")
//                .frame(width:330,height: 220)
        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isOnRecord = true
                    vm.path.append(.record)
                }
            }
        }
    }
}

#Preview {
    RotateToLandscapeView()
}
