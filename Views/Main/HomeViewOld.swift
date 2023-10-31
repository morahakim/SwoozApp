//
//  HomeViewOld.swift
//  Swooz
//
//  Created by Agung Saputra on 21/10/23.
//

import SwiftUI

struct HomeViewOld: View {
    @StateObject var vm = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            VStack {
                ScrollView {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(height: 200)
                        .background(.greenMain)
                        .overlay {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Welcome")
                                        .font(Font.custom("Urbanist", size: 34).weight(.medium))
                                        .foregroundStyle(Color.whiteMain)
                                        .padding(.bottom, 12)
                                    Text("Record your game,\nGet your game stats.")
                                        .font(Font.custom("SF Pro", size: 15))
                                        .foregroundStyle(Color.whiteMain)
                                }
                                Spacer()
                                Image("HeroSmash")
                                    .scaledToFill()
                                    .offset(x: 20)
                            }
                            .padding(16)
                        }
                    HStack {
                        Image(systemName: "calendar")
                        Text("-")
                        Image(systemName: "clock")
                        Text("-")
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    
                    /** game card */
                    CardView(action: {
                        
                    }, content: {
                        Text("Game")
                            .font(Font.custom("SF Pro", size: 22))
                            .foregroundStyle(Color(red: 0.54, green: 0.54, blue: 0.56))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                            Text("Unlock with two recordings.")
                                .font(Font.custom("SF Pro", size: 17))
                        }
                        .foregroundStyle(Color(red: 0.54, green: 0.54, blue: 0.56))
                    })
                    
                    /** shots card */
                    CardView(action: {
                        
                    }, content: {
                        HStack(spacing: 12) {
                            Text("Shots")
                                .font(Font.custom("SF Pro", size: 22))
                                .foregroundStyle(Color(red: 0.54, green: 0.54, blue: 0.56))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Image(systemName: "chevron.right")
                        }
                        HStack(spacing: 18) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("-")
                                    .font(Font.custom("Urbanist", size: 28).weight(.semibold))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("Overall")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                            }
                            .frame(width: 170, alignment: .topLeading)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("-")
                                    .font(Font.custom("Urbanist", size: 28).weight(.semibold))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("Smash")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                            }
                            .frame(width: 170, alignment: .topLeading)
                        }
                        HStack(spacing: 18) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("-")
                                    .font(Font.custom("Urbanist", size: 28).weight(.semibold))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("Forehand")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                            }
                            .frame(width: 170, alignment: .topLeading)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("-")
                                    .font(Font.custom("Urbanist", size: 28).weight(.semibold))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("Backhand")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                            }
                            .frame(width: 170, alignment: .topLeading)
                        }
                    })
                    
                    /** rally crad */
                    CardView(action: {
                        
                    }, content: {
                        HStack(spacing: 12) {
                            Text("Rally")
                                .font(Font.custom("SF Pro", size: 22))
                                .foregroundStyle(Color(red: 0.54, green: 0.54, blue: 0.56))
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Image(systemName: "chevron.right")
                        }
                        HStack(spacing: 18) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("-")
                                    .font(Font.custom("Urbanist", size: 28).weight(.semibold))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("Overall")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                            }
                            .frame(width: 170, alignment: .topLeading)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("-")
                                    .font(Font.custom("Urbanist", size: 28).weight(.semibold))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("Smash")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                            }
                            .frame(width: 170, alignment: .topLeading)
                        }
                    })
                }
                .navigationTitle("SWOOZ")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(.greenMain, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
                VStack(alignment: .center, spacing: 4) {
                    BtnPrimary(text: "Start Recording") {
                        vm.path.append(.RotateToLandscape)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .background(.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: -2)
            }
            .navigationDestination(for: ViewPath.self) { path in
                HomeViewModel.viewForDestination(path)
            }
        }
        .environmentObject(vm)
    }
}

#Preview {
    HomeViewOld()
}
