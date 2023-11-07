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
        SortDescriptor(\.id)
    ]) var list: FetchedResults<Data>
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            ZStack {
                if list.count > 0 {
                    VStack {
                        List {
                            ForEach(list) { item in
                                if let urlStr = item.url {
                                    VideoThumbnailView(
                                        url: URL(string: urlStr)
                                    )
                                }
                            }
                        }
                        .padding(.bottom, getSafeArea().bottom)
                    }
                } else {
                    VStack {
                        ScrollView {
                            ImgHero(
                                name: "Onboarding0",
                                desc: "Enhance Your Shot Consistency and \nShuttlecock Targeting Variation"
                            )
                        }
                    }
                }
                VStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        BtnPrimary(text: "Choose your technique") {
                            vm.path.append(.Technique)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, getSafeArea().bottom)
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: -2)
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .navigationTitle(list.count > 0 ? "Your Recording" : "Welcome")
            .navigationDestination(for: ViewPath.self) { path in
                HomeViewModel.viewForDestination(path)
            }
            .onAppear {
                UIDevice.current.setValue(
                    UIInterfaceOrientation.portrait.rawValue,
                    forKey: "orientation"
                )
                AppDelegate.orientationLock = .portrait
            }.onDisappear {
                AppDelegate.orientationLock = .portrait
            }
        }
        .environmentObject(vm)
    }
}

#Preview {
    HomeView()
}
