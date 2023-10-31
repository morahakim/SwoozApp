//
//  ResultView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct ResultView: View {
    @AppStorage("path") var path: Path = .Home
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 39, height: 39)
                        .background(
                            Image("Shuttlecock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        )
                    Text("Your Last Recording")
                        .font(Font.custom("SF Pro", size: 12))
                        .padding(.top, 2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                }
                Spacer()
                
                VStack(spacing: 38) {
                    VStack {
                        Text("17:00")
                            .font(
                                Font.custom("Urbanist", size: 34)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.13, green: 0.75, blue: 0.45))
                        Text("Record Duration")
                            .font(Font.custom("SF Pro", size: 17))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.73, green: 0.73, blue: 0.73))
                    }
                    VStack {
                        Text("70%")
                            .font(
                                Font.custom("Urbanist", size: 34)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.13, green: 0.75, blue: 0.45))
                        Text("Success Rate")
                            .font(Font.custom("SF Pro", size: 17))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.73, green: 0.73, blue: 0.73))
                    }
                    VStack {
                        Text("01:30")
                            .font(
                                Font.custom("Urbanist", size: 34)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.13, green: 0.75, blue: 0.45))
                        Text("Longest Rally Duration")
                            .font(Font.custom("SF Pro", size: 17))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.73, green: 0.73, blue: 0.73))
                    }
                    VStack {
                        Text("32")
                            .font(
                                Font.custom("Urbanist", size: 34)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.13, green: 0.75, blue: 0.45))
                        Text("Longest Rally Shot")
                            .font(Font.custom("SF Pro", size: 17))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.73, green: 0.73, blue: 0.73))
                    }
                }
                
                Spacer()
                Button {
                    path = .Recording
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Start Recording")
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .frame(maxWidth: 146, alignment: .center)
                    .background(Color(red: 0.13, green: 0.75, blue: 0.45))
                    .cornerRadius(40)
                }
            }
            .navigationTitle("Record")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.bottom, 24)
            .padding(.top, 48)
        }
    }
}

#Preview {
    ResultView()
}
