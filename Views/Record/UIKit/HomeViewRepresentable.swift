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
    
    @AppStorage("name") var name: String = "Intermediate"
    
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
        
        func saveRecord(
            url: URL,
            duration: String,
            hitFail: Int,
            hitPerfect: Int,
            hitSuccess: Int,
            hitTarget: Int,
            hitTotal: Int,
            level: String,
            result: String
        ) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "Y-MM-dd HH:mm:ss"
            let currentDateTime = Date()
            let formattedDate = dateFormatter.string(from: currentDateTime)
            
            let data = Data(context: moc)
            data.datetime = String(formattedDate)
            data.duration = duration
            data.hitFail = Int16(hitFail)
            data.hitPerfect = Int16(hitPerfect)
            data.hitSuccess = Int16(hitSuccess)
            data.hitTarget = Int16(hitTarget)
            data.hitTotal = Int16(hitTotal)
            data.id = UUID()
            data.level = level
            data.result = result
            data.type = "Low Serve"
            data.url = url.absoluteString
            try? moc.save()
        }
        
        init(moc: NSManagedObjectContext) {
            self.moc = moc
        }
    }
}

