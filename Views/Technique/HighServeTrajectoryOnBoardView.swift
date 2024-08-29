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
                
                let screenHeight = UIScreen.main.bounds.height
                let screenWidth = UIScreen.main.bounds.width
                
                let isSmallScreen = screenHeight <= 568 || screenWidth <= 320

                Group {
                    if isSmallScreen {
                        ScrollView {
                            contentView
                        }
                    } else {
                        contentView
                    }
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.greenMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .scrollIndicators(.hidden)
        }
    }

    var contentView: some View {
        VStack(spacing: 0) {
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
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)

                        HStack {
                            Text(index.name)
                                .font(Font.custom("Urbanist", size: UIScreen.main.bounds.width * 0.05))
                                .foregroundStyle(.neutralBlack)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                })
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 10)

            Spacer()

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
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                        .padding()

                    Text(highServeText)
                        .padding(.bottom)
                        .font(Font.custom("Urbanist", size: UIScreen.main.bounds.width * 0.04))
                        .fontWeight(.bold)
                }
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
    }
}




#Preview {
    HighServeTrajectoryOnBoardView()
}
