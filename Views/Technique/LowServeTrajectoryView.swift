//
//  TechniqueDetailView.swift
//  Swooz
//
//  Created by Agung Saputra on 27/10/23.
//

import SwiftUI
import AVKit

struct LowServeTrajectoryView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    @State var showRepetitionSheet = false
    @State var selectedRepetition = 0
    @State var player: AVPlayer?
    
    let playerViewController = AVPlayerViewController()
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack(alignment: .top) {
                Color.greenMain.ignoresSafeArea(.all)
                
                VStack {
                    /** Card animation */
                    CardView(action: {}, content: {
                        ZStack {
                            LottieView(name: "LowServeIntermediate")
                                .frame(height: 150)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("Low Serve - Trajetory")
                                        .font(Font.custom("Urbanist", size: 20).weight(.medium))
                                        .foregroundColor(.neutralBlack)
                                    Spacer()
                                }
                            }
                        }
                    })
                    .frame(height: 150)
                    .padding(.bottom, 16)
                    
                    /** Card description */
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
                            VideoPlayer(player: player)
                                .frame(width: 358, height: 173)
                                .cornerRadius(12)

                            ScrollView {
                                VStack(spacing: 4) {
                                    HStack {
                                        Circle()
                                            .frame(width: 12)
                                        Text("Good")
                                            .font(Font.custom("SF Pro", size: 17))
                                        Spacer()
                                    }
                                    .foregroundStyle(.success)
                                    TextAlignLeading("The peak before the net.")
                                        .foregroundStyle(.neutralBlack)
                                    TextAlignLeading("To reduce the risk, your service is not easily countered.")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundStyle(.grayStroke6)
                                        .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                VStack(spacing: 4) {
                                    HStack {
                                        Circle()
                                            .frame(width: 12)
                                        Text("Risky")
                                            .font(Font.custom("SF Pro", size: 17))
                                        Spacer()
                                    }
                                    .foregroundStyle(.warning)
                                    TextAlignLeading("The peak after the net.")
                                        .foregroundStyle(.neutralBlack)
                                    TextAlignLeading("Your service succeeds but is still easily countered.")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundStyle(.grayStroke6)
                                        .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                VStack(spacing: 4) {
                                    HStack {
                                        Circle()
                                            .frame(width: 12)
                                        Text("Missed")
                                            .font(Font.custom("SF Pro", size: 17))
                                        Spacer()
                                    }
                                    .foregroundStyle(.danger)
                                    TextAlignLeading("The shuttlecock hits the net.")
                                        .foregroundStyle(.neutralBlack)
                                    TextAlignLeading("Your service fails.")
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundStyle(.grayStroke6)
                                        .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        HStack(alignment: .top, spacing: 4) {
                                            Text("Tips")
                                                .font(Font.custom("SF Pro", size: 17))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(red: 1, green: 0.69, blue: 0))
                                        .cornerRadius(12)
                                    }
                                    
                                    Text("Make sure the shuttlecock barely goes over the net at the top.")
                                      .font(Font.custom("SF Pro", size: 15))
                                      .foregroundStyle(.grayStroke6)
                                      .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                CardView(action: {}, content: {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Low Serve - Trajectory")
                                          .font(Font.custom("SF Pro", size: 16))
                                        
                                        VStack(spacing: 2) {
                                            HStack {
                                                TextAlignLeading("20")
                                                Spacer()
                                                TextAlignLeading("10")
                                            }
                                            .fontWeight(.medium)
                                            .font(Font.custom("Urbanist", size: 20))
                                            
                                            HStack {
                                                TextAlignLeading("Record of All Time")
                                                Spacer()
                                                TextAlignLeading("Record of The Month")
                                            }
                                            .font(Font.custom("SF Pro", size: 12))
                                        }
                                        
                                        VStack(spacing: 2) {
                                            HStack {
                                                TextAlignLeading("8")
                                                Spacer()
                                                TextAlignLeading("9")
                                            }
                                            .fontWeight(.medium)
                                            .font(Font.custom("Urbanist", size: 20))
                                            
                                            HStack {
                                                TextAlignLeading("Latest Drill")
                                                Spacer()
                                                TextAlignLeading("Average of This Month")
                                            }
                                            .font(Font.custom("SF Pro", size: 12))
                                        }
                                    }
                                    .foregroundStyle(.success)
                                    
                                })
                                .frame(height: 150)
                                .padding(.bottom, 16)
                            }
                            .scrollIndicators(.hidden)
                            .padding(.bottom, getSafeArea().bottom + 12)
                        }
                        .font(Font.custom("SF Pro", size: 15))
                        .padding(16)
                        
                    }
                }
                .padding(.top, getSafeArea().top - 24)
                
                /** Button record */
                VStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        BtnPrimary(text: "Start Recording") {
                            showRepetitionSheet.toggle()
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
            .onAppear {
                if let url = Bundle.main.url(forResource: "Level 1", withExtension: "mov") {
                    player = AVPlayer(url: url)
                    player?.play()
                }
            }
            
            
        }
        .onDisappear {
            if vm.path.last == .Record {
                UIDevice.current.setValue(
                    UIInterfaceOrientation.portrait.rawValue,
                    forKey: "orientation"
                )
                AppDelegate.orientationLock = .portrait
                player?.pause()
            } else if vm.path.last == .RotateToLandscape {
                UIDevice.current.setValue(
                    UIInterfaceOrientation.landscapeRight.rawValue,
                    forKey: "orientation"
                )
                AppDelegate.orientationLock = .landscapeRight
                player?.pause()
            }
        }
    }
}

private struct RepetitionSheet: View {
    @EnvironmentObject var vm: HomeViewModel
    @Binding var isPresented: Bool
    @Binding var selectedRepetition: Int
    
    @AppStorage("hitTargetApp") var hitTargetApp: Int = 0
    
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
                hitTargetApp = selectedRepetition
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
        .onDisappear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight
        }
    }
}

#Preview {
    LowServeTrajectoryView()
}
