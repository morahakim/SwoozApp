//
//  YearlyChartView.swift
//  ascenttt
//
//  Created by Hanifah BN on 24/01/25.
//

import SwiftUI
import Charts
import CoreData

func getYearlyData(from records: FetchedResults<RecordSkill>) -> [ActivityData] {
    let calendar = Calendar(identifier: .gregorian)
    let today = Date()
    let currentYear = calendar.component(.year, from: today)
    
    let groupedByMonth = Dictionary(grouping: records) { record in
        let date = record.datetime ?? Date()
        return calendar.component(.month, from: date)
    }
    
    var yearlyData: [ActivityData] = []
    for month in 1...12 {
        let recordsForMonth = groupedByMonth[month] ?? []
        let dailyCalories = Dictionary(grouping: recordsForMonth) { record in
            calendar.startOfDay(for: record.datetime ?? Date())
        }.mapValues { dailyRecords in
            dailyRecords.compactMap { $0.caloriesBurned }.average()
        }
        
        for (date, calories) in dailyCalories {
            yearlyData.append(ActivityData(date: date, calories: calories))
        }
    }
    
    return yearlyData.sorted(by: { $0.date < $1.date })
}

extension Array where Element == Double {
    func average() -> Double {
        guard !self.isEmpty else { return 0.0 }
        return self.reduce(0, +) / Double(self.count)
    }
}

struct YearlyChartView: View {
    let yearlyData: [ActivityData]
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("Calories (kcal)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                    .padding(.top, 20)
                
                Text("This Year")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding(.leading)
            
            ZStack {
                Chart {
                        ForEach(yearlyData.filter { $0.calories > 0 }) { data in
                            PointMark(
                                x: .value("Month", Double(monthNumber(from: data.date)) + 0.5),
                                y: .value("Calories", data.calories)
                            )
                            .foregroundStyle(Color(.greenMain))
                        }
                    }
                    .chartYScale(domain: 0...(yearlyData.map { $0.calories }.max() ?? 0))
                    .chartXAxis {
                        AxisMarks(values: Array(1...12)) { value in
                            if let monthIndex = value.as(Int.self) {
                                AxisValueLabel(monthInitial(from: monthIndex))
                            }
                            AxisGridLine()
                        }
                        
                    }
                    .chartXScale(domain: 1...13)
                    .chartYAxis {
                        AxisMarks()
                    }
                    .frame(height: 200)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    func monthNumber(from date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.month, from: date)
    }
    
    func monthInitial(from month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let monthName = formatter.shortMonthSymbols[month - 1]
        return String(monthName.prefix(1)) // Take only the first letter
    }
}

struct DailyActivityData: Identifiable {
    let id = UUID()
    let date: Date
    let averageCalories: Double
}

struct MonthActivityData: Identifiable {
    let id = UUID()
    let month: Date
    let dailyData: [DailyActivityData]
}
