//
//  AppDelegate.swift
//  Playground
//
//  Created by zzangzio on 2018. 12. 8..
//  Copyright © 2018년 zzangzio. All rights reserved.
//

import UIKit
import CVSKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = FragileWindow(frame: UIScreen.main.bounds, maximumStress: 1, repeated: true)

        let navigationController = UINavigationController(rootViewController: MainViewController())

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
