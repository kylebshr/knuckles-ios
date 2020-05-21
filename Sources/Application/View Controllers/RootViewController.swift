//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = ExpenseViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        add(navigationController)
    }
}
