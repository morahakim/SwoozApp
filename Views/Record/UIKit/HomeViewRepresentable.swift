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
    var viewModel: HomeViewModel

    @AppStorage("name") var name: String = "Intermediate"

    func makeUIViewController(context: Context) -> some UIViewController {
        let homeViewController = HomeViewController()
        homeViewController.homeDelegate = context.coordinator
        return homeViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(moc: moc, viewModel: viewModel)
    }

    class Coordinator: NSObject, HomeDelegate {
        var moc: NSManagedObjectContext
        var viewModel: HomeViewModel

        func back() {
            viewModel.popToRoot()
        }

        func saveRecord(
            recordData: RecordData
        ) {
            let data = RecordSkill(context: moc)
            data.datetime = Date()
            data.duration = recordData.duration
            data.hitFail = Int16(recordData.hitFail)
            data.hitPerfect = Int16(recordData.hitPerfect)
            data.hitSuccess = Int16(recordData.hitSuccess)
            data.hitTarget = Int16(recordData.hitTarget)
            data.hitTotal = Int16(recordData.hitTotal)
            data.id = UUID()
            data.level = recordData.level
            data.result = recordData.result
            data.type = "Low Serve"
            data.url = recordData.url.absoluteString
            data.minDistance = recordData.minDistance
            data.avgDistance = recordData.avgDistance
            data.variance = recordData.variance
            try? moc.save()
        }

        init(moc: NSManagedObjectContext, viewModel: HomeViewModel) {
            self.moc = moc
            self.viewModel = viewModel
        }
    }
}
