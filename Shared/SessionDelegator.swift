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

    func processAverageValue(message: [String: Any]) {
        if let average = message["average"] as? Double {
            self.averageSubject.send(average)
            print("DBUG : RECEIVED")
            self.averageApp = average
        } else {
            print("There was an error")
        }
    }

    func processMinValue(message: [String: Any]) {
        if let min = message["min"] as? Double {
            self.minSubject.send(min)
            print("DBUG : RECEIVED")
            self.minApp = min
        } else {
            print("There was an error")
        }
    }

    func processCountValue(message: [String: Any]) {
        if let count = message["count"] as? Int {
            self.countSubject.send(count)
            print("DBUG : RECEIVED")
        } else {
            print("There was an error")
        }
    }

    func processHitTotalValue(message: [String: Any]) -> Int {
        if let hitTotal = message["hitTotal"] as? Int {
            self.hitTotalSubject.send(hitTotal)
            print("DBUG : RECEIVED")
            return hitTotal
        } else {
            print("There was an error")
            return 0
        }
    }

    func processHitTargetValue(message: [String: Any]) -> Int {
        if let hitTarget = message["hitTarget"] as? Int {
            self.hitTargetSubject.send(hitTarget)
            print("DBUG : RECEIVED")
            return hitTarget
        } else {
            print("There was an error")
            return 0
        }
    }

    func processHitSuccessValue(message: [String: Any]) -> Int {
        if let hitSuccess = message["hitSuccess"] as? Int {
            self.hitSuccessSubject.send(hitSuccess)
            print("DBUG : RECEIVED")
            return hitSuccess
        } else {
            print("There was an error")
            return 0
        }
    }

    func processHitPerfectValue(message: [String: Any]) {
        if let hitPerfect = message["hitPerfect"] as? Int {
            self.hitPerfectSubject.send(hitPerfect)
            print("DBUG : RECEIVED")
            self.hitPerfectApp = hitPerfect
        } else {
            print("There was an error")
        }
    }

    func processHitFailValue(message: [String: Any]) {
        if let hitFail = message["hitFail"] as? Int {
            self.hitFailSubject.send(hitFail)
            print("DBUG : RECEIVED")
            self.hitFailApp = hitFail
        } else {
            print("There was an error")
        }
    }

    func processDurationValue(message: [String: Any]) {
        if let duration = message["duration"] as? String {
            self.durationSubject.send(duration)
            print("DBUG : RECEIVED")
            self.durationApp = duration
        } else {
            print("There was an error")
        }
    }

    func processMenuHitStateValue(message: [String: Any]) {
        if let menuHitState = message["menuState"] as? String {
            self.menuStateSubject.send(menuHitState)
            print("DBUG : RECEIVED", menuHitState)
            self.menuStateApp = menuHitState
            self.menuStateApp2 = menuHitState
            if menuHitState == "result"{
            }
        } else {
            print("There was an error")
        }
    }

    func processVideoUrlValue(message: [String: Any]) {
        if let videoUrl = message["videoUrl"] as? String {
            self.videoUrlSubject.send(videoUrl)
            print("DBUG : RECEIVED")
            self.videoUrlApp = videoUrl
        } else {
            print("There was an error")
        }
    }

    func processTypeValue(message: [String: Any]) {
        if let type = message["type"] as? String {
            self.typeSubject.send(type)
            print("DBUG : RECEIVED")
            self.typeApp = type
        } else {
            print("There was an error")
        }
    }

    func processLevelValue(message: [String: Any]) {
        if let level = message["level"] as? String {
            self.levelSubject.send(level)
            print("DBUG : RECEIVED")
            self.levelApp = level
        } else {
            print("There was an error")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("DBUG : RECEIVED INIT 3")
        DispatchQueue.main.async {
            self.processAverageValue(message: message)
            self.processMinValue(message: message)
            self.processCountValue(message: message)
            self.hitTotalApp = self.processHitTotalValue(message: message)
            self.hitTargetApp = self.processHitTargetValue(message: message)
            self.hitSuccessApp = self.processHitSuccessValue(message: message)
            self.processHitPerfectValue(message: message)
            self.processHitFailValue(message: message)
            self.processDurationValue(message: message)
            self.processMenuHitStateValue(message: message)

            if self.hitSuccessApp > 0 {
                self.progressApp = Double(self.hitTotalApp) / Double(self.hitTargetApp)

            } else {
                self.progressApp = 0.0
            }

            self.processVideoUrlValue(message: message)
            self.processTypeValue(message: message)
            self.processLevelValue(message: message)
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
