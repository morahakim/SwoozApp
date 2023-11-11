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
    
    let counter = Counter()
    
    @AppStorage("hitFailApp") var hitFailApp = 0
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("hitPerfectApp") var hitPerfectApp = 0
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
        
        if videoUrlApp != nil {
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
            labelCountdown = "GO"
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
        //        VStack {
        //            Text("WATCHOS")
        //            if(counter.count > 0){
        //                Text(" > 0")
        //            }else{
        //                Text("0")
        //            }
        //            Text("\(counter.count)")
        //                .font(.largeTitle)
        //
        //            HStack {
        ////                Button(action: counter.decrement) {
        ////                    Label("Decrement", systemImage: "minus.circle")
        ////                }
        ////                .padding()
        //
        //                Button {
        //                    counter.decrement()
        //                } label: {
        //                    Label("Decrement", systemImage: "minus.circle")
        //                }
        //                .padding()
        //
        //
        //                Button(action: {
        //                    counter.increment()
        //                }) {
        //                    Label("Increment", systemImage: "plus.circle.fill")
        //                }
        //                .padding()
        //            }
        //            .font(.headline)
        //        }
        VStack(){
            if(menuStateApp == "placement" || menuStateApp == ""){
                //                StartPage()
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 160, height: 160)
                            .foregroundColor(Color.greenMain.opacity(0.1))
                            .padding()
                        Circle()
                            .frame(width: 150, height: 150)
                            .foregroundColor(Color.greenMain.opacity(0.4))
                            .padding()
                        Circle()
                            .frame(width: 130, height: 130)
                            .foregroundColor(Color.greenMain.opacity(0.3))
                        
                        Circle()
                            .frame(width: 110, height: 110)
                            .foregroundColor(Color.greenMain.opacity(0.5))
                        Circle()
                            .frame(width: 90, height: 90)
                            .foregroundColor(Color.greenMain.opacity(0.7))
                        if menuStateApp == "placement" && typeApp != "" && levelApp != ""{
                            Button {
                                videoUrlApp = ""
                                counter.menuStateSend(menuState: "stillPlay")
                                //                                       print("DBUG : ",menuStateApp," DBUG")
                            } label: {
                                Text("Start")
                                    .font(.system(size: 30))
                            }
                            .buttonStyle(.plain)
                        }else{
                            Text(
                                "Waiting...")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            
                        }
                        
                    }
                    if(typeApp != "" && levelApp != ""){
                        Text(typeApp+" "+levelApp)
                            .font(.system(size: 16))
                            .padding(.bottom, 25)
                            .foregroundColor(Color.greenMain)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationTitle("SWOOZ").navigationBarTitleDisplayMode(.inline).onAppear{
                    
                }
            }else if(menuStateApp == "stillPlay" || menuStateApp == "restart"){
                VStack(){
                    if(labelCountdown == "3" || labelCountdown == "2" || labelCountdown == "1" || labelCountdown == "GO"){
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
                //                Text("Statistic View").foregroundColor(.white).bold().padding(.bottom,10)
                //                HStack(){
                //                    Text("Target Total")
                //                    Spacer()
                //                    Text(String(hitTargetApp))
                //                }
                //                HStack(){
                //                    Text("Hit Total")
                //                    Spacer()
                //                    Text(String(hitTotalApp))
                //                }
                //                HStack(){
                //                    Text("Hit Clear")
                //                    Spacer()
                //                    Text(String(hitSuccessApp))
                //                }
                //                HStack(){
                //                    Text("Hit Perfect")
                //                    Spacer()
                //                    Text(String(hitPerfectApp))
                //                }
                //                HStack(){
                //                    Text("Hit Fail")
                //                    Spacer()
                //                    Text(String(hitFailApp))
                //                }
                //                Button {
                //                    menuStateApp = ""
                //                    counter.menuStateSend(menuState: "")
                //                } label: {
                //                    Text("Back to Home")
                //                }
                //                .buttonStyle(.plain).padding(.top,10)
                
                NavigationView(content: {
                    ScrollView(){
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("\(hitTargetApp)")
                                        .font(.system(size: 23))
                                    Text("Target")
                                }
                                VStack(alignment: .leading) {
                                    Text("\(hitTotalApp)")
                                        .font(.system(size: 23))
                                    Text("Attemp")
                                }
                            }
                            HStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("\(hitSuccessApp)")
                                        .font(.system(size: 23))
                                    Text("Success")
                                }
                                VStack(alignment: .leading) {
                                    Text("\(hitFailApp)")
                                        .font(.system(size: 23))
                                    Text("Fail")
                                }
                            }
                            
                            //            Spacer()
                            VStack(alignment: .leading) {
                                Text(durationApp)
                                    .font(.system(size: 23))
                                Text("Duration")
                                
                            }
                            
                            //                                NavigationLink(destination: StartPage()) {
                            //                                       Text("Done")
                            //                                   }
                            Button {
                                menuStateApp = ""
                                counter.menuStateSend(menuState: "")
                                videoUrlApp = ""
                                levelApp = ""
                                levelApp = ""
                            } label: {
                                Text("Back to Home")
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
