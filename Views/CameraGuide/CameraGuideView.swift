//
//  CameraGuideView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct CameraGuideView: View {
    @EnvironmentObject var vm: HomeViewModel
    @AppStorage("isOnRecord") var isOnRecord = true

    @State var step = 0

    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $step) {
                    if step == 0 {
                        WarningView()
                    } else if step == 1 {
                        LottieView(name: "CameraPlacementDistance")
                    } else if step == 2 {
                        LottieView(name: "CameraPlacementHeight")
                    }
                }
                .animation(.easeInOut, value: step)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                BtnPrimary(text: "Continue") {
//                    if step < 2 {
//                        step += 1
//                    } else {
//                        isOnRecord = true
//                        vm.path.append(.Record)
//                    }
                    isOnRecord = true
                    vm.path.append(.Record)
                }
                .frame(width: 300)
            }
        }
        .padding(8)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight
        }
        .onDisappear {
            AppDelegate.orientationLock = .landscapeRight
        }
    }
}

private struct WarningView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .center, spacing: 20) {
                Image("MaxImg")
                    .frame(width: 60, height: 60)
                Text(maxText)
                    .font(Font.custom("SF Pro", size: 34))
            }
            Text(recordingDurationText)
                .font(Font.custom("SF Pro", size: 15))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.99, green: 0.37, blue: 0.33))
                .frame(width: 358, alignment: .top)
        }
        .offset(y: 50)
    }
}

#Preview {
    CameraGuideView()
}
