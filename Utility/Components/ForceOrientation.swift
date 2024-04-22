//
//  PotraitView.swift
//  ascenttt
//
//  Created by Agung Saputra on 07/11/23.
//

import SwiftUI

struct ForceOrientation<Content: View>: View {
    let content: () -> Content
    let orientation: UIInterfaceOrientationMask

    init(_ orientation: UIInterfaceOrientationMask, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.orientation = orientation
    }

    var body: some View {
        Group {
            content()
        }
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.portrait.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = orientation
        }
        .onDisappear {
            AppDelegate.orientationLock = .all
        }
        .preferredColorScheme(.light)
    }
}
