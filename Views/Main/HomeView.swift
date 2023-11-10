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
    @State var isMove: Bool = false
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            ZStack {
                if list.count > 0 {
                    VStack {
                        List {
                            ForEach(list) { item in
                                NavigationLink(destination: DetailVideoView(item: item)) {
                                    ItemVideoView(url: item.url, name: item.name, date: item.datetime, hitTarget: item.hitTarget, hitSuccess: item.hitSuccess, hitFail: item.hitFail, level: item.level)
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
                    
                        .listStyle(.plain)
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
                        BtnPrimary(text: "Start Recording") {
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
            }
        }
        .environmentObject(vm)
    }
}

#Preview {
    HomeView()
}
