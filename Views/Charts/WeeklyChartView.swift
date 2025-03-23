//
//  WeeklyChartView.swift
//  ascenttt
//
//  Created by Hanifah BN on 24/01/25.
//

import SwiftUI
import Charts
import CoreData

struct WeeklyChartView: View {
    let weeklyData: [ActivityData]
    @Binding var showWeekSelection: Bool
    @Binding var selectedDate: Date 

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Text("Calories (kcal)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                    .padding(.top, 20)
                
                HStack {
                    Text("This Week")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showWeekSelection.toggle()
                    }) {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.leading)
            
            ZStack {
                Chart {
                    ForEach(weeklyData) { data in
                        LineMark(
                            x: .value("Day", data.date),
                            y: .value("Calories", data.calories)
                        )
                        .foregroundStyle(Color(.greenBasicMain))
                        .symbol(Circle())
                        .symbolSize(10)
                        
                        PointMark(
                            x: .value("Day", data.date),
                            y: .value("Calories", data.calories)
                        )
                        .foregroundStyle(Color(.greenMain))
                        .annotation(position: .top) {
                            Text("\(Int(data.calories))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .chartYScale(domain: 0...(weeklyData.map { $0.calories }.max().map { maxValue in
                    if maxValue < 100 {
                        return Int(maxValue + 20)
                    } else {
                        return Int(maxValue + 50)
                    }
                } ?? 0))

                .chartYAxis {
                    AxisMarks(preset: .automatic) { value in
                        if value.as(Int.self) == 0 {
                            AxisGridLine()
                        }
                    }
                }
                .chartXAxis {
                    let dateRange = weeklyData.map { $0.date }
                    AxisMarks(values: dateRange) { value in
                        if let dateValue = value.as(Date.self) {
                            AxisValueLabel {
                                Text(displayDayByDayAndMonth(for: dateValue))
                            }
                            AxisGridLine()
                        }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
            }
        }
    }
    
    func displayDayByDayAndMonth(for date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let weekday = calendar.component(.weekday, from: date)
        let formattedDate = dateFormatter.string(from: date)
        
        if weekday == 2 || weekday == 5 || weekday == 1 {
            return formattedDate
        } else {
            return ""
        }
    }
}

func getWeeklyData(from records: FetchedResults<RecordSkill>, selectedDate: Date) -> [ActivityData] {
    let calendar = Calendar(identifier: .gregorian)
    let startOfSelectedDay = calendar.startOfDay(for: selectedDate)
    
    // Tentukan awal minggu dari `selectedDate`
    var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfSelectedDay)
    components.weekday = 2 // Senin sebagai hari pertama dalam minggu

    guard let startOfWeek = calendar.date(from: components) else { return [] }
    
    // Tentukan akhir minggu (7 hari dari startOfWeek)
    let weekDays = (0..<7).compactMap { offset in
        calendar.date(byAdding: .day, value: offset, to: startOfWeek)
    }
    
    // Filter data berdasarkan minggu yang dipilih
    let filteredRecords = records.filter { record in
        if let datetime = record.datetime {
            return datetime >= startOfWeek && datetime < calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        }
        return false
    }
    
    // Kelompokkan data berdasarkan hari
    let groupedByDay = Dictionary(grouping: filteredRecords) { record in
        calendar.startOfDay(for: record.datetime ?? Date())
    }
    
    return weekDays.map { day in
        let recordsForDay = groupedByDay[day] ?? []
        let totalCalories = recordsForDay.compactMap { $0.caloriesBurned }.reduce(0, +)
        let averageCalories = recordsForDay.isEmpty ? 0 : totalCalories / Double(recordsForDay.count)
        return ActivityData(date: day, calories: averageCalories)
    }
}



struct WeekSelectionView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Select Week")
                .font(.headline)
                .padding()

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .environment(\.locale, Locale(identifier: "en_US"))
            .padding()

            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Apply")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.greenMain))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}
