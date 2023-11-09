//
//  TechniqueLevelView.swift
//  ascenttt
//
//  Created by Agung Saputra on 07/11/23.
//

import SwiftUI

struct TechniqueLevelData: Hashable {
    let name: String
    let desc: String
    let img: String
    let isLock: Bool
}

struct TechniqueLevelView: View {
    @EnvironmentObject var vm: HomeViewModel
    @AppStorage("name") var name: String = ""
    @AppStorage("desc") var desc: String = ""
    
    private let data = [
        TechniqueLevelData(name: "Intermediate", desc: "SWOOZ will calculate the success of the shuttlecock passing the net. You can also see the consistency of your shot with the visual of the shuttlecock trajectory that SWOOZ provides.", img: "Intermediate", isLock: false),
        TechniqueLevelData(name: "Experienced", desc: "A good shuttlecock trajectory on a low serve is when the peak is before crossing the net. SWOOZ helps you visualize it and calculate your success in doing it.", img: "Experienced", isLock: false),
        TechniqueLevelData(name: "Advanced", desc: "A good shuttlecock placement on a low serve is when the shuttlecock is close to the line and there are variations in placement. Swooz helps you mark the shuttlecock's fall with precision.", img: "Advanced", isLock: false)
    ]
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack {
                Color.greenMain.ignoresSafeArea(.all)
                
                ScrollView {
                    ForEach(data, id: \.self) { d in
                        CardView(action: {
                            if !d.isLock {
                                name = d.name
                                desc = d.desc
                                vm.path.append(.TechniqueDetail)
                            }
                        }, content: {
                            VStack {
                                Image(d.img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                HStack {
                                    Spacer()
                                    Text(d.name)
                                        .font(Font.custom("Urbanist", size: 20).weight(.medium))
                                        .foregroundColor(.neutralBlack)
                                    Spacer()
                                }
                            }
                            .padding(.bottom, 16)
                            .overlay {
                                if d.isLock {
                                    VStack {
                                        HStack {
                                            Image(systemName: "lock.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 24)
                                                .foregroundStyle(.grayStroke6)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .padding(.leading, 4)
                                    .padding(.top, 2)
                                }
                            }
                        })
                        .overlay {
                            if d.isLock {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.grayStroke3)
                                    .opacity(0.4)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Choose Level")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.greenMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    TechniqueLevelView()
}
