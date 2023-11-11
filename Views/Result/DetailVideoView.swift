//
//  DetailVideoView.swift
//  ascenttt
//
//  Created by mora hakim on 07/11/23.
//

import SwiftUI
import AVKit
import CoreData

struct DetailVideoView: View {
    var item: FetchedResults<Data>.Element
    @State var isPlay: Bool = false
    @State var player: AVPlayer?
    @State private var isPresenting = false
    
    @State private var isEditing = false
    @State private var editedName = ""
    
    @State private var attempData: [HitStatistics] = []
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Data.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Data.name, ascending: true)]) var database: FetchedResults<Data>
    
    private struct HitStatistics: Identifiable {
        var id = UUID().uuidString
        var hitNumber: String
        var hitStatus: String
    }
    
    private func parseAttemp(_ data: String) -> [HitStatistics] {
        var hitStatisticsArray: [HitStatistics] = []
        
        let components = data.components(separatedBy: ",")
        for component in components {
            // Split each component by colon
            let keyValue = component.components(separatedBy: ":")
            
            // Check if there are exactly two components (key and value)
            if keyValue.count == 2 {
                let hitNumber = keyValue[0]
                let hitStatus = keyValue[1]
                
                let hitStat = HitStatistics(hitNumber: hitNumber, hitStatus: hitStatus)
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
                    VideoPlayer(player: player) {
                        if !isPlay {
                            Image("PlayButton")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.greenMain)
                                .padding()
                                .onTapGesture {
                                    player?.play()
                                    isPlay.toggle()
                                }
                        }
                    }
                    .frame(width: 358, height: 173)
                    .cornerRadius(10)
                    .padding(.top, 50)
                }
                    
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 390, height: 574)
                        .background(.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                        )
                    
                    
                    
                    VStack {
                        HStack {
                            if isEditing {
                                TextField("Edit name", text: $editedName, onCommit: {
                                    updateItemName()
                                    isEditing = false
                                })
                                .font(Font.custom("Urbanist", size: 22))
                                .foregroundColor(.neutralBlack)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
//                                .padding(.bottom)
                            } else {
                                VStack {
                                    Text(item.name ?? "Low Serve")
                                        .font(Font.custom("Urbanist", size: 22))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                        .onTapGesture {
                                            editedName = item.name ?? ""
                                            isEditing = true
                                        }
                                    Rectangle()
                                        .fill(Color.backgroundColor(for: item.level))
                                        .cornerRadius(20)
                                        .frame(width: 97, height: 24)
                                        .overlay {
                                            Text(item.level ?? "-")
                                                .font(Font.custom("SF Pro", size: 12))
                                                .foregroundStyle(Color.white)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                            
                            Text(item.datetime ?? "-/-/-")
                                .font(Font.custom("Urbanist", size: 12))
                                .foregroundStyle(Color.grayStroke6)
                                .padding(.bottom, 30)
                        }
//                        .padding(.bottom)
                        .padding()
                        
                        VStack(spacing: 25) {
                            HStack {
                                VStack(spacing: 8) {
                                    Text("\(item.hitTarget )")
                                        .font(Font.custom("Urbanist", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Target Shot")
                                        .font(Font.custom("Urbanist", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                                VStack(spacing: 8) {
                                    Text("\(item.hitTotal )")
                                        .font(Font.custom("Urbanist", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Total Shot")
                                        .font(Font.custom("Urbanist", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                            }
                            .padding(.trailing, 90)
                            
                            HStack {
                                VStack(spacing: 8) {
                                    Text("\(item.hitSuccess)")
                                        .font(Font.custom("Urbanist", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Success")
                                        .font(Font.custom("Urbanist", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                                VStack(spacing: 8) {
                                    Text("\(item.hitFail)")
                                        .font(Font.custom("Urbanist", size: 34))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                    Text("Fail")
                                        .font(Font.custom("Urbanist", size: 17))
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        .foregroundColor(.neutralBlack)
                                }
                            }
                            .padding(.trailing, 90)
                            
                            VStack(spacing: 8) {
                                Text(item.duration ?? "00:00")
                                    .font(Font.custom("Urbanist", size: 34))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .foregroundColor(.neutralBlack)
                                Text("Duration")
                                    .font(Font.custom("Urbanist", size: 17))
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                    .foregroundColor(.neutralBlack)
                                ThickDivider(thickness: 1, color: .gray)
                                TextAlignLeading("Your shot is successful on attempts to:")
                                    .font(Font.custom("Urbanist", size: 15))
                                    .foregroundColor(.grayStroke6)
                                
                                HStack(alignment: .top, spacing: 4) {
                                    ForEach(attempData) { i in
                                        Text(i.hitNumber)
                                            .fontWeight(i.hitStatus == "Success" ? .bold : .medium)
                                    }
                                }
                                Spacer()
                            }
                        }
//                        .padding(.top)
                        .padding()
                    }
                    
                }
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
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isEditing.toggle()
                        updateItemName()
                    } label: {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                    }
                    
                }
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
struct ThickDivider: View {
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
        switch level {
        case "Intermediate":
            return Color.redMain
        case "Experienced":
            return Color.greenMain
        case "Advanced":
            return Color.information
        default:
            return Color.gray
        }
    }
}


