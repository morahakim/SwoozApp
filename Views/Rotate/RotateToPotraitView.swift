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
            LottieView(name: "Iphone Rotate")
                .scaledToFill()
                .padding(32)
        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RotateToPotraitView()
}
