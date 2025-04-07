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
    @Binding var selectedTab: Int 
    
    @FetchRequest var activityList: FetchedResults<RecordSkill>
    
    init(selectedTab: Binding<Int>) {
        _selectedTab = selectedTab
        
        _activityList = FetchRequest(
            sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
            predicate: ItemActivityView.predicate(for: selectedTab.wrappedValue)
        )
    }
    
    static func predicate(for tab: Int) -> NSPredicate {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        
        switch tab {
        case 0: // Weekly
            var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
            components.weekday = 2
            let startOfWeek = calendar.date(from: components) ?? today
            let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
            return NSPredicate(format: "datetime >= %@ AND datetime < %@", startOfWeek as NSDate, startOfTomorrow as NSDate)
            
        case 1: // Monthly
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) ?? today
            let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
            return NSPredicate(format: "datetime >= %@ AND datetime < %@", startOfMonth as NSDate, startOfTomorrow as NSDate)
            
        case 2: // Yearly
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today)) ?? today
            let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
            return NSPredicate(format: "datetime >= %@ AND datetime < %@", startOfYear as NSDate, startOfTomorrow as NSDate)
            
        default:
            return NSPredicate(value: true)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(activityList) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                Text(dateFormat(item.datetime) == "" ? "-/-/-" : dateFormat(item.datetime))
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.type ?? "Serve")
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            VideoThumbnailView(url: URL(string: item.url!))
                                .foregroundColor(.greenBasicMain)
                                .opacity(0.8)
                                .frame(width: 50, height: 50)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .cornerRadius(5)
                        }
                        HStack {
                            VStack(alignment: .trailing) {
                                Text(item.duration ?? "30:00")
                                    .font(.title3)
                                Text("Duration")
                                    .font(.callout)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(item.caloriesBurned, specifier: "%.01f")")
                                    .font(.title3)
                                Text("Total Cal")
                                    .font(.callout)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(Int(item.avgHeartRate))")
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

//
//#Preview {
//    ItemActivityView()
//}
