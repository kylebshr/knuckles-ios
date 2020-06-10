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

        UIColor.swizzleColors

        if UserDefaults.shared.goals.isEmpty {
            UserDefaults.shared.goals = [
                Goal(emoji: "🌯", name: "Burrito Party", amount: 250, dayDueAt: "06/01/2020", createdAt: "05/01/2020"),
                Goal(emoji: "🏠", name: "House", amount: 5000, dayDueAt: "08/15/2020", createdAt: "01/01/2020"),
            ]
        }

        return true
    }
}

extension Date: ExpressibleByStringLiteral {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    public init(stringLiteral: String) {
        self = Date.formatter.date(from: stringLiteral)!
    }
}
