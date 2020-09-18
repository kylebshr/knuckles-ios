//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit

class MainViewController: ViewController {

    private let tabBarViewController = TabBarController()
    private let informationalViewController: InformationalViewController

    init(user: User) {
        informationalViewController = InformationalViewController(user: user)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(tabBarViewController)

        let goals = NavigationController(rootViewController: GoalsViewController())
        goals.navigationBar.prefersLargeTitles = true

        let expenses = NavigationController(rootViewController: ExpensesViewController())
        expenses.navigationBar.prefersLargeTitles = true

        let information = NavigationController(rootViewController: informationalViewController)
        information.navigationBar.prefersLargeTitles = true

        tabBarViewController.viewControllers = [
            information,
            expenses,
            goals,
        ]
    }
}
