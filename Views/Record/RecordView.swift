//
//  RecordView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.managedObjectContext) var moc
    
    @AppStorage("isOnRecord") var isOnRecord = true
    @AppStorage("hitTarget") var hitTarget: Int = 0
    @AppStorage("dataUrl") var dataUrl: String = ""
    
    var body: some View {
        VStack {
            if isOnRecord {
                HomeViewRepresentable()
            } else {
                LoadingRecordView()
                    .onAppear {
                        save(url: dataUrl)
//                        hitTarget = 0
                    }
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
    
    @AppStorage("hitFailApp") var hitFailApp = 0
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("hitPerfectApp") var hitPerfectApp = 0
    @AppStorage("durationApp") var durationApp = ""
    
    private func save(url: String) {
        let data = Data(context: moc)
        data.id = UUID()
        data.url = url
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-MM-dd HH:mm:ss"
        let currentDateTime = Date()
        let formattedDate = dateFormatter.string(from: currentDateTime)
        data.datetime = String(formattedDate)
        data.hitTarget = String(hitTargetApp)
        data.hitTotal = String(hitTargetApp)
        data.hitSuccess = String(hitSuccessApp)
        data.hitPerfect = String(hitPerfectApp)
        data.hitFail = String(hitFailApp)
        data.duration = String(durationApp)
        data.type = "Low Serve"
        try? moc.save()
        dataUrl = ""
    }
}

#Preview {
    RecordView()
}
