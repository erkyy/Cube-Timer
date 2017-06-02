//
//  AppDelegate.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-19.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        print("Application launched!")
        
        guard var timesKey = UserDefaults.standard.stringArray(forKey: Key.times) else { return true }
        guard var scrambleKey = UserDefaults.standard.stringArray(forKey: Key.scramble) else { return true }
        guard var dateKey = UserDefaults.standard.stringArray(forKey: Key.date) else { return true }
        guard var timeKey = UserDefaults.standard.stringArray(forKey: Key.time) else { return true }
            
        for time in timesKey {
            GlobalTimes.times.append(time)
        }
        
        for scramble in scrambleKey {
            GlobalTimes.scramble.append(scramble)
        }
        
        for date in dateKey {
            GlobalTimes.date.append(date)
        }
        
        for time in timeKey {
            GlobalTimes.time.append(time)
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

}

