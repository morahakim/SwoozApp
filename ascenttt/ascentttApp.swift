//
//  ascentttApp.swift
//  ascenttt
//
//  Created by Aang Muammar Zein on 31/10/23.
//

import SwiftUI
import HealthKit

@main
struct ascentttApp: App {
    private let dataController = DataController.shared
    private let healthStore: HKHealthStore
    
    init() {
            guard HKHealthStore.isHealthDataAvailable() else {  fatalError("This app requires a device that supports HealthKit") }
            healthStore = HKHealthStore()
            requestHealthkitPermissions()
        }
    
    
    private func requestHealthkitPermissions() {
            
            let sampleTypesToRead = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
            ])
            
            healthStore.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
                print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
            }
        }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let contentAnalysisViewController = ContentAnalysisViewController()
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(healthStore)
                .onAppear {
                    contentAnalysisViewController.counter.menuStateSend(menuState: "")
                    contentAnalysisViewController.counter.typeSend(type: "")
                    contentAnalysisViewController.counter.levelSend(level: "")
                    UIDevice.current.setValue(
                        UIInterfaceOrientation.portrait.rawValue,
                        forKey: "orientation"
                    )
                    AppDelegate.orientationLock = .portrait
                }
                .preferredColorScheme(.light)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension HKHealthStore: ObservableObject{}
