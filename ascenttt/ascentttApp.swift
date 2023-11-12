//
//  ascentttApp.swift
//  ascenttt
//
//  Created by Aang Muammar Zein on 31/10/23.
//

import SwiftUI

@main
struct ascentttApp: App {
    private let dataController = DataController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let contentAnalysisViewController = ContentAnalysisViewController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
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
