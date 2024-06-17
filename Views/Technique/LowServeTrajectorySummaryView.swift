//
//  LowServeTrajectorySummaryView.swift
//  ascenttt
//
//  Created by Hanifah BN on 29/05/24.
//

import SwiftUI
import AVKit
import CoreData

struct LowServeTrajectorySummaryView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "hitPerfect", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "0")
    ) var recordOfAllTime: FetchedResults<RecordSkill>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "0")
    ) var latestDrill: FetchedResults<RecordSkill>
    
    @State var recordOfTheMonth: [RecordSkill] = []
    @State var lowestOfTheMonth: [RecordSkill] = []
    @State var bestAvgOfTheMonth: [RecordSkill] = []
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading) {
                        Text(chooseLevelTextOne)
                            .font(Font.custom("SF Pro", size: 17))
                            .fontWeight(.semibold)
                        Text(keepAchieving)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundStyle(.grayStroke6)
                    }
                    
                    VStack(spacing: 2) {
                        HStack {
                            TextAlignLeading(recordOfAllTime.count > 0 ? "\(recordOfAllTime[0].hitPerfect)" : "-")
                            Spacer()
                            TextAlignLeading(recordOfTheMonth.count > 0 ? "\(recordOfTheMonth[0].hitPerfect)" : "-")
                        }
                        .font(Font.custom("Urbanist", size: 28))
                        .fontWeight(.semibold)
                        
                        HStack {
                            TextAlignLeading(recordAllTimeText)
                            Spacer()
                            TextAlignLeading(recordOfMonthText)
                        }
                        .font(Font.custom("SF Pro", size: 15))
                    }
                    
                    VStack(spacing: 2) {
                        HStack {
                            TextAlignLeading(latestDrill.count > 0 ? "\(latestDrill[0].hitPerfect)" : "-")
                            Spacer()
                            TextAlignLeading(String(format: "%.2f", getAverate(recordOfTheMonth)))
                        }
                        .font(Font.custom("Urbanist", size: 28))
                        .fontWeight(.semibold)
                        
                        HStack {
                            TextAlignLeading(latestDrillText)
                            Spacer()
                            TextAlignLeading(averageDrillText)
                        }
                        .font(Font.custom("SF Pro", size: 15))
                    }
                }
                .foregroundStyle(.neutralBlack)
                
            }
            .frame(height: 150)
            .padding(.bottom, 10)
            .padding(.top, 24)
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.horizontal, 20)
            
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading) {
                        Text(shuttlecockOverNetText)
                            .font(Font.custom("SF Pro", size: 17))
                            .fontWeight(.semibold)
                        Text(theLowerBetter)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundStyle(.grayStroke6)
                    }
                    
                    VStack(spacing: 2) {
                        HStack {
                            TextAlignLeading("\(String(format: "%.2f", getLatestLowest(latestDrill))) cm")
                            Spacer()
                            TextAlignLeading("\(String(format: "%.2f", getLatesAvg(latestDrill))) cm")
                        }
                        .font(Font.custom("Urbanist", size: 28))
                        .fontWeight(.semibold)
                        
                        HStack {
                            TextAlignLeading(latestLowest)
                            Spacer()
                            TextAlignLeading(latestAvg)
                        }
                        .font(Font.custom("SF Pro", size: 15))
                    }
                    
                    VStack(spacing: 2) {
                        HStack {
                            TextAlignLeading("\(String(format: "%.2f", getMonthLowest(lowestOfTheMonth))) cm")
                            Spacer()
                            TextAlignLeading("\(String(format: "%.2f", getMonthBestAvg(bestAvgOfTheMonth))) cm")
                        }
                        .font(Font.custom("Urbanist", size: 28))
                        .fontWeight(.semibold)
                        
                        HStack {
                            VStack{
                                TextAlignLeading(lowestShotText)
                                TextAlignLeading(thisMonth)
                            }
                            Spacer()
                            VStack {
                                TextAlignLeading(bestAvg)
                                TextAlignLeading(thisMonth)
                            }
                        }
                        .font(Font.custom("SF Pro", size: 15))
                    }
                }
                .foregroundStyle(.neutralBlack)
                
            }
            .frame(height: 150)
            .padding(.bottom, 40)
            .padding(.top, 24)
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
        .padding(.bottom, getSafeArea().bottom + 12)
        .onAppear {
            let levelPredicate = NSPredicate(format: "level == %@", "0")
            
            let request: NSFetchRequest<RecordSkill> = RecordSkill.fetchRequest()
            let predicate = NSPredicate(format: "(datetime >= %@) AND (datetime <= %@)", argumentArray: [getStartMonth() as NSDate, getLastMonth() as NSDate])
            request.sortDescriptors = [NSSortDescriptor(key: "hitPerfect", ascending: false)]
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate, predicate])
            
            let request2: NSFetchRequest<RecordSkill> = RecordSkill.fetchRequest()
            let predicate2 = NSPredicate(format: "(datetime >= %@) AND (datetime <= %@)", argumentArray: [getStartMonth() as NSDate, getLastMonth() as NSDate])
            request2.sortDescriptors = [NSSortDescriptor(key: "minDistance", ascending: true)]
            request2.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate, predicate2])
            
            let request3: NSFetchRequest<RecordSkill> = RecordSkill.fetchRequest()
            let predicate3 = NSPredicate(format: "(datetime >= %@) AND (datetime <= %@)", argumentArray: [getStartMonth() as NSDate, getLastMonth() as NSDate])
            request3.sortDescriptors = [NSSortDescriptor(key: "avgDistance", ascending: true)]
            request3.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate, predicate3])
            
            do {
                recordOfTheMonth = try moc.fetch(request)
                lowestOfTheMonth = try moc.fetch(request2)
                bestAvgOfTheMonth = try moc.fetch(request3)
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    private func getAverate(_ data: [RecordSkill]) -> Double {
        if data.count == 0 {
            return 0
        } else {
            var total: Double = 0.0
            for e in data {
                total += Double(e.hitPerfect)
            }
            return Double(total/Double(data.count))
        }
    }
    
    private func getLatestLowest(_ data: FetchedResults<RecordSkill>) -> Double {
        if data.count > 0 {
            return data[0].minDistance
        } else {
            return 0
        }
    }
    
    private func getLatesAvg(_ data: FetchedResults<RecordSkill>) -> Double {
        if data.count > 0 {
            return data[0].avgDistance
        } else {
            return 0
        }
    }
    
    private func getMonthBestAvg(_ data: [RecordSkill]) -> Double {
        if data.count > 0 {
            return data[0].avgDistance
        } else {
            return 0
        }
    }
    
    private func getMonthLowest(_ data: [RecordSkill]) -> Double {
        if data.count > 0 {
            return data[0].minDistance
        } else {
            return 0
        }
    }
}
