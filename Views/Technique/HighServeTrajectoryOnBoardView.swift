//
//  HighServeTrajectoryOnBoardView.swift
//  ascenttt
//
//  Created by mora hakim on 09/06/24.
//

import SwiftUI

struct TechniqueServeData: Hashable {
    let id: Int
    let name: String
    let desc: String
    let img: String
    let isLock: Bool
}

struct HighServeTrajectoryOnBoardView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @AppStorage("techniqueId") var techniqueId: Int = 0
    @AppStorage("techniqueName") var techniqueName: String = ""

    private let data = [
        TechniqueLevelData(id: 0, name: chooseLevelTextThree, desc: chooseLevelTextThree, img: "HighServe-Trajectory", isLock: false)
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
                                    print("this is trajectory page")
                                }
                                techniqueId = index.id
                                techniqueName = index.name
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
                            }
                        })
                    }
                    .padding(.bottom)

                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.white)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 20,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 20
                                )
                            )

                        VStack(spacing: 12) {
                            Image("Smash")
                                .resizable()
                                .frame(width: 300, height: 306)
                                .padding()
                            Text(highServeText)
                                .padding(.bottom)
                                .font(Font.custom("Urbanist", size: 12))
                                .fontWeight(.bold)
                        }
                        .font(Font.custom("SF Pro", size: 15))
                        .padding(.bottom, getSafeArea().bottom + 88)

                        VStack {
                            Spacer()
                            VStack(alignment: .center, spacing: 4) {
                                BtnPrimary(text: buttonHighServeOnBoard) {
                                    vm.path.append(.LowServePlacement)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .padding(.bottom, getSafeArea().bottom + 2)
                            .background(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: -2)
                        }
                        .ignoresSafeArea(.container, edges: .bottom)
                    }
                }
                .scrollDisabled(true)
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.greenMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    HighServeTrajectoryOnBoardView()
}
