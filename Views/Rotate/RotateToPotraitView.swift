//
//  RotateToPotraitView.swift
//  Swooz
//
//  Created by Agung Saputra on 22/10/23.
//

import SwiftUI

struct RotateToPotraitView: View {
    var body: some View {
        ZStack {
            VStack {
                LottieView(name: "Iphone Rotate")
//                    .frame(width: 300)
                    .scaledToFit()
//                    .padding(.horizontal, 32)
//                Text("Rotate your iPhone for a portrait view.")
//                    .font(Font.custom("SF Pro", size: 15))
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RotateToPotraitView()
}
