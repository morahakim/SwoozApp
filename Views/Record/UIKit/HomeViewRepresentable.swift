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
    var vm: HomeViewModel

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
        Coordinator(moc: moc, vm: vm)
    }

    class Coordinator: NSObject, HomeDelegate {
        var moc: NSManagedObjectContext
        var vm: HomeViewModel

        func back() {
            vm.popToRoot()
        }

        func saveRecord(
            url: URL,
            duration: String,
            hitFail: Int,
            hitPerfect: Int,
            hitSuccess: Int,
            hitTarget: Int,
            hitTotal: Int,
            level: String,
            result: String,
            minDistance: Double,
            avgDistance: Double,
            variance: String
        ) {
            let data = RecordSkill(context: moc)
            data.datetime = Date()
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
            data.minDistance = minDistance
            data.avgDistance = avgDistance
            data.variance = variance
            try? moc.save()
        }

        init(moc: NSManagedObjectContext, vm: HomeViewModel) {
            self.moc = moc
            self.vm = vm
        }
    }
}
