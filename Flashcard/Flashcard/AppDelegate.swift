//
//  AppDelegate.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/19/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Crashlytics
import Alamofire
import SwiftyTimer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
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
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Take A Sip
        Coffee.sip()
        
        // Return From Fetch, random time with random results.
        Timer.after(randomDouble(min: 1.6, max: 3.2)) {
            completionHandler(Bool(randomInt(min: 0, max: 1) as NSNumber) ? .newData : .noData)
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {
        Coffee.stop()
        Session.save()
    }
}

