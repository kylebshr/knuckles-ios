//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit

class MainViewController: ViewController {

    private let expenseViewController = ExpenseViewController()
    private let informationalViewController: InformationalViewController

    init(user: User) {
        self.informationalViewController = InformationalViewController(user: user)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(expenseViewController)
    }
}
