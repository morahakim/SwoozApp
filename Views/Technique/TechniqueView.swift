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
    @Environment(\.presentationMode) var presentationMode // For back button action

    private let data = [
        TechniqueLevelData(id: 0, name: chooseLevelTextOne, desc: chooseLevelDescOne, img: "Low Serve - Trajectory", isLock: false),
        TechniqueLevelData(id: 1, name: chooseLevelTextTwo, desc: chooseLevelDescTwo, img: "Low Serve - Placement", isLock: false),
        TechniqueLevelData(id: 2, name: chooseLevelTextThree, desc: "", img: "HighServe-Trajectory", isLock: true)
    ]

    var body: some View {
        ForceOrientation(.portrait) {
            ZStack {
                Color.greenMain.ignoresSafeArea(.all)

                VStack {
                    // custom navigation
                    HStack() {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Go back
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24,weight: .medium))
                                Text("Welcome")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(.leading, 0)

                            }
                            Spacer()
                        }
                    }
                    .padding(.top, 8)
                    .padding(.leading, 8)
                    .background(.greenMain) // Custom background for the nav bar

                    HStack{
                        Text(navigationTitleTechnique)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }.padding(.leading, 16).padding(.top, 8)

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
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    TechniqueView()
}
