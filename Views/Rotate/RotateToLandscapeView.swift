//
//  RotateAlertLandscapeView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct RotateToLandscapeView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image("RotateLandscapeImg")
                .scaledToFit()
                .scaleEffect(x: -1, y: 1)
            Text("Rotate your iPhone for landscape view.")
                .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                .frame(width: 358, alignment: .top)
        }
        .padding(16)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    vm.path.append(.CameraGuide)
                }
            }
        }
    }
}

#Preview {
    RotateToLandscapeView()
}
