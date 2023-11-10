//
//  DetailVideoView.swift
//  ascenttt
//
//  Created by mora hakim on 07/11/23.
//

import SwiftUI
import AVKit

struct DetailVideoView: View {
    var item: FetchedResults<Data>.Element
    @State var isPlay: Bool = false
    @State var player: AVPlayer?
    @State private var isPresenting = false
    
    var body: some View {
        ZStack {
            Color.greenMain.ignoresSafeArea(.container, edges: .top)
            VStack(spacing: 15) {
               
                    if item.url != nil {
                        VideoPlayer(player: player) {
                            if !isPlay {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.greenMain)
                                    .font(.system(size: 60))
                                    .padding()
                                    .onTapGesture {
                                        player?.play()
                                        isPlay.toggle()
                                    }
                            }
                        }
                        .frame(width: 358, height: 173)
                        .cornerRadius(0.5)
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
                                Text(item.name ?? "Low Serve")
                                    .font(Font.custom("SF Pro", size: 22))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .foregroundColor(.neutralBlack)
                                Rectangle()
                                    .fill(.redMain)
                                    .cornerRadius(20)
                                    .frame(width: 97, height: 24)
                                    .overlay {
                                        Text(item.level ?? "-")
                                            .font(Font.custom("SF Pro", size: 12))
                                            .foregroundStyle(Color.white)
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            
                            Text(item.datetime ?? "-/-/-")
                                .font(Font.custom("SF Pro", size: 12))
                                .foregroundStyle(Color.grayStroke6)
                                .padding(.bottom, 30)
                        }
                        .padding(.bottom)
                        
                        VStack(spacing: 25) {
                            HStack {
                                VStack(spacing: 8) {
                                    Text("\(item.hitTarget )")
                                        .font(Font.custom("SF Pro", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Target Shot")
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                                VStack(spacing: 8) {
                                    Text("\(item.hitTotal )")
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
                                    Text("\(item.hitSuccess)")
                                        .font(Font.custom("SF Pro", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Success")
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                                VStack(spacing: 8) {
                                    Text("\(item.hitFail)")
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
                                Text(item.duration ?? "00:00")
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.greenMain, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            if let url = item.url {
                player = AVPlayer(url: URL(string: url)!)
            }
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




