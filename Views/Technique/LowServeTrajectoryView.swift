//
//  TechniqueDetailView.swift
//  Swooz
//
//  Created by Agung Saputra on 27/10/23.
//

import SwiftUI
import AVKit
import CoreData

struct LowServeTrajectoryView: View {
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.managedObjectContext) var moc
    
    @State var showRepetitionSheet = false
    @State var selectedRepetition = 0
    @State var player: AVPlayer?
    @State var tutorial: AVPlayer?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "hitPerfect", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "0")
    ) var recordOfAllTime: FetchedResults<RecordSkill>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "0")
    ) var latestDrill: FetchedResults<RecordSkill>
    
    @State var recordOfTheMonth: [RecordSkill] = []
    @State var lowestOfTheMonth: [RecordSkill] = []
    @State var bestAvgOfTheMonth: [RecordSkill] = []
    
    var fixed: Bool = true
    var tabs: [Tab] = [
        Tab(title: "Description"),
        Tab(title: "Drill Summary")
    ]
    var geoWidth: CGFloat = 375
    @State var selectedTab: Int = 0
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack(alignment: .top) {
                Color.greenMain.ignoresSafeArea(.all)
                
                VStack {
                    /** Card animation */
                    CardPlainView {
                        ZStack {
                           GifImage("Low Serve - Lintasan")
                                .frame(height: 150)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(chooseLevelTextOne)
                                        .font(Font.custom("Urbanist", size: 20).weight(.medium))
                                        .foregroundColor(.neutralBlack)
                                    Spacer()
                                }
                            }
                        }
                    }
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
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    ForEach(0 ..< tabs.count, id: \.self) { row in
                                        Button(action: {
                                            withAnimation {
                                                selectedTab = row
                                            }
                                        }, label: {
                                            VStack(spacing: 0) {
                                                HStack {
                                                    Text(tabs[row].title)
                                                        .font(Font.system(size: 17, weight: .semibold))
                                                        .foregroundColor(selectedTab == row ? Color("GreenMain") : Color("GrayStroke3"))
                                                        .padding(EdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 15))
                                                }
                                                .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .none, height: 40)
                                                Rectangle().fill(selectedTab == row ? Color("GreenMain") : Color.clear)
                                                    .frame(height: 3)
                                            }.fixedSize()
                                        })
                                            .accentColor(Color.white)
                                            .buttonStyle(PlainButtonStyle())
                                    }
                                }
//                                .onChange(of: selectedTab) { target in
//                                    withAnimation {
//                                        proxy.scrollTo(target)
//                                    }
//                                }
                                if selectedTab == 0 {
                                    LowServeTrajectoryDescriptionView()
                                } else if selectedTab == 1 {
                                    LowServeTrajectorySummaryView()
                                }
                            }
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
                        BtnPrimary(text: buttonRecordText) {
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
                if let url = Bundle.main.url(forResource: "ServeTrajectory", withExtension: "mp4") {
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
            TextAlignLeading(repetitionText)
                .font(Font.custom("SF Pro", size: 20).bold())
                .foregroundColor(.neutralBlack)
                .padding(.top, 18)
                .padding(.horizontal, 16)
            
            Picker("", selection: $selectedRepetition) {
                Text(unlimitedText).tag(0)
                Text("5").tag(5)
                Text("10").tag(10)
                Text("15").tag(15)
                Text("20").tag(20)
            }
            .pickerStyle(.wheel)
            .padding(.horizontal, 16)
            
            Divider()
            BtnPrimary(text: continueText) {
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
