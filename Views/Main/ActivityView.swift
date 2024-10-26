//
//  ItemActivityView.swift
//  ascenttt
//
//  Created by Hanifah BN on 14/10/24.
//

import SwiftUI
import Charts

struct ActivityData: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yy"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

let weeklyData = [
    ActivityData(date: dateFormatter.date(from: "21/10/24")!, calories: 310),
    ActivityData(date: dateFormatter.date(from: "22/10/24")!, calories: 505),
    ActivityData(date: dateFormatter.date(from: "23/10/24")!, calories: 505),
    ActivityData(date: dateFormatter.date(from: "24/10/24")!, calories: 420),
    ActivityData(date: dateFormatter.date(from: "25/10/24")!, calories: 420),
    ActivityData(date: dateFormatter.date(from: "26/10/24")!, calories: 612),
    ActivityData(date: dateFormatter.date(from: "27/10/24")!, calories: 725)
]

struct ActivityView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Picker(selection: .constant(0), label: Text("")) {
                Text("Week").tag(0)
                Text("Month").tag(1)
                Text("Year").tag(2)
                Text("All").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing])

            Text("Calories (kcal)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)

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
                        .annotation(position: .bottom) {
                            Text("\(Int(data.calories))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(preset: .automatic) { value in
                        if value.as(Int.self) == 0 {
                            AxisGridLine()
                        }
//                        AxisGridLine().foregroundStyle(.clear)
                    }
                }
                .chartXAxis {
                    let dateRange = weeklyData.map { $0.date }
                    AxisMarks(values: dateRange) { value in
//                        AxisGridLine()
                        if let dateValue = value.as(Date.self) {
                            AxisValueLabel(displayDay(for: dateValue))
                        }
                    }
//                    AxisMarks()
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
            }
            
            // BATAS CHART DAN RECENT ACT
            
            Text("Recent Activities")
                .font(.title2)
                .padding(.leading)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ItemActivityView()
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
    }
    
//    func displayDay(for date: Date) -> String {
//        let calendar = Calendar.current
//        let weekday = calendar.component(.weekday, from: date)
//
//        switch weekday {
//        case 1: return "S"
//        case 2: return "M"
//        case 3: return "T"
//        case 4: return "W"
//        case 5: return "T"
//        case 6: return "F"
//        case 7: return "S"
//        default: return ""
//        }
//    }
    
    func displayDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" //ini hari tp 3 huruf
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let dayName = dateFormatter.string(from: date)
        
        if dayName == "Tue" || dayName == "Thu" || dayName == "Sat" {
            return dayName.uppercased()
        } else {
            return ""
        }
    }
    
}

#Preview {
    ActivityView()
}
