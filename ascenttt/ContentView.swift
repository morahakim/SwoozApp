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
    @StateObject var counter = Counter()

    var body: some View {
        VStack {
            Text("IOS")
            Text("\(counter.count)")
                .font(.largeTitle)
            
            HStack {
//                Button(action: counter.decrement) {
//                    Label("Decrement", systemImage: "minus.circle")
//                }
//                .padding()
                
                Button {
                    counter.decrement()
                } label: {
                    Label("Decrement", systemImage: "minus.circle")
                }
                .padding()

                
                Button(action: {
                    counter.increment()
                }) {
                    Label("Increment", systemImage: "plus.circle.fill")
                }
                .padding()
            }
            .font(.headline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
