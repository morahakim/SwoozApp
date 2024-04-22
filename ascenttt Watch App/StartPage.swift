//
//  StartPage.swift
//  SwoozWatch Watch App
//
//  Created by mora hakim on 30/10/23.
//

import SwiftUI

struct StartPage: View {
    @State var isCounting: Bool = false

    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("menuStateApp") var menuStateApp = ""

    var body: some View {
        NavigationView {

        }
            }
}

struct CountingPageView: View {
    @State private var tabViewIndex = 0
    @Binding var textCountdown: String
    var body: some View {
        TabView(selection: $tabViewIndex) {
            PauseEndView(value: $tabViewIndex, textCountdown: $textCountdown).tag(1)
            ActivityRingView().tag(0)
        }.tabViewStyle(PageTabViewStyle())
    }
}
#Preview {
    CountingPageView(textCountdown: .constant("20:00"))
}
#Preview {
    StartPage()
}
