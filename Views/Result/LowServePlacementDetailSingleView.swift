//
//  DetailVideoView.swift
//  ascenttt
//
//  Created by mora hakim on 07/11/23.
//

import SwiftUI
import AVKit
import CoreData

struct LowServePlacementDetailSingleView: View {
    var item: FetchedResults<RecordSkill>.Element
    @Binding var isShowDetail: Bool
    
    @State var isPlay: Bool = false
    @State var player: AVPlayer?
    @State private var isPresenting = false
    
    @State private var itemWidth:Double = 0
    @State private var screenWith = UIScreen.main.bounds.width
    
    @State private var isEditing = false
    @State private var editedName = ""
    @State private var isShare: Bool = false
    
    @State private var attempData: [HitStatistics] = []
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: RecordSkill.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \RecordSkill.name, ascending: true)]) var database: FetchedResults<RecordSkill>
    
    private struct HitStatistics: Identifiable {
        var id = UUID().uuidString
        var hitNumber: String
        var hitStatus: String
        var netDistance: Double
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "datetime", ascending: false)],
        predicate: NSPredicate(format: "level == %@", "1")
    ) private var latestDrill: FetchedResults<RecordSkill>
    
    private func parseAttemp(_ data: String) -> [HitStatistics] {
        var hitStatisticsArray: [HitStatistics] = []
        
        let components = data.components(separatedBy: ",")
        for component in components {
            // Split each component by colon
            let keyValue = component.components(separatedBy: ":")
            
            // Check if there are exactly two components (key and value)
            if keyValue.count == 3 {
                let hitNumber = keyValue[0]
                let hitStatus = keyValue[1]
                let netDistance = Double(keyValue[2]) ?? 0.0
                
                let hitStat = HitStatistics(hitNumber: hitNumber, hitStatus: hitStatus, netDistance: netDistance)
                hitStatisticsArray.append(hitStat)
            }
        }
        return hitStatisticsArray
    }
    
    var body: some View {
        ForceOrientation(.portrait) {
            ZStack {
                Color.greenMain.ignoresSafeArea(.container, edges: .top)
                VStack(spacing: 15) {
                    
                    if item.url != nil {
                        VideoPlayer(player: player) {
                            //                        if !isPlay {
                            //                            Image("PlayButton")
                            //                                .resizable()
                            //                                .frame(width: 60, height: 60)
                            //                                .foregroundColor(.greenMain)
                            //                                .padding()
                            //                                .onTapGesture {
                            //                                    isPlay.toggle()
                            //                                    player?.seek(to: .zero)
                            //                                }
                            //                        }
                        }
                    }
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
                        
                        ScrollView {
                            VStack {
                                VStack {
                                    HStack {
                                        Text(chooseLevelTextTwo ?? "-")
                                            .font(Font.custom("SF Pro", size: 12))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 4)
                                            .frame(minWidth: 74)
                                            .background(Color.backgroundColor(for: item.level))
                                            .cornerRadius(12)
                                        Spacer()
                                        Text(dateFormat(item.datetime) == "" ? "-/-/-" : dateFormat(item.datetime))
                                            .font(Font.custom("Urbanist", size: 12))
                                            .foregroundStyle(Color.grayStroke6)
                                    }
                                    HStack {
                                        if isEditing {
                                            TextField(editName, text: $editedName, onCommit: {
                                                updateItemName()
                                            })
                                            .font(Font.custom("Urbanist", size: 22))
                                            .foregroundColor(.neutralBlack)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        } else {
                                            Text(item.name ?? lowServeText)
                                                .font(Font.custom("Urbanist-Medium", size: 22))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            
                                            Button {
                                                isEditing.toggle()
                                                updateItemName()
                                            } label: {
                                                Image(systemName: isEditing ? "checkmark" : "pencil")
                                                    .foregroundStyle(Color.neutralBlack)
                                            }
                                        }
                                    }
                                }
                                
                                VStack(spacing: 15) {
                                    TextAlignLeading(goodServePerformText)
                                        .font(Font.custom("Urbanist", size: 15))
                                        .foregroundColor(.grayStroke6)
                                    
                                    VStack(spacing: 15) {
                                        if attempData.count > 0 {
                                            ForEach(0..<((attempData.count + 9) / 10)) { row in
                                                HStack(){
                                                    ForEach(attempData[row * 10..<min((row + 1) * 10, attempData.count)]) { i in
                                                        Text(i.hitNumber)
                                                            .foregroundStyle(i.hitStatus == "Perfect" ? Color.neutralBlack : Color.grayStroke6)
                                                            .font(Font.custom(i.hitStatus == "Perfect" ? "Urbanist-Medium" : "Urbanist",size: 20)).frame(maxWidth:itemWidth)
                                                    }
                                                }
                                            }
                                        } else {
                                            Text(noDataText).font(Font.custom( "Urbanist",size: 20))
                                        }
                                    }
                                    
                                    ThickDividers(thickness: 1, color: .gray)
                                }
                                .padding(.top)
                                
                                VStack(spacing: 25) {
                                    Text(placementQuality)
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    
                                    HStack {
                                        VStack(spacing: 8) {
                                            Text("\(item.hitTotal )")
                                                .font(Font.custom("Urbanist-Medium", size: 34))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text(tryingText)
                                                .font(Font.custom("Urbanist-Medium", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            Text(item.duration ?? "00:00")
                                                .font(Font.custom("Urbanist-Medium", size: 34))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text(durationText)
                                                .font(Font.custom("Urbanist-Medium", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                    }
                                    .padding(.trailing, 90)
                                    
                                    HStack {
                                        VStack(spacing: 8) {
                                            Text("\(item.hitPerfect)")
                                                .font(Font.custom("Urbanist-Medium", size: 34))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text(goodTextTrajectory)
                                                .font(Font.custom("Urbanist-Medium", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                        VStack(spacing: 8) {
                                            Text("\(item.hitSuccess)")
                                                .font(Font.custom("Urbanist-Medium", size: 34))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text(riskyTextTrajectory)
                                                .font(Font.custom("Urbanist-Medium", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                        VStack(spacing: 8) {
                                            Text("\(item.hitFail)")
                                                .font(Font.custom("Urbanist-Medium", size: 34))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text(badTextTrajectory)
                                                .font(Font.custom("Urbanist-Medium", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                    }
                                    .padding(.trailing, 90)
                                    
                                    VStack(spacing: 10) {
                                        if latestDrill.count >= 2 {
                                            Text("\(item.hitPerfect - latestDrill[1].hitPerfect)")
                                                .font(Font.custom("Urbanist", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text("\(goodServeQualityText) \((item.hitPerfect - latestDrill[1].hitPerfect) < 0 ? keepDecreasing : keepIncreasing)")
                                                .font(Font.custom("SF Pro", size: 12))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        } else {
                                            Text("0")
                                                .font(Font.custom("Urbanist", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text("\(goodServeQualityText) \(keepIncreasing)")
                                                .font(Font.custom("SF Pro", size: 12))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                    }
                                    ThickDividers(thickness: 1, color: .gray)
                                }
                                .padding(.top)
                                
                                
                                VStack(spacing: 25) {
                                    Text(shuttlecockDistanceLineText)
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    
                                    HStack {
                                        VStack(spacing: 8) {
                                            Text(String(format: "%.2f", Double(item.minDistance)))
                                                .font(Font.custom("Urbanist-Medium", size: 34))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text(closestText)
                                                .font(Font.custom("Urbanist-Medium", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            Text(String(format: "%.2f", Double(item.avgDistance)))
                                                .font(Font.custom("Urbanist-Medium", size: 34))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text(averageText)
                                                .font(Font.custom("Urbanist-Medium", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            
                                            
                                            
                                            
                                        }
                                    }
                                    .padding(.trailing, 90)
                                    
                                    VStack(spacing: 10) {
                                        if latestDrill.count >= 2 {
                                            Text(String(format: "%.2f", Double(item.avgDistance - latestDrill[1].avgDistance)))
                                                .font(Font.custom("Urbanist", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text("\(averageProgressText) \((item.avgDistance - latestDrill[1].avgDistance) < 0 ? keepDecreasing : keepIncreasing)")
                                                .font(Font.custom("SF Pro", size: 12))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        } else {
                                            Text("0")
                                                .font(Font.custom("Urbanist", size: 17))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                            Text("\(averageProgressText) \(keepIncreasing)")
                                                .font(Font.custom("SF Pro", size: 12))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                    }
                                    
                                    ThickDividers(thickness: 1, color: .gray)
                                    
                                    Text(placementType)
                                        .font(Font.custom("SF Pro", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    
                                    VStack(spacing: 10) {
                                        Text(item.variance ?? "")
                                            .font(Font.custom("Urbanist-Medium", size: 28))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                        Text(latestDrillText)
                                            .font(Font.custom("Urbanist", size: 17))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                    }
                                    
                                    VStack(spacing: 10) {
                                        Text(latestDrill.count >= 2 ? latestDrill[0].variance ?? "" : "-")
                                            .font(Font.custom("Urbanist-Medium", size: 28))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                        Text(previousDrillText)
                                            .font(Font.custom("Urbanist", size: 17))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                            .padding(.bottom)
                                    }
                                    
                                    
                                }
                                //                        .padding(.top)
                                .padding(.top)
                                
                                
                                //                            .background(Color.greenBasicMain.opacity(0.2))
                            }
                        }
                        .padding()
                        //                .padding(.top, getSafeArea().top + 20)
                    }
                    
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(.greenMain, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .onAppear {
                        if let result = item.result {
                            attempData = parseAttemp(result)
                        }
                        if let url = item.url {
                            player = AVPlayer(url: URL(string: url)!)
                            player?.play()
                        }
                        itemWidth = screenWith / 10
                    }
                    .toolbar {
                        ToolbarItem {
                            Button {
                                isShare.toggle()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                            
                        }
                    }
                    
                }
                .shareSheet(show: $isShare, items: [URL(string: item.url ?? "")])
                
                VStack {
                    NavbarBack(action: {
                        isShowDetail.toggle()
                    }, bg: .greenMain)
                    Spacer()
                }.ignoresSafeArea(.all)
            }
        }
    }
    
    func updateItemName() {
        if let selectedItem = database.first(where: { $0 == item }) {
            selectedItem.name = editedName
            do {
                try viewContext.save()
                print("Changes saved successfully.")
            } catch {
                print("Error saving changes: \(error)")
            }
        }
    }
}


