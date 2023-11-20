//
//  HomeViewModel.swift
//  Swooz
//
//  Created by Agung Saputra on 22/10/23.
//

import SwiftUI

enum ViewPath {
    case RotateToLandscape
    case CameraGuide
    case Record
    case LoadingRecord
    case RotateToPotrait
    case Technique
    case LowServeTrajectory
    case LowServePlacement
}

class HomeViewModel: ObservableObject {
    @Published var path: [ViewPath] = []
    
    @ViewBuilder
    static func viewForDestination(_ path: ViewPath) -> some View {
        switch path {
        case .RotateToLandscape:
            RotateToLandscapeView()
        case .CameraGuide:
            CameraGuideView()
        case .Record:
            RecordView()
        case .LoadingRecord:
            LoadingRecordView()
        case .RotateToPotrait:
            RotateToPotraitView()
        case .Technique:
            TechniqueView()
        case .LowServeTrajectory:
            LowServeTrajectoryView()
        case .LowServePlacement:
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
        var defaultPath: [ViewPath] = [.CameraGuide, .Record]
        if let index = defaultPath.firstIndex(of: page) {
            defaultPath.removeLast(defaultPath.count - (index + 1))
            path = defaultPath
        } else {
            print("Value not found in the array")
        }
    }
}
