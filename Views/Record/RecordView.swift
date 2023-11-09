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
                HomeViewRepresentable(moc: moc)
            } else {
                LoadingRecordView()
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RecordView()
}
