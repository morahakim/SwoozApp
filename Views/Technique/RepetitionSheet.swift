//
//  RepetitionSheet.swift
//  ascenttt
//
//  Created by Hanifah BN on 05/05/24.
//

import SwiftUI

struct RepetitionSheet: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var isPresented: Bool
    @Binding var selectedRepetition: Int

    @AppStorage("hitTargetApp") var hitTargetApp: Int = 0

    var body: some View {
        VStack(alignment: .leading) {
            TextAlignLeading(repetitionText)
                .font(Font.custom("SF Pro", size: 20).bold())
                .foregroundColor(.neutralBlack)
                .padding(.top, 18)
                .padding(.horizontal, 16)

            Picker("", selection: $selectedRepetition) {
                Text(unlimitedText).tag(0)
                Text("5").tag(5)
                Text("10").tag(10)
                Text("15").tag(15)
                Text("20").tag(20)
            }
            .pickerStyle(.wheel)
            .padding(.horizontal, 16)

            Divider()
            BtnPrimary(text: continueText) {
                hitTargetApp = selectedRepetition
                isPresented.toggle()
                viewModel.path.append(.rotateToLandscape)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.portrait.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight
        }
    }
}

// #Preview {
//    RepetitionSheet()
// }
