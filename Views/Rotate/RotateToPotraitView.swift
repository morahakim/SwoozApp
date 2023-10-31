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
            Text("Rotate your iPhone for a portrait view.")
                .font(Font.custom("SF Pro", size: 15))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                .rotationEffect(Angle(degrees: 90))
                .frame(maxHeight: 800)
                .offset(x: -80)
            Image("RotatePotraitImg")
                .scaledToFit()
                .offset(x: 25)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RotateToPotraitView()
}
