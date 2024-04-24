//
//  HomeViewModel.swift
//  Swooz
//
//  Created by Agung Saputra on 22/10/23.
//

import SwiftUI

enum ViewPath {
    case rotateToLandscape
    case cameraGuide
    case record
    case loadingRecord
    case rotateToPotrait
    case technique
    case lowServeTrajectory
    case lowServePlacement
}

class HomeViewModel: ObservableObject {
    @Published var path: [ViewPath] = []

    @ViewBuilder
    static func viewForDestination(_ path: ViewPath) -> some View {
        switch path {
        case .rotateToLandscape:
            RotateToLandscapeView()
        case .cameraGuide:
            CameraGuideView()
        case .record:
            RecordView()
        case .loadingRecord:
            LoadingRecordView()
        case .rotateToPotrait:
            RotateToPotraitView()
        case .technique:
            TechniqueView()
        case .lowServeTrajectory:
            LowServeTrajectoryView()
        case .lowServePlacement:
            LowServePlacementView()
        }
    }

    func popToRoot() {
        path = []
    }

    func removeLast() {
        path.removeLast()
    }

    func popToPage(_ page: ViewPath) {
        if let index = path.firstIndex(of: page) {
            path.removeLast(path.count - (index + 1))
        } else {
            print("Value not found in the array")
        }
    }

    func goToPage(_ page: ViewPath) {
        var defaultPath: [ViewPath] = [.cameraGuide, .record]
        if let index = defaultPath.firstIndex(of: page) {
            defaultPath.removeLast(defaultPath.count - (index + 1))
            path = defaultPath
        } else {
            print("Value not found in the array")
        }
    }
}
