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
    
    var body: some View {
        VStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 314)
            
            Text(desc)
                .font(Font.custom("SF Pro", size: 16))
                .fontWeight(.medium)
                .opacity(0.7)
                .multilineTextAlignment(.center)
                .foregroundStyle(.neutralBlack)
                .frame(width: getScreenBound().width * 0.8)
                .padding(.top, 64)
        }
    }
}
