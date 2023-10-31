//
//  Text.swift
//  Swooz
//
//  Created by Agung Saputra on 28/10/23.
//

import SwiftUI

struct TextAlignLeading: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
        }
    }
}

struct TextAlignTrailing: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
        }
    }
}
