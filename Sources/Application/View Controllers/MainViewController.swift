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
    private let expenseViewController: ExpenseViewController
    private let informationalViewController: InformationalViewController

    init(user: User) {
        informationalViewController = InformationalViewController(user: user)
        expenseViewController = ExpenseViewController()
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(tabBarViewController)

        tabBarViewController.viewControllers = [
            informationalViewController,
            expenseViewController,
            GoalsViewController(),
        ]
    }
}
