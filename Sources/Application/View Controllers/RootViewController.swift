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

//        let expenseViewController = ExpenseViewController()
//        let informationalViewController = InformationalViewController()
//
//        let cardViewController = CardTransitionViewController(
//            mainViewController: informationalViewController,
//            secondaryViewController: expenseViewController
//        )

        add(ExpenseAmountViewController())
    }
}
