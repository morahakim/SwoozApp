//
//  MonthlyChartView.swift
//  ascenttt
//
//  Created by Hanifah BN on 24/01/25.
//

import SwiftUI
import Charts
import CoreData

func getMonthlyDataRaw(from records: FetchedResults<RecordSkill>) -> [ActivityData] {
    let calendar = Calendar(identifier: .gregorian)
    let today = calendar.startOfDay(for: Date())
    
    guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)),
          let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
        return []
    }
    
    let allDaysInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.compactMap { day -> Date? in
        calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
    } ?? []
    
    let monthlyData = records.compactMap { record -> ActivityData? in
        guard let datetime = record.datetime else { return nil }
        return ActivityData(date: datetime, calories: record.caloriesBurned)
    }
    
    return allDaysInMonth.flatMap { day -> [ActivityData] in
        let recordsForDay = monthlyData.filter { calendar.isDate($0.date, inSameDayAs: day) }
        return recordsForDay.isEmpty ? [ActivityData(date: day, calories: 0)] : recordsForDay
    }
}


// MARK: - Monthly Data Function
struct MonthlyChartView: View {
    let monthlyData: [ActivityData]
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("Calories (kcal)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                    .padding(.top, 20)
                
                Text("This Month")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding(.leading)
            
            ZStack {
                Chart {
                    ForEach(monthlyData.filter { $0.calories > 0 }) { data in
                        PointMark(
                            x: .value("Day", dayOfMonth(from: data.date)),
                            y: .value("Calories", data.calories)
                        )
                        .foregroundStyle(Color(.greenMain))
                        .symbol(Circle())
                    }
                }
                .chartYScale(domain: 0...(monthlyData.map { $0.calories }.max() ?? 0))
                .chartXAxis {
                    AxisMarks(values: monthlyData.map { dayOfMonth(from: $0.date) }) { value in
                        if let day = value.as(Int.self), day % 5 == 0, day <= 25 {
                            AxisValueLabel("\(day)")
                            AxisGridLine()
                        }
                    }
                }

                .frame(height: 200)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func dayOfMonth(from date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.day, from: date)
    }
}
