//  ItemActivityView.swift
//  ascenttt
//
//  Created by Hanifah BN on 14/10/24.
//

import SwiftUI
import Charts
import CoreData

struct ActivityData: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
}

struct ActivityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showWeekSelection = false
    @State private var selectedDate = Date()
    @State private var selectedTab = 0
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: RecordSkill.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \RecordSkill.datetime, ascending: true)],
        predicate: nil
    ) private var allRecords: FetchedResults<RecordSkill>
    
    private var predicateForSelectedTab: NSPredicate {
            let calendar = Calendar(identifier: .gregorian)
            let today = calendar.startOfDay(for: Date())
            
            switch selectedTab {
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
        VStack {
            Picker(selection: $selectedTab, label: Text("")) {
                Text("Week").tag(0)
                Text("Month").tag(1)
                Text("Year").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing])
            
            if selectedTab == 0 {
                WeeklyChartView(weeklyData: getWeeklyData(from: allRecords), showWeekSelection: $showWeekSelection)
            } else if selectedTab == 1 {
                MonthlyChartView(monthlyData: getMonthlyDataRaw(from: allRecords))
            } else if selectedTab == 2 {
                YearlyChartView(yearlyData: getYearlyData(from: allRecords))
            }
            
            Text("Recent Activities")
                .font(.title2)
                .padding(.leading)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ItemActivityView(selectedTab: $selectedTab)

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .navigationTitle("Activities")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.greenMain)
                }
            }
        }
        .sheet(isPresented: $showWeekSelection) {
            WeekSelectionView(selectedDate: $selectedDate)
                .presentationDetents([.fraction(0.5)])
        }
    }
}



#Preview {
    ActivityView()
}
