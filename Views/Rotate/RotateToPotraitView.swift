//
//  RotateToPotraitView.swift
//  Swooz
//
//  Created by Agung Saputra on 22/10/23.
//

import SwiftUI

struct RotateToPotraitView: View {
    @State private var isAnimationCompleted = false

    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            if !isAnimationCompleted {
                LottieView(name: "iPhone Landscape to Portrait", isAnimationCompleted: $isAnimationCompleted)
                    .frame(width: 600, height: 300)
                    .padding(32)
            }
        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.portrait.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            isAnimationCompleted = true
        }
    }
}

#Preview {
    RotateToPotraitView()
}
