//
//  Card.swift
//  Swooz
//
//  Created by Agung Saputra on 24/10/23.
//

import SwiftUI

struct CardView<Content: View>: View {
    let action: () -> Void
    let content: () -> Content
    
    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8, content: content)
                .padding(12)
                .frame(width: 357, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.9, green: 0.9, blue: 0.9), lineWidth: 1)
                )
        }
    }
}
