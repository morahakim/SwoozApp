//
//  ContentView.swift
//  SwoozWatch Watch App
//
//  Created by mora hakim on 30/10/23.
//

import SwiftUI
import WatchConnectivity
import AVFoundation

struct ContentView: View {
    
    @State var showingAlert = false
    
    @ObservedObject var counter = Counter.shared
    
    @AppStorage("hitFailApp") var hitFailApp = 0
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("hitPerfectApp") var hitPerfectApp = 0
    @AppStorage("averageApp") var averageApp = 0.0
    @AppStorage("minApp") var minApp = 0.0
    @AppStorage("menuStateApp") var menuStateApp = ""
    @AppStorage("durationApp") var durationApp = ""
    
    
    @AppStorage("videoUrlApp") var videoUrlApp = ""
    @AppStorage("typeApp") var typeApp = ""
    @AppStorage("levelApp") var levelApp = ""
    
    @State var countdownTimer: Timer?
    @State var countdownValue = 3
    @State var timer: Timer?
    @State var remainingTime = 20 * 60 + 1
    
    @State var labelCountdown = ""
    
    @State var textCountdown = ""
    
    @State var urlVideoSource : AVAsset?
    @State var urlVideo : URL? {
        didSet {
            updateVideoSource()
        }
    }
    
    func updateVideoSource(){
        if(urlVideo != nil){
            urlVideoSource = AVAsset(url: urlVideo!)
        }else{
            urlVideoSource = nil
        }
    }
    
    func startCountdown() {
        
        labelCountdown = ""
        textCountdown = ""
        timer?.invalidate()
        countdownTimer?.invalidate()
        countdownValue = 3
        remainingTime = 20 * 60 + 1
        
        if videoUrlApp == "exist" {
            // Start reading the video.
            countdownValue = 0
            labelCountdown = String("")
        } else {
            // Start live camera capture.
            labelCountdown = String(countdownValue)
        }
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timerr in
            updateCountdownLabel()
        }
        
    }
    
    func updateCountdownLabel() {
        countdownValue -= 1
        if countdownValue > 0 {
            labelCountdown = String(countdownValue)
        } else if countdownValue == 0 {
            labelCountdown = goText
        }else {
            labelCountdown = ""
            remainingTime -= 1
            if remainingTime > -1 {
                let minutes = remainingTime / 60
                let seconds = remainingTime % 60
                textCountdown = String(format: "%02d:%02d", minutes, seconds)
            } else {
                timer?.invalidate()
                countdownTimer?.invalidate()
                textCountdown = ""
                stop()
            }
        }
        print(labelCountdown)
        print(textCountdown)
    }
    
    func stop(){
        print("DBUG : STOP")
        counter.menuStateSend(menuState: "result")
    }
    
    var body: some View {
        VStack(){
            if(menuStateApp == "placement" || menuStateApp == ""){
                //                StartPage()
                VStack(spacing:0) {
                    ZStack {
                        Circle()
                            .frame(width: 140, height: 140)
                            .foregroundColor(Color.greenMain.opacity(0.1))
                            .padding(5)
                        Circle()
                            .frame(width: 130, height: 130)
                            .foregroundColor(Color.greenMain.opacity(0.4))
                            .padding(5)
                        Circle()
                            .frame(width: 110, height: 110)
                            .foregroundColor(Color.greenMain.opacity(0.3))
                        
                        Circle()
                            .frame(width: 90, height: 90)
                            .foregroundColor(Color.greenMain.opacity(0.5))
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.greenMain.opacity(0.7))
                        if menuStateApp == "placement" && typeApp != "" && levelApp != ""{
                            Button {
                                videoUrlApp = ""
                                counter.menuStateSend(menuState: "stillPlay")
                                //                                       print("DBUG : ",menuStateApp," DBUG")
                            } label: {
                                Text(startText)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(.plain)
                        }else{
                            Text(
                                waitingText)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            
                        }
                        
                    }
                    if(typeApp != "" && levelApp != ""){
//                        Text(typeApp)
//                            .font(.system(size: 12)).lineLimit(nil)
//                            .padding(.bottom, 0)
//                            .foregroundColor(Color.greenMain)
                        Text(levelApp)
                            .font(.system(size: 12)).lineLimit(nil)
                            .padding(.bottom, 0)
                            .foregroundColor(Color.greenMain)
                    }else{
                        Text(pleaseChooseText)
                            .font(.system(size: 12)).lineLimit(nil)
                            .padding(.bottom, 0)
                            .foregroundColor(Color.greenMain)
                        Text(technique)
                            .font(.system(size: 12)).lineLimit(nil)
                            .padding(.bottom, 0)
                            .foregroundColor(Color.greenMain)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationTitle("SWOOZ").navigationBarTitleDisplayMode(.inline).onAppear{
                    
                }
            }else if((menuStateApp == "stillPlay" || menuStateApp == "restart") && videoUrlApp != ""){
                VStack(){
                    if(labelCountdown == "3" || labelCountdown == "2" || labelCountdown == "1" || labelCountdown == goText){
                        VStack(){
                            Text(labelCountdown)
                                .foregroundColor(Color.greenMain)
                                .font(.system(size: 48))
                                .fontWeight(.semibold)
                        }
                        
                    }else{
                        CountingPageView(textCountdown: $textCountdown)
                    }
                }.onAppear(){
                    startCountdown()
                }.onDisappear(){
                    timer?.invalidate()
                    countdownTimer?.invalidate()
                }
                
            }else if(menuStateApp == "result"){

                NavigationView(content: {
                    ScrollView(){
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("\(hitPerfectApp)")
                                        .font(.system(size: 23))
                                    Text(goodTextTrajectory)
                                }
                                VStack(alignment: .leading) {
                                    Text("\(hitSuccessApp)")
                                        .font(.system(size: 23))
                                    Text(riskyTextTrajectory)
                                }
                            }
                            HStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("\(hitTotalApp)")
                                        .font(.system(size: 23))
                                    Text(tryingText)
                                }
                            }
                            
                            if(typeApp == "0"){
                                VStack(alignment: .leading) {
                                    Text(String(format: "%.2f cm", averageApp))
                                        .font(.system(size: 23))
                                    Text("Average Height")
                                    
                                }
                            }else if(typeApp == "1"){
                                VStack(alignment: .leading) {
                                    Text(String(format: "%.2f cm", averageApp))
                                        .font(.system(size: 23))
                                    Text("Average Distance")
                                    
                                }
                            }
                            
                            if(typeApp == "0"){
                                VStack(alignment: .leading) {
                                    Text(String(format: "%.2f cm", minApp))
                                        .font(.system(size: 23))
                                    Text("Lowest")
                                    
                                }
                            }else if(typeApp == "1"){
                                VStack(alignment: .leading) {
                                    Text(String(format: "%.2f cm", minApp))
                                        .font(.system(size: 23))
                                    Text("Closest")
                                    
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(durationApp)
                                    .font(.system(size: 23))
                                Text(durationText)
                                
                            }
                            
                            
                            Button {
                                counter.menuStateSend(menuState: "")
                                menuStateApp = ""
                                videoUrlApp = ""
                                levelApp = ""
                                levelApp = ""
                            } label: {
                                Text(doneText)
                            }
                            
                        }
                        .foregroundColor(Color.greenMain)
                    }
                    
                })
                
            }else{
                StartPage()
            }
        }
        .onAppear{
            menuStateApp = ""
            typeApp = ""
            levelApp = ""
            counter.menuStateSend(menuState: "")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
