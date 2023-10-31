//
//  Button.swift
//  Swooz
//
//  Created by Agung Saputra on 24/10/23.
//

import Foundation
import SwiftUI

struct BtnPrimary: View {
    var text: String
    var action: () -> Void
    var body: some View {
        if isLandscape {
            Button(action: action, label: {
                HStack(alignment: .center, spacing: 4) {
                    Text(text)
                        .font(Font.custom("SF Pro", size: 17))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(.greenMain)
                .cornerRadius(12)
            })
        } else {
            Button(action: action, label: {
                HStack(alignment: .center, spacing: 4) {
                    Text(text)
                        .font(Font.custom("SF Pro", size: 17))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(.greenMain)
                .cornerRadius(12)
            })
        }
    }
}

struct BtnPrimaryPlain: View {
    var text: String
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(text)
                .font(Font.custom("SF Pro", size: 17))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.greenMain)
        .cornerRadius(12)
    }
}
