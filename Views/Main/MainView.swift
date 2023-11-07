//
//  ContentView.swift
//  Swooz
//
//  Created by mora hakim on 16/10/23.
//

import SwiftUI

enum Path: String {
    case Recording
    case Home
    case Statistic
}

struct MainView: View {
    @AppStorage("isOnBoarding") var isOnBoarding: Bool = true
    @State var isSplashScreen = true
    
    var body: some View {
        if isSplashScreen {
            SplashView(isShow: $isSplashScreen)
        } else {
//            if isOnBoarding {
//                OnBoardingView()
//            } else {
//                HomeView()
//            }
            HomeView()
        }
    }
}

#Preview {
    MainView()
}
