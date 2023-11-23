//
//  TechniqueDetailView.swift
//  Swooz
//
//  Created by Agung Saputra on 27/10/23.
//

import SwiftUI
import AVKit
import CoreData

struct LowServeTrajectoryView: View {
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.managedObjectContext) var moc
    
    @State var showRepetitionSheet = false
    @State var selectedRepetition = 0
    @State var player: AVPlayer?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "hitPerfect", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "0")
    ) var recordOfAllTime: FetchedResults<Data>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "0")
    ) var latestDrill: FetchedResults<Data>
    
    @State var recordOfTheMonth: [Data] = []
    @State var lowestOfTheMonth: [Data] = []
    @State var bestAvgOfTheMonth: [Data] = []
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack(alignment: .top) {
                Color.greenMain.ignoresSafeArea(.all)
                
                VStack {
                    /** Card animation */
                    CardView(action: {}, content: {
                        ZStack {
                            LottieView(name: "LowServe-Lintasan")
                                .frame(height: 150)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text(chooseLevelTextOne)
                                        .font(Font.custom("Urbanist", size: 20).weight(.medium))
                                        .foregroundColor(.neutralBlack)
                                    Spacer()
                                }
                            }
                        }
                    })
                    .frame(height: 150)
                    .padding(.bottom, 16)
                    
                    /** Card description */
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.white)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 20,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 20
                                )
                            )
                        
                        VStack(spacing: 12) {
                            VideoPlayer(player: player)
                                .frame(width: 358, height: 173)
                                .cornerRadius(12)
                            
                            ScrollView {
                                VStack(spacing: 4) {
                                    HStack {
                                        Circle()
                                            .frame(width: 12)
                                        Text(goodTextTrajectory)
                                            .font(Font.custom("SF Pro", size: 17))
                                        Spacer()
                                    }
                                    .foregroundStyle(.success)
                                    TextAlignLeading(goalsGoodTextTrajectory)
                                        .foregroundStyle(.neutralBlack)
                                    TextAlignLeading(descGoodTextTrajectory)
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundStyle(.grayStroke6)
                                        .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                VStack(spacing: 4) {
                                    HStack {
                                        Circle()
                                            .frame(width: 12)
                                        Text(riskyTextTrajectory)
                                            .font(Font.custom("SF Pro", size: 17))
                                        Spacer()
                                    }
                                    .foregroundStyle(.warning)
                                    TextAlignLeading(goalsRiskyTextTrajectory)
                                        .foregroundStyle(.neutralBlack)
                                    TextAlignLeading(descRiskyTextTrajectory)
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundStyle(.grayStroke6)
                                        .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                VStack(spacing: 4) {
                                    HStack {
                                        Circle()
                                            .frame(width: 12)
                                        Text(badTextTrajectory)
                                            .font(Font.custom("SF Pro", size: 17))
                                        Spacer()
                                    }
                                    .foregroundStyle(.danger)
                                    TextAlignLeading(goalsBadTextTrajectory)
                                        .foregroundStyle(.neutralBlack)
                                    TextAlignLeading(descBadTextTrajectory)
                                        .font(Font.custom("SF Pro", size: 12))
                                        .foregroundStyle(.grayStroke6)
                                        .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        HStack(alignment: .top, spacing: 4) {
                                            Text(tipsText)
                                                .font(Font.custom("SF Pro", size: 17))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(red: 1, green: 0.69, blue: 0))
                                        .cornerRadius(12)
                                    }
                                    
                                    Text(trajectoryTipsText)
                                        .font(Font.custom("SF Pro", size: 15))
                                        .foregroundStyle(.grayStroke6)
                                        .padding(.bottom, 8)
                                    Divider()
                                }
                                .padding(.top, 12)
                                
                                CardView(action: {}, content: {
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
                                    
                                })
                                .frame(height: 150)
                                .padding(.bottom, 26)
                                .padding(.top, 24)
                                
                                CardView(action: {}, content: {
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
                                    
                                })
                                .frame(height: 150)
                                .padding(.bottom, 40)
                                .padding(.top, 24)
                            }
                            .scrollIndicators(.hidden)
                            .padding(.bottom, getSafeArea().bottom + 12)
                        }
                        .font(Font.custom("SF Pro", size: 15))
                        .padding(16)
                    }
                }
                .padding(.top, getSafeArea().top - 24)
                
                /** Button record */
                VStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        BtnPrimary(text: buttonRecordText) {
                            showRepetitionSheet.toggle()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, getSafeArea().bottom + 2)
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: -2)
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.greenMain, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showRepetitionSheet) {
                RepetitionSheet(
                    isPresented: $showRepetitionSheet,
                    selectedRepetition: $selectedRepetition
                )
                .presentationDetents([.fraction(0.4)])
                
            }
            .onAppear {
                if let url = Bundle.main.url(forResource: "ServeTrajectory", withExtension: "mp4") {
                    player = AVPlayer(url: url)
                    player?.play()
                }
            }
            
            
        }
        .onDisappear {
            if vm.path.last == .Record {
                UIDevice.current.setValue(
                    UIInterfaceOrientation.portrait.rawValue,
                    forKey: "orientation"
                )
                AppDelegate.orientationLock = .portrait
                player?.pause()
            } else if vm.path.last == .RotateToLandscape {
                UIDevice.current.setValue(
                    UIInterfaceOrientation.landscapeRight.rawValue,
                    forKey: "orientation"
                )
                AppDelegate.orientationLock = .landscapeRight
                player?.pause()
            }
        }
        .onAppear {
            let levelPredicate = NSPredicate(format: "level == %@", "0")
            
            let request: NSFetchRequest<Data> = Data.fetchRequest()
            let predicate = NSPredicate(format: "(datetime >= %@) AND (datetime <= %@)", argumentArray: [getStartMonth() as NSDate, getLastMonth() as NSDate])
            request.sortDescriptors = [NSSortDescriptor(key: "hitPerfect", ascending: false)]
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate, predicate])
            
            let request2: NSFetchRequest<Data> = Data.fetchRequest()
            let predicate2 = NSPredicate(format: "(datetime >= %@) AND (datetime <= %@)", argumentArray: [getStartMonth() as NSDate, getLastMonth() as NSDate])
            request2.sortDescriptors = [NSSortDescriptor(key: "minDistance", ascending: true)]
            request2.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate, predicate2])
            
            let request3: NSFetchRequest<Data> = Data.fetchRequest()
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
    
    private func getAverate(_ data: [Data]) -> Double {
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
    
    private func getLatestLowest(_ data: FetchedResults<Data>) -> Double {
        if data.count > 0 {
            return data[0].minDistance
        } else {
            return 0
        }
    }
    
    private func getLatesAvg(_ data: FetchedResults<Data>) -> Double {
        if data.count > 0 {
            return data[0].avgDistance
        } else {
            return 0
        }
    }
    
    private func getMonthBestAvg(_ data: [Data]) -> Double {
        if data.count > 0 {
            return data[0].avgDistance
        } else {
            return 0
        }
    }
    
    private func getMonthLowest(_ data: [Data]) -> Double {
        if data.count > 0 {
            return data[0].minDistance
        } else {
            return 0
        }
    }
}

private struct RepetitionSheet: View {
    @EnvironmentObject var vm: HomeViewModel
    @Binding var isPresented: Bool
    @Binding var selectedRepetition: Int
    
    @AppStorage("hitTargetApp") var hitTargetApp: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            TextAlignLeading(repetitionText)
                .font(Font.custom("SF Pro", size: 20).bold())
                .foregroundColor(.neutralBlack)
                .padding(.top, 18)
                .padding(.horizontal, 16)
            
            Picker("", selection: $selectedRepetition) {
                Text(unlimitedText).tag(0)
                Text("5").tag(5)
                Text("10").tag(10)
                Text("15").tag(15)
                Text("20").tag(20)
            }
            .pickerStyle(.wheel)
            .padding(.horizontal, 16)
            
            Divider()
            BtnPrimary(text: continueText) {
                hitTargetApp = selectedRepetition
                isPresented.toggle()
                vm.path.append(.RotateToLandscape)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.portrait.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeRight.rawValue,
                forKey: "orientation"
            )
            AppDelegate.orientationLock = .landscapeRight
        }
    }
}

#Preview {
    LowServeTrajectoryView()
}
