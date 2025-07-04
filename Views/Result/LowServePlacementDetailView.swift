//
//  DetailVideoView.swift
//  ascenttt
//
//  Created by mora hakim on 07/11/23.
//

import SwiftUI
import AVKit
import CoreData

struct LowServePlacementDetailView: View {
    var item: FetchedResults<RecordSkill>.Element
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
    
    let language = Locale.current.language.languageCode?.identifier ?? ""
    @State var previousDrill = ""
    
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
        ZStack {
            Color.greenMain.ignoresSafeArea(.container, edges: .top)
            VStack(spacing: 15) {
                if item.url != nil {
                    VideoPlayer(player: player)
                        .cornerRadius(12)
                        .frame(height: getScreenBound().width * 0.5)
                        .padding(.horizontal, 16)
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
                                        .font(Font.custom("Urbanist-Medium", size: 22))
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
                                TextAlignLeading("\(goodServePerformText) *cm")
                                    .font(Font.custom("Urbanist", size: 15))
                                    .foregroundColor(.grayStroke6)
                                
                                VStack(spacing: 15) {
                                    if attempData.count > 0 {
                                        let itemCount = min(attempData.count, 17) 
                                        ForEach(0..<((itemCount + 9) / 10), id: \.self) { row in
                                            HStack {
                                                ForEach(attempData[row * 10..<min((row + 1) * 10, itemCount)]) { index in
                                                    Text(index.hitNumber)
                                                        .foregroundStyle(index.hitStatus == "Perfect" ? Color.neutralBlack : Color.grayStroke6)
                                                        .font(
                                                            Font.custom(
                                                                index.hitStatus == "Perfect" ?
                                                                "Urbanist-Medium" : "Urbanist",
                                                            size: 20))
                                                        .frame(maxWidth: itemWidth)
                                                }
                                            }
                                        }
                                    } else {
                                        Text(noDataText).font(Font.custom( "Urbanist", size: 20))
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
                                
                                HStack(spacing: 30) {
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
                                
                                
                                VStack(spacing: 10) {
                                    if latestDrill.count >= 2 {
                                        Text("\(item.hitPerfect - latestDrill[1].hitPerfect)")
                                            .font(Font.custom("Urbanist-Medium", size: 17))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                        Text("\(goodServeQualityText) \((item.hitPerfect - latestDrill[1].hitPerfect) < 0 ? keepDecreasing : keepIncreasing)")
                                            .font(Font.custom("Urbanist-Medium", size: 12))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                    } else {
                                        Text("0")
                                            .font(Font.custom("Urbanist-Medium", size: 17))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                        Text("\(goodServeQualityText) \(keepIncreasing)")
                                            .font(Font.custom("Urbanist-Medium", size: 12))
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
                                            .font(Font.custom("Urbanist-Medium", size: 17))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                        Text("\(averageProgressText) \((item.avgDistance - latestDrill[1].avgDistance) < 0 ? keepDecreasing : keepIncreasing)")
                                            .font(Font.custom("Urbanist-Medium", size: 12))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                    } else {
                                        Text("0")
                                            .font(Font.custom("Urbanist-Medium", size: 17))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                        Text("\(averageProgressText) \(keepIncreasing)")
                                            .font(Font.custom("Urbanist-Medium", size: 12))
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
                                    if(language == "id"){
                                        Text(item.variance ?? "")
                                            .font(Font.custom("Urbanist-Medium", size: 28))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .foregroundColor(.neutralBlack)
                                    }else{
                                        if(item.variance == "Sangat Tersebar"){
                                            Text("Very Scattered")
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }else if(item.variance == "Cukup Tersebar"){
                                            Text("Quite Scattered")
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }else if(item.variance == "Sangat Terpusat"){
                                            Text("Very Centralized")
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }else if(item.variance == "Cukup Terpusat"){
                                            Text("Quite Centralized")
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }else{
                                            Text("-")
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                    }
                                    Text(latestDrillText)
                                        .font(Font.custom("Urbanist", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                                
                                VStack(spacing: 10) {
                                    if(language == "id"){
                                        if(previousDrill != ""){
                                            Text(previousDrill)
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }else{
                                            Text("-")
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                        
                                    }else{
                                        if(previousDrill != ""){
                                            if(previousDrill == "Sangat Tersebar"){
                                                Text("Very Scattered")
                                                    .font(Font.custom("Urbanist-Medium", size: 28))
                                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                                    .foregroundColor(.neutralBlack)
                                            }else if(previousDrill == "Cukup Tersebar"){
                                                Text("Quite Scattered")
                                                    .font(Font.custom("Urbanist-Medium", size: 28))
                                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                                    .foregroundColor(.neutralBlack)
                                            }else if(previousDrill == "Sangat Terpusat"){
                                                Text("Very Centralized")
                                                    .font(Font.custom("Urbanist-Medium", size: 28))
                                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                                    .foregroundColor(.neutralBlack)
                                            }else if(previousDrill == "Cukup Terpusat"){
                                                Text("Quite Centralized")
                                                    .font(Font.custom("Urbanist-Medium", size: 28))
                                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                                    .foregroundColor(.neutralBlack)
                                            }else{
                                                Text("-")
                                                    .font(Font.custom("Urbanist-Medium", size: 28))
                                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                                    .foregroundColor(.neutralBlack)
                                            }
                                        }else{
                                            Text("-")
                                                .font(Font.custom("Urbanist-Medium", size: 28))
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .foregroundColor(.neutralBlack)
                                        }
                                        
                                    }
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
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, getSafeArea().bottom + 2)
                    .scrollIndicators(.hidden)
                    .ignoresSafeArea(.container, edges: .bottom)
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
                    var isLoop = true
                    for val in latestDrill {
                        if let valDatetime = val.datetime, let itemDatetime = item.datetime {
                            if valDatetime < itemDatetime && isLoop {
                                print(valDatetime)
                                previousDrill = val.variance ?? ""
                                isLoop = false
                            }
                        }
                    }
//                    print(previousDrill)
                    editedName = item.name ?? ""
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
struct ThickDividers: View {
    var thickness: CGFloat
    var color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
    }
}


extension Color {
    static func backgroundColor(for level: String?) -> Color {
        return Color.greenMain.opacity(0.8)
    }
}


