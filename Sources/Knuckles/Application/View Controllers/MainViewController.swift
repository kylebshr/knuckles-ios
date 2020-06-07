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

        let goals = UINavigationController(rootViewController: GoalsViewController())
        goals.setNavigationBarHidden(true, animated: false)

        let expenses = UINavigationController(rootViewController: ExpenseViewController())
        expenses.setNavigationBarHidden(true, animated: false)

        tabBarViewController.viewControllers = [
            informationalViewController,
            expenses,
            goals,
        ]
    }
}
