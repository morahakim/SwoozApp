//
//  ContentView.swift
//  WatchConnectivityPrototype
//
//  Created by Chris Gaafary on 4/14/21.
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
                               if menuStateApp == "placement" {
                                   Button {
                                       counter.menuStateSend(menuState: "stillPlay")
//                                       print("DBUG : ",menuStateApp," DBUG")
                                   } label: {
                                       Text("Start")
                                           .font(.system(size: 30))
                                   }
                                   .buttonStyle(.plain)
                               }else{
                                   Text("Open Camera!").foregroundColor(.white)
                               }
                              
                           }
                           Text("Low Serve")
                               .font(.system(size: 16))
                               .padding(.bottom, 25)
                               .foregroundColor(Color.greenMain)
                       }
                       .navigationBarBackButtonHidden(true)
                       .navigationTitle("SWOOZ").navigationBarTitleDisplayMode(.inline).onAppear{
                          
                       }
            }else if(menuStateApp == "stillPlay" || menuStateApp == "restart"){
//                CountingView()
//                VStack(){
//                    ScrollView(){
//                        ZStack {
//                                    Color.black.edgesIgnoringSafeArea(.all)
//                                    ActivityRingView()
//                                        .fixedSize()
//                        }.padding(.bottom,10)
//                        VStack(spacing: 0) {
//                            HStack(spacing: 30) {
//                                VStack {
//                                    Button(action: {
//                                        showingAlert = true
//                                    }, label: {
//                                        Image(systemName: "xmark")
//                                            .foregroundColor(.red)
//                                            .font(.system(size: 19))
//                                    })
//                                    .frame(width: 60)
//                                    .buttonStyle(.bordered)
//                                    Text("End")
//                                        .foregroundColor(.red)
//                                }
//                                VStack {
//                                    Button(action: {
//                                       
//                                    }, label: {
//                                        Image(systemName: "pause")
//                                            .font(.system(size: 19))
//                                        
//                                    })
//                                    .frame(width: 60)
//                                    .buttonStyle(.bordered)
//                                    Text("Pause")
//                                }
//                            }
//                            Text("00:00")
//                                .foregroundColor(Color.greenMain)
//                                .font(.system(size: 28))
//                        }.sheet(isPresented: $showingAlert) {
//                            VStack(spacing: 10) {
//                                Text("Are you sure?")
//                                    .foregroundColor(Color.greenMain)
//                                Button(action: {
//                                    counter.menuStateSend(menuState: "done")
//                                    showingAlert = false
//                                }, label: {
//                                    Text("End Drill")
//                                        .font(.system(size: 17))
//                                        .foregroundColor(Color.redMain)
//                                })
//                                
//                                Button(action: {
//                                    counter.menuStateSend(menuState: "restart")
//                                    showingAlert = false
//                                }, label: {
//                                    Text("Restart")
//                                        .font(.system(size: 17))
//                                })
//                                
//                            }
//                        }
//                    }
//                }
                CountingPageView()
            }else if(menuStateApp == "done"){
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
                            VStack(alignment: .leading, spacing: 15) {
                                HStack(spacing: 20) {
                                    VStack(alignment: .leading) {
                                        Text("\(hitTotalApp)")
                                            .font(.system(size: 23))
                                        Text("Clear")
                                    }
                                  
                                    VStack(alignment: .leading) {
                                        Text("\(hitTargetApp)")
                                            .font(.system(size: 23))
                                        Text("Attempt")
                                    }
                                }
                 
                    //            Spacer()
                                VStack(alignment: .leading) {
                                    Text("16:00")
                                        .font(.system(size: 23))
                                    Text("Duration")
                                       
                                }
                                
//                                NavigationLink(destination: StartPage()) {
//                                       Text("Done")
//                                   }
                                Button {
                                    menuStateApp = ""
                                    counter.menuStateSend(menuState: "")
                                } label: {
                                    Text("Back to Home")
                                }

                            }
                            .foregroundColor(Color.greenMain)
                            
                        })

            }else{
                StartPage()
            }
        }
        .onAppear{
                menuStateApp = ""
            counter.menuStateSend(menuState: "")
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
