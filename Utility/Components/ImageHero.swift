//
//  ImageHero.swift
//  Swooz
//
//  Created by Agung Saputra on 28/10/23.
//

import SwiftUI

struct ImgHero: View {
    var name: String
    var desc: String
    
    var imgHeight: CGFloat {
        if isLandscape {
            return getScreenBound().height * 0.47
        } else {
            return getScreenBound().width * 0.9
        }
    }

    var txtHeight: CGFloat {
        if isLandscape {
            return getScreenBound().width * 0.6
        } else {
            return getScreenBound().width * 0.9
        }
    }

    
    var body: some View {
        VStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(height: imgHeight)
                .padding(.bottom, isLandscape ? 0 : 24)
            
            Text(desc)
                .font(
                    Font.custom("Urbanist", size: isLandscape ? 16 : 20)
                        .weight(.medium)
                )
                .opacity(0.7)
                .multilineTextAlignment(.center)
                .foregroundStyle(.neutralBlack)
                .frame(width: txtHeight)
        }
        .padding(.top, isLandscape ? 16 : 24)
    }
}
