//
//  TechniqueView.swift
//  Swooz
//
//  Created by Agung Saputra on 27/10/23.
//

import SwiftUI

private struct TechniqueData: Hashable {
    let name: String
    let img: String
    let isLock: Bool
}

struct TechniqueView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    private let data = [
        TechniqueData(name: "Low Serve", img: "LowServe", isLock: false),
        TechniqueData(name: "High Serve", img: "HighServe", isLock: true),
        TechniqueData(name: "Drive", img: "Drive", isLock: true),
        TechniqueData(name: "Clear Shot", img: "ClearShot", isLock: true),
        TechniqueData(name: "Drop Shot", img: "DropShot", isLock: true),
        TechniqueData(name: "Smash", img: "Smash", isLock: true)
    ]
    
    var body: some View {
        ZStack {
            Color.greenMain.ignoresSafeArea(.all)
            
            ScrollView {
                ForEach(data, id: \.self) { d in
                    CardView(action: {
                        if !d.isLock {
                            vm.path.append(.TechniqueDetail)
                        }
                    }, content: {
                        VStack {
                            Image(d.img)
                                .resizable()
                                .scaledToFit()
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
        .navigationTitle("Choose Technique")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.greenMain, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    TechniqueView()
}
