//
//  CamerePlacementRepresentable.swift
//  Swooz
//
//  Created by Agung Saputra on 19/10/23.
//

import UIKit
import SwiftUI
import AVFoundation
import CoreData

struct HomeViewRepresentable: UIViewControllerRepresentable {
    var moc: NSManagedObjectContext
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let homeViewController = HomeViewController()
        homeViewController.homeDelegate = context.coordinator
        return homeViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    // TODO: create makeCoordinator
        // TODO: create class coordinator, di kelas ini 
    func makeCoordinator() -> Coordinator {
        Coordinator(moc: moc)
    }
    
    class Coordinator: NSObject, HomeDelegate {   
        var moc: NSManagedObjectContext
        
        func saveRecord(url: URL) {
            let data = Data(context: moc)
            data.id = UUID()
            data.url = url.absoluteString
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "Y-MM-dd HH:mm:ss"
            let currentDateTime = Date()
            let formattedDate = dateFormatter.string(from: currentDateTime)
            data.datetime = String(formattedDate)
            
            data.type = "Low Serve"
            try? moc.save()
        }
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
        }
    }
}

