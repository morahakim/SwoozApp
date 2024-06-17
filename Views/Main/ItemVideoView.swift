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
    let hitPerfect: Int16?
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
                Text(name ?? "Low Serve")
                    .font(Font.custom("Urbanist-Medium", size: 22))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .lineLimit(1)
                    .truncationMode(.tail)

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

                    Text("\(hitPerfect ?? 0)")
                        .font(
                            Font.custom("Urbanist", size: 17)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))

                    Circle()
                        .foregroundStyle(Color(red: 0.86, green: 0.79, blue: 0.15))
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

                Text(level == "0" ? chooseLevelTextOne : chooseLevelTextTwo)
                    .font(Font.custom("SF Pro", size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Text(dateFormat(date) == "" ? "-/-/-" : dateFormat(date))
                    .font(Font.custom("SF Pro", size: 12))
                    .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}
