//
//  RotateToPotraitView.swift
//  Swooz
//
//  Created by Agung Saputra on 22/10/23.
//

import SwiftUI

struct RotateToPotraitView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            LottieView(name: "iPhone Landscape to Portrait").frame(width:600,height:300)
                .padding(32)
//            GifImage("Iphone Landscape to Portrait")
//                .frame(width:330,height: 220)
        }
        .padding(16)
        .navigationBarBackButtonHidden(true).onAppear{
            UIDevice.current.setValue(
                UIInterfaceOrientation.portrait.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .portrait
        }
    }
}

#Preview {
    RotateToPotraitView()
}
