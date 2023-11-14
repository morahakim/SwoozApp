//
//  TechniqueDetailView.swift
//  Swooz
//
//  Created by Agung Saputra on 27/10/23.
//

import SwiftUI
import AVKit

struct TechniqueDetailView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    @State var showRepetitionSheet = false
    @State var selectedRepetition = 0
    @State var player: AVPlayer?
    
    @AppStorage("name") var name: String = "Intermediate"
    @AppStorage("desc") var desc: String = ""
    @AppStorage("video") var video: String = ""
    @AppStorage("isLock") var isLock: Bool = true
    @AppStorage("greenPoint") var greenPoint: String = ""
    @AppStorage("redPoint") var redPoint: String = ""
    
    let playerViewController = AVPlayerViewController()
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack(alignment: .top) {
                Color.greenMain.ignoresSafeArea(.container, edges: .top)
                
                VStack {
                    /** Card animation */
                    CardView(action: {}, content: {
                        ZStack {
                            LottieView(name: "LowServe\(name)")
                                .frame(height: 150)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(name)
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
                            
                            if !isLock {
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
                                    TextAlignLeading(greenPoint)
                                        .foregroundStyle(.grayStroke6)
                                }
                                VStack(spacing: 2) {
                                    HStack {
                                        Circle()
                                            .frame(width: 12)
                                            .foregroundStyle(.danger)
                                        Spacer()
                                    }
                                    TextAlignLeading(redPoint)
                                        .foregroundStyle(.grayStroke6)
                                }
                            } else {
                                VStack(spacing: 20) {
                                    Image("Forehand Exercise")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 144, height: 152)
                                    
                                    Text("\"Unlock this with over 50% success in the intermediate level”")
                                        .font(Font.custom("SF Pro", size: 15))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                                        .frame(width: 253, alignment: .top)
                                }
                                .padding(.top, 12)
                            }
                            Spacer()
                        }
                        .font(Font.custom("SF Pro", size: 15))
                        .padding(16)
                        
                    }
                }
                .padding(.top, getSafeArea().top - 24)
                
                /** Button record */
                VStack {
                    Spacer()
                    VStack(alignment: .center) {
                        if !isLock {
                            BtnPrimary(text: "Start Recording") {
                                showRepetitionSheet.toggle()
                            }
                        } else {
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 24)
                                    .foregroundStyle(.grayStroke6.opacity(0.3))
                                Text("Locked")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.3))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(red: 0.46, green: 0.46, blue: 0.5).opacity(0.12))
                            .cornerRadius(12)
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
            .onAppear {
                
                if let url = Bundle.main.url(forResource: video, withExtension: "mov") {
                    player = AVPlayer(url: url)
                    player?.play()
                }
            }
            
            
        }
        .onDisappear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight
            player?.pause()
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
    TechniqueDetailView()
}
