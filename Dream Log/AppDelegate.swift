//
//  AppDelegate.swift
//  Dream Log
//
//  Created by Jerry Ding on 2018-05-17.
//  Copyright © 2018 Jerry Ding. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("error initializing realm \(error)")
        }
        
        return true
        
    }

}

