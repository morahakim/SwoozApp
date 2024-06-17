//
//  TrajectoryDescriptionView.swift
//  ascenttt
//
//  Created by Hanifah BN on 29/05/24.
//

import SwiftUI
import AVKit
import CoreData

struct LowServeTrajectoryDescriptionView: View {

    @State var tutorial: AVPlayer?
    
    var body: some View {
        ScrollView{
            VStack(spacing: 4) {
                HStack {
                    Circle()
                        .frame(width: 12)
                    Text(goodTextTrajectory)
                        .font(Font.custom("SF Pro", size: 17))
                    Spacer()
                }
                .foregroundStyle(.success)
                TextAlignLeading(goalsGoodTextTrajectory)
                    .foregroundStyle(.neutralBlack)
                TextAlignLeading(descGoodTextTrajectory)
                    .font(Font.custom("SF Pro", size: 12))
                    .foregroundStyle(.grayStroke6)
                    .padding(.bottom, 8)
                Divider()
            }
            .padding(.top, 12)
            .padding(.horizontal, 20)
            
            VStack(spacing: 4) {
                HStack {
                    Circle()
                        .frame(width: 12)
                    Text(riskyTextTrajectory)
                        .font(Font.custom("SF Pro", size: 17))
                    Spacer()
                }
                .foregroundStyle(.warning)
                TextAlignLeading(goalsRiskyTextTrajectory)
                    .foregroundStyle(.neutralBlack)
                TextAlignLeading(descRiskyTextTrajectory)
                    .font(Font.custom("SF Pro", size: 12))
                    .foregroundStyle(.grayStroke6)
                    .padding(.bottom, 8)
                Divider()
            }
            .padding(.top, 12)
            .padding(.horizontal, 20)
            
            VStack(spacing: 4) {
                HStack {
                    Circle()
                        .frame(width: 12)
                    Text(badTextTrajectory)
                        .font(Font.custom("SF Pro", size: 17))
                    Spacer()
                }
                .foregroundStyle(.danger)
                TextAlignLeading(goalsBadTextTrajectory)
                    .foregroundStyle(.neutralBlack)
                TextAlignLeading(descBadTextTrajectory)
                    .font(Font.custom("SF Pro", size: 12))
                    .foregroundStyle(.grayStroke6)
                    .padding(.bottom, 8)
                Divider()
            }
            .padding(.top, 12)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    HStack(alignment: .top, spacing: 4) {
                        Text(tipsText)
                            .font(Font.custom("SF Pro", size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(red: 1, green: 0.69, blue: 0))
                    .cornerRadius(12)
                }
                
                Text(trajectoryTipsText)
                    .font(Font.custom("SF Pro", size: 15))
                    .foregroundStyle(.grayStroke6)
                    .padding(.bottom, 8)
                Divider()
            }
            .padding(.top, 12)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                HStack {
                    HStack(alignment: .top, spacing: 4) {
                        Text("Tutorial")
                            .font(Font.custom("SF Pro", size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.greenMain)
                    .cornerRadius(12)
                }
                
                VideoPlayer(player: tutorial)
                    .frame(width: 358, height: 173)
                    .cornerRadius(12)
                
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, getSafeArea().bottom + 12)
        .onAppear {
            if let url = Bundle.main.url(forResource: "Tutorial", withExtension: "mp4") {
                tutorial = AVPlayer(url: url)
                tutorial?.play()
            }
        }
    }
}
