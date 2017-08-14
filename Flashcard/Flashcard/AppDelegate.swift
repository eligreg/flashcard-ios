//
//  AppDelegate.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/19/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Token.load()
        Coffee.start()
        Session.restore()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Coffee.stop()
        Session.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {
        Coffee.start()
        Session.restore()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {
        Coffee.stop()
        Session.save()
    }
}

