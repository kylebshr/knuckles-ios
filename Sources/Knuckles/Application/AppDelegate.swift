//
//  AppDelegate.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/25/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.customSecondaryLabel]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.brand]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.customSecondaryLabel]
        appearance.buttonAppearance = buttonAppearance

        UINavigationBar.appearance().standardAppearance = appearance

        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.brand]
        scrollAppearance.titleTextAttributes = [.foregroundColor: UIColor.customSecondaryLabel]
        scrollAppearance.buttonAppearance = buttonAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollAppearance

        return true
    }
}
