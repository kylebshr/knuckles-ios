//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit

class MainViewController: ViewController, UITabBarControllerDelegate {

    private let tabBarViewController = UITabBarController()
    private let balanceViewController: BalanceViewController

    init(user: User) {
        balanceViewController = BalanceViewController(user: user)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarViewController.delegate = self
        add(tabBarViewController)

        let goals = NavigationController(rootViewController: GoalsViewController())
        goals.navigationBar.prefersLargeTitles = true

        let expenses = NavigationController(rootViewController: ExpensesViewController())
        expenses.navigationBar.prefersLargeTitles = true

        let balance = NavigationController(rootViewController: balanceViewController)
        balance.navigationBar.prefersLargeTitles = true

        tabBarViewController.viewControllers = [
            balance,
            expenses,
            goals,
        ]

        tabBarController(tabBarViewController, didSelect: balance)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let nav = viewController as? UINavigationController, let viewController = nav.viewControllers.first else {
            return
        }

        if viewController is BalanceViewController {
            tabBarController.tabBar.backgroundImage = UIImage()
            tabBarController.tabBar.shadowImage = UIImage()
        } else {
            tabBarController.tabBar.backgroundImage = nil
            tabBarController.tabBar.shadowImage = nil
        }
    }
}
