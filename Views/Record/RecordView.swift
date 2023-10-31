//
//  RecordView.swift
//  Swooz
//
//  Created by Agung Saputra on 16/10/23.
//

import SwiftUI

struct RecordView: View {
    @AppStorage("isOnRecord") var isOnRecord = true
    @AppStorage("hitTarget") var hitTarget: Int = 0
    
    @State var url: URL?
    @State var shareVideo: Bool = false
    
    var body: some View {
        VStack {
            if isOnRecord {
                HomeViewRepresentable()
                //                    .rotationEffect(Angle(degrees: 90))
                //                    .onAppear {
                //                        startRecord { error in
                //                            if let e = error {
                //                                print(e.localizedDescription)
                //                                return
                //                            }
                //                        }
                //                    }
            } else {
                LoadingRecordView()
                    .onAppear {
//                        hitTarget = 0
                        Task {
                            do {
                                self.url = try await stopRecord()
                                shareVideo.toggle()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                
            }
        }
        .shareSheet(show: $shareVideo, items: [url])
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RecordView()
}
