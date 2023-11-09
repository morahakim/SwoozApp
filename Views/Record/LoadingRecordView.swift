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
            RotateToPotraitView()
        }
        .padding(16)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                vm.popToRoot()
            }
        }
    }
}

#Preview {
    LoadingRecordView()
}
