//
//  SheetShare.swift
//  Swooz
//
//  Created by Agung Saputra on 28/10/23.
//

import SwiftUI

struct SheetShare: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let view = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
