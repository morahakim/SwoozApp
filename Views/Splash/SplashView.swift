//
//  SplashView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct SplashView: View {
    @Binding var isShow: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.75, blue: 0.45)
                .ignoresSafeArea(.all)
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 172)
                    .padding(.bottom, 32)
                Text("SWOOZ")
                  .font(
                    Font.custom("Urbanist", size: 34)
                      .weight(.medium)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.98, green: 0.99, blue: 0.98))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isShow = false
            }
        }
    }
}

#Preview {
    SplashView(isShow: .constant(true))
}
