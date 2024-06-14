//
//  TechniqueLevelView.swift
//  ascenttt
//
//  Created by Agung Saputra on 07/11/23.
//

import SwiftUI
import WebKit

struct TechniqueLevelData: Hashable {
    let id: Int
    let name: String
    let desc: String
    let img: String
    let isLock: Bool
}

struct TechniqueView: View {
    @EnvironmentObject var vm: HomeViewModel
    @AppStorage("techniqueId") var techniqueId: Int = 0
    @AppStorage("techniqueName") var techniqueName: String = ""

    private let data = [
        TechniqueLevelData(id: 0, name: chooseLevelTextOne, desc: chooseLevelDescOne, img: "Low Serve - Trajectory", isLock: false),
        TechniqueLevelData(id: 1, name: chooseLevelTextTwo, desc: chooseLevelDescTwo, img: "Low Serve - Placement", isLock: false),
        TechniqueLevelData(id: 2, name: chooseLevelTextThree, desc: "", img: "HighServe-Trajectory", isLock: true)
    ]

    var body: some View {
        ForceOrientation(.portrait) {
            ZStack {
                Color.greenMain.ignoresSafeArea(.all)

                ScrollView {
                    ForEach(data, id: \.self) { index in
                        CardView(action: {
                            if !index.isLock {
                                if index.id == 0 {
                                    vm.path.append(.LowServeTrajectory)
                                } else if index.id == 1 {
                                    vm.path.append(.LowServePlacement)
                                }
                                techniqueId = index.id
                                techniqueName = index.name
                            } else if index.isLock {
                                if index.id == 2 {
                                    vm.path.append(.HighServeTrajectoryOnBoard)
                                }
                            }
                        }, content: {
                            VStack(spacing: 6) {
                                Image(index.img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                HStack {
                                    Text(index.name)
                                        .font(Font.custom("Urbanist", size: 20).weight(.medium))
                                        .foregroundStyle(.neutralBlack)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                if index.isLock {
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16)
                                            .foregroundStyle(.neutralBlack)
                                        Text(chooseLevelDescThree)
                                            .font(Font.custom("SF Pro", size: 17))
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(.neutralBlack)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.bottom, 16)
                        })
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 10)
            }

            .navigationTitle(navigationTitleTechnique)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.greenMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}


#Preview {
    TechniqueView()
}
