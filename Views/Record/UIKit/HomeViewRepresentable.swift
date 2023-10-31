//
//  CamerePlacementRepresentable.swift
//  Swooz
//
//  Created by Agung Saputra on 19/10/23.
//

import UIKit
import SwiftUI
import AVFoundation

struct HomeViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
