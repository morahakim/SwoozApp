//
//  RecordView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var vm: HomeViewModel

    @AppStorage("isOnRecord") var isOnRecord = true
    @AppStorage("hitTarget") var hitTarget: Int = 0
    @AppStorage("dataUrl") var dataUrl: String = ""
    @AppStorage("techniqueId") var techniqueId = 0

    var body: some View {
        VStack {
            if isOnRecord {
                HomeViewRepresentable(moc: moc, vm: vm)
            } else {
                LoadingRecordView()
            }
        }
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RecordView()
}
