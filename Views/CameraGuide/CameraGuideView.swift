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
    @AppStorage("isCamerePlacement") var isCamerePlacement: Bool = true
    @State var step = 0
    
    var body: some View {
        NavigationView {
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
                    .offset(y: -70)
                    .rotationEffect(Angle(degrees: 90))
                    .animation(.easeInOut, value: step)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
                GeometryReader { gr in
                    Group {
                        BtnPrimary(text: "Continue") {
//                            if step < 2 {
//                                step += 1
//                            } else {
//                                isOnRecord = true
//                                vm.path.append(.Record)
//                            }
                            isOnRecord = true
                            isCamerePlacement = true
                            vm.path.append(.Record)
                        }
                        .rotationEffect(Angle(degrees: 90))
                        .frame(width: 220)
                    }
                    .position(
                        x: gr.size.width/10,
                        y: gr.size.height/2
                    )
                }
            }
            .padding(8)
        }
        .navigationBarBackButtonHidden(true)
    }
}

private struct WarningView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .center, spacing: 20) {
                Image("MaxImg")
                    .frame(width: 60, height: 60)
                Text("Max 20 Minutes")
                    .font(Font.custom("SF Pro", size: 34))
            }
            Text("Recording is limited to 20 minutes,\nand the video will automatically stop thereafter.")
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
