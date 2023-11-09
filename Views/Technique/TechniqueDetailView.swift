//
//  TechniqueDetailView.swift
//  Swooz
//
//  Created by Agung Saputra on 27/10/23.
//

import SwiftUI

struct TechniqueDetailView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    @State var showRepetitionSheet = false
    @State var selectedRepetition = 0
    
    @AppStorage("name") var name: String = "Intermediate"
    @AppStorage("desc") var desc: String = ""
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack(alignment: .top) {
                Color.greenMain.ignoresSafeArea(.container, edges: .top)
                
                VStack {
                    /** Card animation */
                    CardView(action: {}, content: {
                        VStack {
                            Image(name)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                        HStack {
                            Spacer()
                            Text(name)
                                .font(Font.custom("Urbanist", size: 20).weight(.medium))
                                .foregroundColor(.neutralBlack)
                            Spacer()
                        }
                    })
                    .frame(height: 100)
                    .padding(.bottom, 32)
                    
                    /** Card description */
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: .infinity)
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
                            Rectangle()
                                .frame(width: 358, height: 173)
                                .background(Color.neutralBlack)
                                .cornerRadius(12)
                            
                            TextAlignLeading(desc)
                                .foregroundStyle(.neutralBlack)
                            Divider()
                            VStack(spacing: 2) {
                                HStack {
                                    TextAlignLeading("Clear")
                                    Spacer()
                                    TextAlignLeading("Attempt")
                                }
                                .foregroundStyle(.neutralBlack)
                                HStack {
                                    TextAlignLeading("Successful hits")
                                    Spacer()
                                    TextAlignLeading("Total hit attempts")
                                }
                                .foregroundStyle(.grayStroke6)
                            }
                            VStack(spacing: 2) {
                                HStack {
                                    Circle()
                                        .frame(width: 12)
                                        .foregroundStyle(.success)
                                    Spacer()
                                }
                                TextAlignLeading("The shuttlecock passes over the net")
                                    .foregroundStyle(.grayStroke6)
                            }
                            VStack(spacing: 2) {
                                HStack {
                                    Circle()
                                        .frame(width: 12)
                                        .foregroundStyle(.danger)
                                    Spacer()
                                }
                                TextAlignLeading("The shuttlecock hits the net")
                                    .foregroundStyle(.grayStroke6)
                            }
                            Spacer()
                        }
                        .font(Font.custom("SF Pro", size: 15))
                        .padding(16)
                        
                    }
                }
                .padding(.top, getSafeArea().top)
                
                /** Button record */
                VStack {
                    Spacer()
                    VStack(alignment: .center) {
                        BtnPrimary(text: "Start Recording") {
                            showRepetitionSheet.toggle()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, getSafeArea().bottom - 15)
                    .background(.white)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 12,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 12
                        )
                    )
                    .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: -2)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.greenMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showRepetitionSheet) {
                RepetitionSheet(
                    isPresented: $showRepetitionSheet,
                    selectedRepetition: $selectedRepetition
                )
                .presentationDetents([.fraction(0.4)])
            }
        }
        
    }
}

private struct RepetitionSheet: View {
    @EnvironmentObject var vm: HomeViewModel
    @Binding var isPresented: Bool
    @Binding var selectedRepetition: Int
    
    @AppStorage("hitTarget") var hitTarget: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            TextAlignLeading("Set Repetition")
                .font(Font.custom("SF Pro", size: 20).bold())
                .foregroundColor(.neutralBlack)
                .padding(.top, 18)
                .padding(.horizontal, 16)
            
            Picker("", selection: $selectedRepetition) {
                Text("Unlimited").tag(0)
                Text("5").tag(5)
                Text("10").tag(10)
                Text("15").tag(15)
                Text("20").tag(20)
            }
            .pickerStyle(.wheel)
            .padding(.horizontal, 16)
            
            Divider()
            BtnPrimary(text: "Continue") {
                hitTarget = selectedRepetition
                isPresented.toggle()
                vm.path.append(.RotateToLandscape)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.portrait.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .portrait
        }
    }
}

#Preview {
    TechniqueDetailView()
}
