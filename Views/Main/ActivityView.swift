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
    @State private var showWeekSelection = false
    @State private var selectedDate = Date()

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
                    }
                }
                .chartXAxis {
                    let dateRange = weeklyData.map { $0.date }
                    AxisMarks(values: dateRange) { value in
                        if let dateValue = value.as(Date.self) {
                            AxisValueLabel(displayDay(for: dateValue))
                        }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
            }

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
        .sheet(isPresented: $showWeekSelection) {
            WeekSelectionView(selectedDate: $selectedDate)
                           .presentationDetents([.fraction(0.5)])
        }
    }

    func displayDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let dayName = dateFormatter.string(from: date)
        
        if dayName == "Tue" || dayName == "Thu" || dayName == "Sat" {
            return dayName.uppercased()
        } else {
            return ""
        }
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



#Preview {
    ActivityView()
}
