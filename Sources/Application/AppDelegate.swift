//
//  AppDelegate.swift
//  StepTimer
//
//  Created by Kyle Bashour on 4/25/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"

        let expense1 = Expense(createdAt: Date(), dayDueAt: 18, amount: 100)
        print(formatter.string(from: expense1.nextDueDate))

        let expense2 = Expense(createdAt: Date(), dayDueAt: 12, amount: 100)
        print(formatter.string(from: expense2.nextDueDate))

        let expense3 = Expense(createdAt: Date(), dayDueAt: 8, amount: 100)
        print(formatter.string(from: expense3.nextDueDate))

        let expense4 = Expense(createdAt: Date(), dayDueAt: 5, amount: 100)
        print(formatter.string(from: expense4.nextDueDate))

        return true
    }
}
