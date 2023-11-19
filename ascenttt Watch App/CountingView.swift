//
//  CountingView.swift
//  SwoozWatch Watch App
//
//  Created by mora hakim on 30/10/23.
//

import SwiftUI

struct CountingView: View {
    var colors: [Color] = [Color.greenMain, Color.greenBlur]
//        @Binding var value: Int
    
//    @State private var progress: CGFloat = 0.5
    
    var body: some View {
        VStack(){
            
        }
    }
}

struct ActivityRingView: View {
    
    
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
   
    
    @AppStorage("progressApp") var progressApp:Double = 0.0
    
    
    @State private var hitSuccess: Int = 0
    @State private var maxHitSuccess: Int = 50
    var colorsMain: [Color] = [Color.greenMain, Color.greenMain]
    var colors: [Color] = [Color.greenBlur, Color.greenBlur]
//    @Binding var progress: CGFloat
//    private var progresss: CGFloat {
//        return CGFloat(hitSuccess) / CGFloat(hitTotalApp)
//    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
               
                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(Color.greenBlur, lineWidth: 20)
                                    .frame(width: 110, height: 110)
                                    .rotationEffect(.degrees(0))
                Circle()
                                    .trim(from: 0, to: CGFloat(progressApp)) // Change this line to start from 0 and go up to your desired progress
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(colors: colorsMain),
                                            center: .center,
                                            startAngle: .degrees(0), // Change the startAngle to 0
                                            endAngle: .degrees(360 * Double(progressApp)) // Adjust the endAngle to make it progress clockwise
                                        ),
                                        style: StrokeStyle(lineWidth: 20, lineCap: .square)
                                    )
                                    .rotationEffect(.degrees(-90)) // Rotate the circle counterclockwise by -90 degrees
                VStack(spacing: 5) {
                    if(1 == 1){
                        Text("\(Int(hitTotalApp))/\(Int(hitTargetApp))")
                            .foregroundColor(Color.greenMain)
                            .font(.system(size: 28))
                            .fontWeight(.semibold)
                    }else{
                        Text("\(Int(hitTotalApp))/∞")
                            .foregroundColor(Color.greenMain)
                            .font(.system(size: 28))
                            .fontWeight(.semibold)
                    }
                   
                    Text("Attempt")
                        .font(.system(size: 16))
                        .foregroundColor(Color.greenMain)
                }
            }

            Text("Good:\((hitSuccessApp))")
                .foregroundColor(Color.greenMain)
                .font(.system(size: 16))
                .padding(.bottom, 20)
        }
        .padding(.top, 0)
    }
}


struct PauseEndView: View {
    @State private var showingAlert = false
    @Binding var value: Int
    @Binding var textCountdown:String
    var body: some View {
        VStack(spacing: 40) {
            HStack(spacing: 30) {
                VStack {
                    Button(action: {
                        showingAlert = true
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .font(.system(size: 19))
                    })
                    .frame(width: 60)
                    .buttonStyle(.bordered)
                    Text("End")
                        .foregroundColor(.red)
                }
//                VStack {
//                    Button(action: {
//
//                    }, label: {
//                        Image(systemName: "pause")
//                            .font(.system(size: 19))
//
//                    })
//                    .frame(width: 60)
//                    .buttonStyle(.bordered)
//                    Text("Pause")
//                }
            }
            Text(textCountdown)
                .foregroundColor(Color.greenMain)
                .font(.system(size: 28))
        }

        .sheet(isPresented: $showingAlert) {
            SheetAlert()
        }
    }
}


struct SheetAlert: View {
    @AppStorage("hitFailApp") var hitFailApp = 0
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("hitPerfectApp") var hitPerfectApp = 0
    @AppStorage("menuStateApp") var menuStateApp = ""
    @State var showingAlert = false
    
    let counter = Counter()
    var body: some View {
        VStack(spacing: 10) {
            Text("Are you sure?")
                .foregroundColor(Color.greenMain)
            Button(action: {
                counter.menuStateSend(menuState: "result")
                showingAlert = false
            }, label: {
                Text("End Drill")
                    .font(.system(size: 17))
                    .foregroundColor(Color.redMain)
            })
            
//            Button(action: {
//                counter.menuStateSend(menuState: "restart")
//                showingAlert = false
//            }, label: {
//                Text("Restart")
//                    .font(.system(size: 17))
//            })
            
        }
    }
}


//#Preview {
//    CountingView(value: .constant(1))
//}
