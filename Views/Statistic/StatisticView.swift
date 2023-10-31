//
//  StatisticView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct StatisticGameView: View {
    var body: some View {
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 350, height: 81)
                    .shadow(radius: 5)
                    .offset(x: 0, y: -78) // Geser kartu ke atas
                VStack(spacing: 5) {
                    HStack {
                        Image(systemName: SFSymbol.arrowUp)
                            .foregroundColor(.greenMain)
                            .font(.system(size: 34))
                        Text("32")
                            .foregroundColor(.greenMain)
                            .font(.system(size: 34))
                    }
                    
                    VStack {
                        Text("Longest Rally Shot")
                            .foregroundColor(.grayStroke4)
                            .font(.caption2)
                    }
                    .padding(.leading, 110)
                }
                .offset(x:-120, y: -77)
            }
        }
    }
}

struct StatisticView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        HStack {
                            VStack(alignment: .trailing) {
                                HStack {
                                    Image(systemName: SFSymbol.arrowUp)
                                        .foregroundColor(.orangeMain)
                                        .font(.system(size: 34))
                                    Text("77%")
                                        .foregroundColor(.orangeMain)
                                        .font(.system(size: 34))
                                    Spacer()
                                }

                                VStack(spacing: 35) {
                                    VStack(alignment: .leading) {
                                        Text("SMASH")
                                            .font(.caption)
                                        Text("Most Improved")
                                            .foregroundColor(.grayStroke4)
                                            .font(.caption2)
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, 80)

                            Image("BadmintonStatistic")
                        }

                        VStack(alignment: .leading) {
                            Text("Saturday, 07 October 2023")
                                .foregroundColor(.grayStroke6)
                                .font(.caption)
                            Text("17:00")
                                .foregroundColor(.grayStroke6)
                                .font(.caption)
                        }
                        .padding(.top, 100)
                        .padding(.trailing, 194)
                
                    }
                    StatisticGameView()
                    HStack {
                        StatisticSuccessView()
                        StatisticSmashView()
                    }
                    HStack {
                        StatisticForehandView()
                        StatisticBackhandView()
                    }
                    StatisticRallyDurationView()
                    StatisticRallyShotView()
                    
                    Spacer()
                }
            }
            .navigationTitle("Game States")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                
            }, label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.blue)
            }))
        }
    }
}

struct StatisticSuccessView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 170, height: 81)
                .shadow(radius: 5)
                .offset(x: 3, y: -78)
            VStack(spacing: 5) {
                HStack {
                    Image(systemName: SFSymbol.arrowUp)
                        .foregroundColor(.information)
                        .font(.system(size: 34))
                    Text("69%")
                        .foregroundColor(.information)
                        .font(.system(size: 34))
                }
                
                VStack {
                    Text("Success Rate")
                        .foregroundColor(.grayStroke4)
                        .font(.caption2)
                }
                .padding(.leading, 58)
            }
            .offset(x: -11, y: -77)
        }
    }
}

struct StatisticSmashView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 170, height: 81)
                .shadow(radius: 5)
                .offset(x: 4, y: -78)
            VStack(spacing: 5) {
                HStack {
                    Image(systemName: SFSymbol.arrowUp)
                        .foregroundColor(.greenMain)
                        .font(.system(size: 34))
                    Text("77%")
                        .foregroundColor(.greenMain)
                        .font(.system(size: 34))
                }
                
                VStack {
                    Text("Smash")
                        .foregroundColor(.grayStroke4)
                        .font(.caption2)
                }
                .padding(.leading, 30)
            }
            .offset(x:-9, y: -77)
        }
    }
}

struct StatisticForehandView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 170, height: 81)
                .shadow(radius: 5)
                .offset(x: 3, y: -78)
            VStack(spacing: 5) {
                HStack {
                    Image(systemName: SFSymbol.arrowUp)
                        .foregroundColor(.greenMain)
                        .font(.system(size: 34))
                    Text("82%")
                        .foregroundColor(.greenMain)
                        .font(.system(size: 34))
                }
                
                VStack {
                    Text("Success Rate")
                        .foregroundColor(.grayStroke4)
                        .font(.caption2)
                }
                .padding(.leading, 58)
            }
            .offset(x: -11, y: -77)
        }
    }
}

struct StatisticBackhandView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 170, height: 81)
                .shadow(radius: 5)
                .offset(x: 4, y: -78)
            VStack(spacing: 5) {
                HStack {
                    Image(systemName: SFSymbol.arrowUp)
                        .foregroundColor(.redMain)
                        .font(.system(size: 34))
                    Text("57%")
                        .foregroundColor(.redMain)
                        .font(.system(size: 34))
                }
                
                VStack {
                    Text("Backhand")
                        .foregroundColor(.grayStroke4)
                        .font(.caption2)
                }
                .padding(.leading, 30)
            }
            .offset(x:-9, y: -77)
        }
    }
}

struct StatisticRallyDurationView: View {
    var body: some View {
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 350, height: 81)
                    .shadow(radius: 5)
                    .offset(x: 0, y: -78) // Geser kartu ke atas
                VStack(spacing: 5) {
                    HStack {
                        Image(systemName: SFSymbol.arrowUp)
                            .foregroundColor(.greenMain)
                            .font(.system(size: 34))
                        Text("32")
                            .foregroundColor(.greenMain)
                            .font(.system(size: 34))
                    }
                    
                    VStack {
                        Text("Longest Rally Duration")
                            .foregroundColor(.grayStroke4)
                            .font(.caption2)
                    }
                    .padding(.leading, 110)
                }
                .offset(x:-120, y: -77)
            }
        }
    }
}

struct StatisticRallyShotView: View {
    var body: some View {
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 350, height: 81)
                    .shadow(radius: 5)
                    .offset(x: 0, y: -78) // Geser kartu ke atas
                VStack(spacing: 5) {
                    HStack {
                        Image(systemName: SFSymbol.arrowUp)
                            .foregroundColor(.greenMain)
                            .font(.system(size: 34))
                        Text("32")
                            .foregroundColor(.greenMain)
                            .font(.system(size: 34))
                    }
                    
                    VStack {
                        Text("Longest Rally Shot")
                            .foregroundColor(.grayStroke4)
                            .font(.caption2)
                    }
                    .padding(.leading, 110)
                }
                .offset(x:-120, y: -77)
            }
        }
    }
}

#Preview {
    StatisticGameView()
}
