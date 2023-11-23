//
//  ItemVideoView.swift
//  ascenttt
//
//  Created by Agung Saputra on 09/11/23.
//

import SwiftUI

struct ItemVideoView: View {
    let url: String?
    let name: String?
    let date: Date?
    let hitTarget: Int16?
    let hitSuccess: Int16?
    let hitFail: Int16?
    let level: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if let urlStr = url {
                VideoThumbnailView(url: URL(string: urlStr))
                    .frame(width: 90, height: 90)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(name ?? "Low Serve")
                        .font(Font.custom("Urbanist-Medium", size: 22))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Text(dateFormat(date) == "" ? "-/-/-" : dateFormat(date))
                        .font(Font.custom("Urbanist-Medium", size: 12))
                        .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Text("\(hitTarget ?? 0)")
                        .font(
                            Font.custom("Urbanist", size: 17)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 1, height: 18)
                        .background(Color(red: 0.54, green: 0.54, blue: 0.56))
                    
                    Circle()
                        .foregroundStyle(Color(red: 0.29, green: 0.83, blue: 0.34))
                        .frame(width: 10, height: 10)
                    
                    Text("\(hitSuccess ?? 0)")
                        .font(
                            Font.custom("Urbanist", size: 17)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    
                    Circle()
                        .foregroundStyle(Color(red: 0.91, green: 0.16, blue: 0.16))
                        .frame(width: 10, height: 10)
                    
                    Text("\(hitFail ?? 0)")
                        .font(
                            Font.custom("Urbanist", size: 17)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                }
                .padding(0)
                
                HStack(alignment: .center, spacing: 4) {
                    Text(level == "0" ? chooseLevelTextOne : chooseLevelTextTwo)
                        .font(Font.custom("SF Pro", size: 11))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .frame(minWidth: 74)
                .background(Color.background(for: level))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}


extension Color {
    static func background(for level: String?) -> Color {
        switch level {
        case "0":
            return Color.redMain.opacity(0.8)
        case "1":
            return Color.greenMain.opacity(0.8)
        default:
            return Color.gray
        }
    }
}

