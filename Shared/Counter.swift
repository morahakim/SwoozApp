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
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<Int, Never>()
    let totalSubject = PassthroughSubject<Int, Never>()
    let targetSubject = PassthroughSubject<Int, Never>()
    let successSubject = PassthroughSubject<Int, Never>()
    let perfectSubject = PassthroughSubject<Int, Never>()
    let failSubject = PassthroughSubject<Int, Never>()
    let menuSubject = PassthroughSubject<String, Never>()
    
    @Published private(set) var count: Int = 0
    @Published private(set) var hitTotal: Int = 0
    @Published private(set) var hitSuccess: Int = 0
    @Published private(set) var hitPerfect: Int = 0
    @Published private(set) var hitFail: Int = 0
    @Published private(set) var duration: Int = 0
    @Published private(set) var menuState: String = ""
    
    
    @AppStorage("menuStateApp") var menuStateApp = ""
    
    init(session: WCSession = .default) {
        print("DBUG : RECEIVED INIT C")
        self.delegate = SessionDelegater(countSubject: subject, hitTotalSubject: totalSubject,  hitTargetSubject: targetSubject, hitSuccessSubject: successSubject, hitPerfectSubject: perfectSubject,hitFailSubject: failSubject, menuStateSubject: menuSubject)
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
    
    func menuStateSend(menuState: String) {
        menuStateApp = menuState
        session.sendMessage(["menuState": menuState], replyHandler: nil) { error in
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