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
        
        guard let timesKey = UserDefaults.standard.stringArray(forKey: Key.times) else { return true }
        
        for timeKey in timesKey {
            timesGlobal.append(timeKey)
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

