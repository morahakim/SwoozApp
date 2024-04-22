//
//  NavbarBack.swift
//  Swooz
//
//  Created by Agung Saputra on 28/10/23.
//

import SwiftUI

struct NavbarBack: View {
    let action: () -> Void
    let bg: Color

    var body: some View {
        HStack(spacing: 15) {
            Button(action: action, label: {
                HStack {
                    Image(systemName: "chevron.left").font(.title3)
                    Text("Back")
                }
            })
            .foregroundStyle(.white)
            Spacer()
        }
        .padding(.top, getSafeArea().top + 10)
        .padding([.horizontal, .bottom], 15)
        .background(bg)
        .ignoresSafeArea(.container, edges: .top)
    }
}
