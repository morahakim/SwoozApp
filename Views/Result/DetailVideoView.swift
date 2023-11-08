//
//  DetailVideoView.swift
//  ascenttt
//
//  Created by mora hakim on 07/11/23.
//

import SwiftUI

struct DetailVideoView: View {
    var body: some View {
        ZStack {
            Color.greenMain.ignoresSafeArea(.container, edges: .top)
            VStack(spacing: 15) {
                ZStack(alignment: .bottomTrailing) {
                    Rectangle()
                        .frame(width: 358, height: 173)
                        .cornerRadius(8)
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.greenMain)
                            .font(.system(size: 60))
                            .padding()
                    })
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 390, height: 574)
                        .background(.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                        )
                    
                    VStack {
                        HStack {
                            VStack {
                                Text("Low Serve 1")
                                    .font(Font.custom("SF Pro", size: 22))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .foregroundColor(.neutralBlack)
                                Rectangle()
                                    .fill(.redMain)
                                    .cornerRadius(20)
                                    .frame(width: 97, height: 24)
                                    .overlay {
                                        Text("Intermediate")
                                            .font(Font.custom("SF Pro", size: 12))
                                            .foregroundStyle(Color.white)
                                            
                                    }
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            
                            Text("21/12/2023")
                                .font(Font.custom("SF Pro", size: 12))
                                .foregroundStyle(Color.grayStroke6)
                                .padding(.bottom, 30)
                        }
                        .padding(.bottom)
                        
                        VStack(spacing: 25) {
                            HStack {
                                VStack(spacing: 8) {
                                    Text("20")
                                        .font(Font.custom("SF Pro", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Target Shot")
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                                VStack(spacing: 8) {
                                    Text("20")
                                        .font(Font.custom("SF Pro", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Total Shot")
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                            }
                            .padding(.trailing, 90)
                            
                            HStack {
                                VStack(spacing: 8) {
                                    Text("15")
                                        .font(Font.custom("SF Pro", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Success")
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                                VStack(spacing: 8) {
                                    Text("5")
                                        .font(Font.custom("SF Pro", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Fail")
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                            }
                            .padding(.trailing, 90)
                            
                            VStack(spacing: 8) {
                                Text("15:06")
                                    .font(Font.custom("SF Pro", size: 34))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .foregroundColor(.neutralBlack)
                                Text("Duration")
                                    .font(Font.custom("SF Pro", size: 17))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .foregroundColor(.neutralBlack)
                                ThickDivider(thickness: 1, color: .gray)
                                TextAlignLeading("Your shot is successful on attempts to:")
                                    .font(Font.custom("SF Pro", size: 15))
                                    .foregroundColor(.grayStroke6)
                            }
                            Spacer()
                        }
                    }
                    .padding(.top)
                    .padding()
                }
            }
            .padding(.top, getSafeArea().top + 26)
        }
    }
}

struct ThickDivider: View {
    var thickness: CGFloat
    var color: Color

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
    }
}

#Preview {
    DetailVideoView()
}
