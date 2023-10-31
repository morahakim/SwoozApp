//
//  HomeView.swift
//  Swooz
//
//  Created by Agung Saputra on 21/10/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    let contentAnalysisViewController = ContentAnalysisViewController()
    var body: some View {
        NavigationStack(path: $vm.path) {
            ZStack {
                HomeContentView(vm: vm)
            }
            .navigationDestination(for: ViewPath.self) { path in
                HomeViewModel.viewForDestination(path)
            }
        }
        .environmentObject(vm)
        .onAppear{
            contentAnalysisViewController.counter.menuStateSend(menuState: "")
        }
    }
}

private struct HomeContentView: View {
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                ImgHero(
                    name: "Onboarding0",
                    desc: "Tingkatkan konsistensi pukulan dan \nakurasi placement shuttlecockmu di sini"
                )
            }
            .padding(.horizontal, 16)
            .navigationTitle("Welcome")
            
            VStack(alignment: .center, spacing: 4) {
                BtnPrimary(text: "Choose your technique") {
                    vm.path.append(.Technique)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .background(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: -2)
        }
    }
}

#Preview {
    HomeView()
}
