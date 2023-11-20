//
//  TechniqueLevelView.swift
//  ascenttt
//
//  Created by Agung Saputra on 07/11/23.
//

import SwiftUI

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
        TechniqueLevelData(id: 0, name: "Low Serve - Trajectory", desc: "Assess the trajectory for consistency and quality, considering its peak.", img: "LowServe-Trajectory", isLock: false),
        TechniqueLevelData(id: 1, name: "Low Serve - Placement", desc: "Assess the placement for quality, considering variations and distance.", img: "Advanced", isLock: false),
        TechniqueLevelData(id: 2, name: "High Serve - Trajectory", desc: "", img: "HighServe-Trajectory", isLock: true)
    ]
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack {
                Color.greenMain.ignoresSafeArea(.all)
                
                ScrollView {
                    ForEach(data, id: \.self) { d in
                        CardView(action: {
                            if !d.isLock {
                                if d.id == 0 {
                                    vm.path.append(.LowServeTrajectory)
                                } else if d.id == 1 {
                                    vm.path.append(.LowServePlacement)
                                }
                                techniqueId = d.id
                                techniqueName = d.name
                            }
                        }, content: {
                            VStack(spacing: 6) {
                                Image(d.img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                HStack {
                                    Text(d.name)
                                        .font(Font.custom("Urbanist", size: 20).weight(.medium))
                                        .foregroundStyle(.neutralBlack)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                if d.isLock {
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16)
                                            .foregroundStyle(.grayStroke6)
                                        Text("Cooming Soon")
                                            .font(Font.custom("SF Pro", size: 17))
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(.grayStroke6)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                } else {
                                    HStack {
                                        Text(d.desc)
                                            .font(Font.custom("SF Pro", size: 15))
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(.grayStroke6)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.bottom, 16)
                        })
                        .overlay {
                            if d.isLock {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.grayStroke3)
                                    .opacity(0.5)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Which drill now?")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.greenMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    TechniqueView()
}
