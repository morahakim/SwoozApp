//
//  RotateAlertPotraitView.swift
//  Swooz
//
//  Created by Agung Saputra on 18/10/23.
//

import SwiftUI

struct LoadingRecordView: View {
    @EnvironmentObject var vm: HomeViewModel
    @State private var isShowAlerRotate = true
    
    var body: some View {
        ZStack {
            if isShowAlerRotate {
                RotateToPotraitView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isShowAlerRotate = false
                            }
                        }
                    }
            } else {
                TipsView()
            }
            VStack {
                Spacer()
                Image(isShowAlerRotate ? "Load10" : "Load50")
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                vm.popToRoot()
            }
        }
        .padding(16)
    }
}

struct TipsView: View {
    var body: some View {
        VStack {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 214.73685, height: 320)
              .background(
                Image("LoadingHero")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
              )
            Text("Processing your game data.")
              .font(Font.custom("SF Pro", size: 15))
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
              .frame(width: 358, alignment: .top)
              .padding(.top, 24)
        }
    }
}

#Preview {
    LoadingRecordView()
}
