//
//  HomeView.swift
//  Swooz
//
//  Created by Agung Saputra on 21/10/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "datetime", ascending: false)
    ]) var list: FetchedResults<RecordSkill>
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "hitPerfect", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "0")
    ) var trajectoryList: FetchedResults<RecordSkill>
    
    @AppStorage("isDetail") var isDetail = false
    
    @AppStorage("menuStateApp") var menuStateApp = ""
    
    @State var isMoveToDetail = false
    
    
    let contentAnalysisViewController = ContentAnalysisViewController()
    
    var body: some View {
        if isMoveToDetail {
            if list.count > 0 {
                LowServeTrajectoryDetailSingleView(item: list[0], isMoveToDetail: $isMoveToDetail)
                    .onAppear {
                        UIDevice.current.setValue(
                            UIInterfaceOrientation.portrait.rawValue,
                            forKey: "orientation"
                        )
                        AppDelegate.orientationLock = .portrait
                    }.onDisappear {
                        UIDevice.current.setValue(
                            UIInterfaceOrientation.portrait.rawValue,
                            forKey: "orientation"
                        )
                        AppDelegate.orientationLock = .portrait
                    }
            }
        } else {
            NavigationStack(path: $vm.path) {
                ZStack {
                    if list.count > 0 {
                        VStack {
                            if trajectoryList.count > 0 {
                                ZStack {
                                    Image("Challenge")
                                        .resizable()
                                        .frame(height: 190)
                                        .cornerRadius(12)
                                    
                                    VStack(spacing: 10) {
                                        Image("Icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16)
                                        Text(weeklyChallengeText)
                                            .font(Font.custom("SF Pro", size: 20))
                                            .foregroundStyle(Color.white)
                                        VStack {
                                            Text("\(performText) \(trajectoryList[0].hitPerfect) \(goodServe).")
                                                .font(Font.custom("SF Pro", size: 15))
                                                .foregroundStyle(Color.white)
                                            Text(chooseLevelTextOne)
                                                .font(Font.custom("SF Pro", size: 15))
                                                .foregroundStyle(Color.white)
                                        }
                                        .padding(.bottom)
                                        
                                        Button {
                                            vm.path.append(contentsOf: [.Technique, .LowServeTrajectory])
                                        } label: {
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color.greenMain)
                                                    .cornerRadius(10)
                                                    .frame(width: 86, height: 34)
                                                Text(tryAgainText)
                                                    .font(Font.custom("Urbanist", size: 17))
                                                    .foregroundStyle(Color.white)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            List {
                                ForEach(list) { item in
//                                    Text(item.result!)
                                    if item.level == "0" {
                                        NavigationLink(destination: LowServeTrajectoryDetailView(item: item)) {
                                            ItemVideoView(url: item.url, name: item.name, date: item.datetime, hitTarget: item.hitTotal, hitSuccess: item.hitPerfect, hitFail: item.hitFail, level: item.level)
                                        }
                                    } else {
                                        NavigationLink(destination: LowServePlacementDetailView(item: item)) {
                                            ItemVideoView(url: item.url, name: item.name, date: item.datetime, hitTarget: item.hitTotal, hitSuccess: item.hitPerfect, hitFail: item.hitFail, level: item.level)
                                        }
                                    }
                                }
                                .onDelete { i in
                                    let itemToDelete = i.map { list[$0] }
                                    for item in itemToDelete {
                                        moc.delete(item)
                                    }
                                    do {
                                        try moc.save()
                                    } catch  {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            .listStyle(.plain)
                            .padding(.bottom, getSafeArea().bottom + 24)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    EditButton()
                                        .accentColor(.greenMain)
                                }
                            }
                        }
                    } else {
                        VStack {
                            ImgHero(
                                name: "HeroImg",
                                desc: onBoardingDesc
                            )
                            .offset(y: -50)
                        }
                    }
                    
                    VStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 4) {
                            BtnPrimary(text: onBoardingButtonText) {
                                vm.path.append(.Technique)
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
                .navigationTitle(list.count > 0 ? yourRecordingText : welcome)
                .navigationDestination(for: ViewPath.self) { path in
                    HomeViewModel.viewForDestination(path)
                }
                .onAppear {
                    UIDevice.current.setValue(
                        UIInterfaceOrientation.portrait.rawValue,
                        forKey: "orientation"
                    )
                    AppDelegate.orientationLock = .portrait
                    menuStateApp = ""
                    contentAnalysisViewController.counter.menuStateSend(menuState: "")
                    contentAnalysisViewController.counter.typeSend(type: "")
                    contentAnalysisViewController.counter.levelSend(level: "")
                }.onDisappear {
                    UIDevice.current.setValue(
                        UIInterfaceOrientation.portrait.rawValue,
                        forKey: "orientation"
                    )
                    AppDelegate.orientationLock = .portrait
                }
            }
            .preferredColorScheme(.light)
            .environmentObject(vm)
        }
    }
}

#Preview {
    HomeView()
}
