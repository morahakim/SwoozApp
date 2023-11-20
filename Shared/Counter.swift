//
//  Counter.swift
//  WatchConnectivityPrototype
//
//  Created by Chris Gaafary on 4/18/21.
//

import Foundation
import Combine
import WatchConnectivity
import AVFoundation
import SwiftUI

final class Counter: ObservableObject {
    static let shared = Counter()
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<Int, Never>()
    let totalSubject = PassthroughSubject<Int, Never>()
    let targetSubject = PassthroughSubject<Int, Never>()
    let successSubject = PassthroughSubject<Int, Never>()
    let perfectSubject = PassthroughSubject<Int, Never>()
    let failSubject = PassthroughSubject<Int, Never>()
    let durationSubject = PassthroughSubject<String, Never>()
    let menuSubject = PassthroughSubject<String, Never>()
    
    let videoUrlSubject = PassthroughSubject<String, Never>()
    let typeSubject = PassthroughSubject<String, Never>()
    let levelSubject = PassthroughSubject<String, Never>()
    
    @Published private(set) var count: Int = 0
    @Published private(set) var hitTotal: Int = 0
    @Published private(set) var hitSuccess: Int = 0
    @Published private(set) var hitPerfect: Int = 0
    @Published private(set) var hitFail: Int = 0
    @Published private(set) var duration: String = ""
    @Published private(set) var menuState: String = ""
    
    @AppStorage("videoUrlApp") var videoUrlApp = ""
    @AppStorage("typeApp") var typeApp = ""
    @AppStorage("levelApp") var levelApp = ""
    
    @AppStorage("menuStateApp") var menuStateApp = ""
    
    init(session: WCSession = .default) {
        print("DBUG : RECEIVED INIT C")
        self.delegate = SessionDelegater(countSubject: subject, hitTotalSubject: totalSubject,  hitTargetSubject: targetSubject, hitSuccessSubject: successSubject, hitPerfectSubject: perfectSubject,hitFailSubject: failSubject, durationSubject: durationSubject, menuStateSubject: menuSubject, videoUrlSubject: videoUrlSubject, typeSubject: typeSubject, levelSubject: levelSubject)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
        
        totalSubject
            .receive(on: DispatchQueue.main)
            .assign(to: &$hitTotal)
        
    }
    
    func hitTotalSend(hitTotal:Int) {
        session.sendMessage(["hitTotal": hitTotal], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func hitTargetSend(hitTarget: Int) {
        session.sendMessage(["hitTarget": hitTarget], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func hitSuccessSend(hitSuccess: Int) {
        session.sendMessage(["hitSuccess": hitSuccess], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func hitPerfectSend(hitPerfect: Int) {
        session.sendMessage(["hitPerfect": hitPerfect], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    func hitFailSend(hitFail: Int) {
        session.sendMessage(["hitFail": hitFail], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func durationSend(duration: String) {
        session.sendMessage(["duration": duration], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func menuStateSend(menuState: String) {
        menuStateApp = menuState
        session.sendMessage(["menuState": menuState], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    
    func videoUrlSend(videoUrl: String) {
        videoUrlApp = videoUrl
        session.sendMessage(["videoUrl": videoUrl], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func typeSend(type: String) {
        typeApp = type
        session.sendMessage(["type": type], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func levelSend(level: String) {
        levelApp = level
        session.sendMessage(["level": level], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func increment() {
        print("DBUG : RECEIVED INIT A")
        count += 1
        session.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
            
        }
    }
    
    func decrement() {
        print("DBUG : RECEIVED INIT B")
        count -= 1
        session.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
}

