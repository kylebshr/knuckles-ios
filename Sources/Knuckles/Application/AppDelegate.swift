//
//  AppDelegate.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/25/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit
import WidgetKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var stateAtBecomeActive: BalanceState?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.brand]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.brand]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.customLabel]
        appearance.buttonAppearance = buttonAppearance

        UINavigationBar.appearance().standardAppearance = appearance

        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.brand]
        scrollAppearance.titleTextAttributes = [.foregroundColor: UIColor.customLabel]
        scrollAppearance.buttonAppearance = buttonAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollAppearance

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        stateAtBecomeActive = BalanceController.shared.balance
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if BalanceController.shared.balance != stateAtBecomeActive {
            if #available(iOS 14.0, *) {
                print("Reloading timelines")
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
