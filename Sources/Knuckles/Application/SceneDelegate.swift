//
//  SceneDelegate.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/25/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var stateAtBecomeActive: BalanceState?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        window = PrivateWindow(windowScene: scene)

        let viewController = RootViewController()

        window?.tintColor = .emphasis
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        stateAtBecomeActive = BalanceController.shared.balance
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if #available(iOS 14.0, *), stateAtBecomeActive != BalanceController.shared.balance {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
