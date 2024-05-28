//
//  LowServePlacementSummaryView.swift
//  ascenttt
//
//  Created by Hanifah BN on 29/05/24.
//

import SwiftUI
import AVKit
import CoreData

struct LowServePlacementSummaryView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "hitPerfect", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "1")
    ) var recordOfAllTime: FetchedResults<RecordSkill>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "1")
    ) var latestDrill: FetchedResults<RecordSkill>
    
    @State var recordOfTheMonth: [RecordSkill] = []
    @State var lowestOfTheMonth: [RecordSkill] = []
    @State var bestAvgOfTheMonth: [RecordSkill] = []
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading) {
                        Text(chooseLevelTextTwo)
                            .font(Font.custom("SF Pro", size: 17))
                            .fontWeight(.semibold)
                        Text(keepAchieving)
                            .font(Font.custom("SF Pro", size: 15))
                            .foregroundStyle(.grayStroke6)
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
                        Text(shuttlecockDistanceLineText)
                            .font(Font.custom("SF Pro", size: 17))
                            .fontWeight(.semibold)
                        Text(theCloserBetter)
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
                            TextAlignLeading(latestClosest)
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
                                TextAlignLeading(closestText)
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
            .padding(.bottom, 36)
            .padding(.top, 24)
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.horizontal, 20)
            
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text(chooseLevelTextTwo)
                        .font(Font.custom("SF Pro", size: 17))
                        .fontWeight(.semibold)
                    
                    VStack {
                        TextAlignLeading(latestDrill.count > 0 ? latestDrill[0].variance ?? "-" : "-")
                          .font(
                            Font.custom("Urbanist", size: 28)
                              .weight(.semibold)
                          )
                          .foregroundColor(.black)
                        
                        TextAlignLeading(latestDrillText)
                          .font(Font.custom("SF Pro", size: 15))
                          .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                    }
                    
                    VStack {
                        TextAlignLeading(latestDrill.count > 0 ? latestDrill[0].variance ?? "-" : "-")
                          .font(
                            Font.custom("Urbanist", size: 28)
                              .weight(.semibold)
                          )
                          .foregroundColor(.black)
                        
                        TextAlignLeading(frequentMonthText)
                          .font(Font.custom("SF Pro", size: 15))
                          .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                          .frame(maxWidth: .infinity, alignment: .bottomLeading)
                    }
                    
                    VStack {
                        TextAlignLeading("- \(veryScatteredText)")
                        TextAlignLeading("  \(variedPlacementText)")
                        TextAlignLeading("- \(quiteScattered)")
                        TextAlignLeading("- \(quiteCentralized)")
                        TextAlignLeading("- \(veryCentralizedText)")
                        TextAlignLeading("  \(recommendedTrainBeginner)")
                    }
                    .font(Font.custom("SF Pro", size: 12))
                    .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.56))
                }
                .foregroundStyle(.neutralBlack)
                
            }
            .frame(height: 150)
            .padding(.bottom, 26)
            .padding(.top, 48)
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.horizontal, 20)

        }
        .scrollIndicators(.hidden)
        .padding(.bottom, getSafeArea().bottom + 12)
        .onAppear() {
            let levelPredicate = NSPredicate(format: "level == %@", "1")
            
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
