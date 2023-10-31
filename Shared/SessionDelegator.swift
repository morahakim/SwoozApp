//
//  SessionDelegator.swift
//  WatchConnectivityPrototype
//
//  Created by Chris Gaafary on 4/15/21.
//

import Combine
import WatchConnectivity
import SwiftUI

class SessionDelegater: NSObject, WCSessionDelegate {
    let countSubject: PassthroughSubject<Int, Never>
    let hitTotalSubject: PassthroughSubject<Int, Never>
    let hitTargetSubject: PassthroughSubject<Int, Never>
    let hitSuccessSubject: PassthroughSubject<Int, Never>
    let hitPerfectSubject: PassthroughSubject<Int, Never>
    let hitFailSubject: PassthroughSubject<Int, Never>
    let menuStateSubject: PassthroughSubject<String, Never>
    
    
    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("hitPerfectApp") var hitPerfectApp = 0
    @AppStorage("hitFailApp") var hitFailApp = 0
    @AppStorage("menuStateApp") var menuStateApp = ""
    
    @AppStorage("progressApp") var progressApp:Double = 0.0
    
    init(countSubject: PassthroughSubject<Int, Never>, hitTotalSubject: PassthroughSubject<Int, Never>,  hitTargetSubject: PassthroughSubject<Int, Never>,  hitSuccessSubject: PassthroughSubject<Int, Never>, hitPerfectSubject: PassthroughSubject<Int, Never>,  hitFailSubject: PassthroughSubject<Int, Never>,  menuStateSubject: PassthroughSubject<String, Never>) {
        print("DBUG : RECEIVED INIT 1")
        self.countSubject = countSubject
        self.hitTotalSubject = hitTotalSubject
        self.hitTargetSubject = hitTargetSubject
        self.hitSuccessSubject = hitSuccessSubject
        self.hitPerfectSubject = hitPerfectSubject
        self.hitFailSubject = hitFailSubject
        self.menuStateSubject = menuStateSubject
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("DBUG : RECEIVED INIT 2")
        // Protocol comformance only
        // Not needed for this demo
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("DBUG : RECEIVED INIT 3")
        DispatchQueue.main.async {
            if let count = message["count"] as? Int {
                self.countSubject.send(count)
                print("DBUG : RECEIVED")
            } else {
                print("There was an error")
            }
            
            if let hitTotal = message["hitTotal"] as? Int {
                self.hitTotalSubject.send(hitTotal)
                print("DBUG : RECEIVED")
                self.hitTotalApp = hitTotal
            } else {
                print("There was an error")
            }
            
            if let hitTarget = message["hitTarget"] as? Int {
                self.hitTargetSubject.send(hitTarget)
                print("DBUG : RECEIVED")
                self.hitTargetApp = hitTarget
            } else {
                print("There was an error")
            }
            
            if let hitSuccess = message["hitSuccess"] as? Int {
                self.hitSuccessSubject.send(hitSuccess)
                print("DBUG : RECEIVED")
                self.hitSuccessApp = hitSuccess
            } else {
                print("There was an error")
            }
            
            if let hitPerfect = message["hitPerfect"] as? Int {
               self.hitPerfectSubject.send(hitPerfect)
               print("DBUG : RECEIVED")
               self.hitPerfectApp = hitPerfect
           } else {
               print("There was an error")
           }
            
            if let hitFail = message["hitFail"] as? Int {
               self.hitFailSubject.send(hitFail)
               print("DBUG : RECEIVED")
               self.hitFailApp = hitFail
           } else {
               print("There was an error")
           }
            
            if let menuHitState = message["menuState"] as? String {
                self.menuStateSubject.send(menuHitState)
                print("DBUG : RECEIVED", menuHitState)
                self.menuStateApp = menuHitState
                if(menuHitState == "done"){
//                    self.hitTotalApp = 0
//                    self.hitTargetApp = 0
//                    self.hitSuccessApp = 0
                    //                    self.hitPerfectApp = 0
                    //                    self.hitFailApp = 0
                }
            } else {
                print("There was an error")
            }
            if(self.hitSuccessApp > 0){
                self.progressApp = Double(self.hitTotalApp) / Double(self.hitTargetApp)
                
            }else{
                self.progressApp = 0.0
            }
            // print(self.hitSuccessApp)
            // print(self.hitTargetApp)
            // print(self.progressApp)
            
            
        }
    }
    
    // iOS Protocol comformance
    // Not needed for this demo otherwise
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("DBUG : RECEIVED INIT 4")
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("DBUG : RECEIVED INIT 5")
        // Activate the new session after having switched to a new watch.
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("DBUG : RECEIVED INIT 6")
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
    
}
