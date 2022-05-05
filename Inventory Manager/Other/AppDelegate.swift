//
//  AppDelegate.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 18/09/2019.
//  Copyright © 2019 A. All rights reserved.
//

import UIKit
import Firebase

 var Dependencies: AppDependencies!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        loadView()
        return true
    }
    
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        
        guard let itemID = url.host else { return false }
        appCoordinator?.openDetailsForCode(code: itemID)
        return true
    }

}

private extension AppDelegate {
    func loadView() {
        let initialController = WireFrames.getMainNavigationController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialController
        appCoordinator = AppCoordinator(mainNavigationController: initialController)
        self.window?.makeKeyAndVisible()
    }
}

