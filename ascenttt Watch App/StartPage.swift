//
//  StartPage.swift
//  SwoozWatch Watch App
//
//  Created by mora hakim on 30/10/23.
//

import SwiftUI

struct StartPage: View {
//    let camera = ContentAnalysisViewController()
//    let counter = Counter()
    @State var isCounting: Bool = false
    
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("menuStateApp") var menuStateApp = ""
    
//    let contentView = ContentView()
    
    var body: some View {
        NavigationView {
            

        }
            }
}

struct CountingPageView: View {
    @State private var tabViewIndex = 0
    var body: some View {
        TabView(selection: $tabViewIndex) {
            PauseEndView(value: $tabViewIndex).tag(1)
            ActivityRingView().tag(0)
        }.tabViewStyle(PageTabViewStyle())
    }
}
#Preview {
    CountingPageView()
}
#Preview {
    StartPage()
}
