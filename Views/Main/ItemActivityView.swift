//
//  ItemActivityView.swift
//  ascenttt
//
//  Created by Hanifah BN on 14/10/24.
//

import SwiftUI

struct RecentActivity: Identifiable {
    let id = UUID()
    let date: String
    let name: String
    let duration: String
    let calories: String
    let heartRate: String
}

struct ItemActivityView: View {
    let recentActivities: [RecentActivity] = [
        RecentActivity(date: "09/11/2024", name: "Morning Game", duration: "30:00", calories: "725 kcal", heartRate: "90 bpm"),
        RecentActivity(date: "01/11/2024", name: "Low Serve - Placement", duration: "25:00", calories: "612 kcal", heartRate: "120 bpm"),
        RecentActivity(date: "20/05/2024", name: "Morning Game", duration: "30:00", calories: "420 kcal", heartRate: "117 bpm")
    ]
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "datetime", ascending: false)
    ]) var activityList: FetchedResults<RecordSkill>
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                ForEach(activityList) { item in
                    VStack(alignment: .leading) {
                        HStack{
                            VStack{
                                Text(dateFormat(item.datetime) == "" ? "-/-/-" : dateFormat(item.datetime))
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.type ?? "Serve")
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            VideoThumbnailView(url: URL(string: item.url!))
                                .foregroundColor(.greenBasicMain)
                                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                .frame(width: 50, height: 50)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .cornerRadius(5)
                        }
                        HStack {
                            VStack(alignment: .trailing){
                                Text(item.duration ?? "30:00")
                                    .font(.title3)
                                Text("Duration")
                                    .font(.callout)
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("725 kcal")
                                    .font(.title3)
                                Text("AVG Cal")
                                    .font(.callout)
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("90 bpm")
                                    .font(.title3)
                                Text("AVG Heart Rate")
                                    .font(.callout)
                            }
                        }
                        .font(.footnote)
                        Divider()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ItemActivityView()
}
