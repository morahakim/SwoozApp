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
    let durationSubject: PassthroughSubject<String, Never>
    let menuStateSubject: PassthroughSubject<String, Never>

    let videoUrlSubject: PassthroughSubject<String, Never>
    let typeSubject: PassthroughSubject<String, Never>
    let levelSubject: PassthroughSubject<String, Never>

    let averageSubject: PassthroughSubject<Double, Never>
    let minSubject: PassthroughSubject<Double, Never>

    @AppStorage("averageApp") var averageApp = 0.0
    @AppStorage("minApp") var minApp = 0.0

    @AppStorage("hitTotalApp") var hitTotalApp = 0
    @AppStorage("hitTargetApp") var hitTargetApp = 0
    @AppStorage("hitSuccessApp") var hitSuccessApp = 0
    @AppStorage("hitPerfectApp") var hitPerfectApp = 0
    @AppStorage("hitFailApp") var hitFailApp = 0
    @AppStorage("durationApp") var durationApp = ""
    @AppStorage("menuStateApp") var menuStateApp = ""
    @AppStorage("menuStateApp2") var menuStateApp2 = ""

    @AppStorage("videoUrlApp") var videoUrlApp = ""
    @AppStorage("typeApp") var typeApp = ""
    @AppStorage("levelApp") var levelApp = ""

    @AppStorage("progressApp") var progressApp: Double = 0.0

    init(countSubject: PassthroughSubject<Int, Never>, hitTotalSubject: PassthroughSubject<Int, Never>, hitTargetSubject: PassthroughSubject<Int, Never>, hitSuccessSubject: PassthroughSubject<Int, Never>, hitPerfectSubject: PassthroughSubject<Int, Never>, hitFailSubject: PassthroughSubject<Int, Never>, durationSubject: PassthroughSubject<String, Never>, menuStateSubject: PassthroughSubject<String, Never>, videoUrlSubject: PassthroughSubject<String, Never>, typeSubject: PassthroughSubject<String, Never>, levelSubject: PassthroughSubject<String, Never>, averageSubject: PassthroughSubject<Double, Never>, minSubject: PassthroughSubject<Double, Never>) {
        print("DBUG : RECEIVED INIT 1")
        self.countSubject = countSubject
        self.hitTotalSubject = hitTotalSubject
        self.hitTargetSubject = hitTargetSubject
        self.hitSuccessSubject = hitSuccessSubject
        self.hitPerfectSubject = hitPerfectSubject
        self.hitFailSubject = hitFailSubject
        self.durationSubject = durationSubject
        self.menuStateSubject = menuStateSubject

        self.videoUrlSubject = videoUrlSubject
        self.typeSubject = typeSubject
        self.levelSubject = levelSubject

        self.averageSubject = averageSubject
        self.minSubject = minSubject

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

            if let average = message["average"] as? Double {
                self.averageSubject.send(average)
                print("DBUG : RECEIVED")
                self.averageApp = average
            } else {
                print("There was an error")
            }

            if let min = message["min"] as? Double {
                self.minSubject.send(min)
                print("DBUG : RECEIVED")
                self.minApp = min
            } else {
                print("There was an error")
            }

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

            if let duration = message["duration"] as? String {
                self.durationSubject.send(duration)
                print("DBUG : RECEIVED")
                self.durationApp = duration
            } else {
                print("There was an error")
            }

            if let menuHitState = message["menuState"] as? String {
                self.menuStateSubject.send(menuHitState)
                print("DBUG : RECEIVED", menuHitState)
                self.menuStateApp = menuHitState
                self.menuStateApp2 = menuHitState
                if menuHitState == "result"{
                    //                    self.hitTotalApp = 0
                    //                    self.hitTargetApp = 0
                    //                    self.hitSuccessApp = 0
                    //                    self.hitPerfectApp = 0
                    //                    self.hitFailApp = 0
                }
            } else {
                print("There was an error")
            }
            if self.hitSuccessApp > 0 {
                self.progressApp = Double(self.hitTotalApp) / Double(self.hitTargetApp)

            } else {
                self.progressApp = 0.0
            }
            // print(self.hitSuccessApp)
            // print(self.hitTargetApp)
            // print(self.progressApp)

            if let videoUrl = message["videoUrl"] as? String {
                self.videoUrlSubject.send(videoUrl)
                print("DBUG : RECEIVED")
                self.videoUrlApp = videoUrl
            } else {
                print("There was an error")
            }
            if let type = message["type"] as? String {
                self.typeSubject.send(type)
                print("DBUG : RECEIVED")
                self.typeApp = type
            } else {
                print("There was an error")
            }
            if let level = message["level"] as? String {
                self.levelSubject.send(level)
                print("DBUG : RECEIVED")
                self.levelApp = level
            } else {
                print("There was an error")
            }

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
