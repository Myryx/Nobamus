//
//  AppDelegate.swift
//  Nobamus
//
//  Created by Yanislav Kononov on 5/7/17.
//  Copyright © 2017 Yanislav Kononov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        let selfController = SelfViewController(LoginAppleMusicProvider())
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        let navigationController = UINavigationController(rootViewController: selfController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        MusicProvider.appIsAboutToGoBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        MusicProvider.appIsAboutToGoForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        MusicProvider.pausePlaying()
    }
}
