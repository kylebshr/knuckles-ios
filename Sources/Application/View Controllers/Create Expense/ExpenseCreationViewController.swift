//
//  ExpenseCreationViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseCreationViewController: UIViewController {

    private let expenseNameViewController = ExpenseNameViewController()
    private lazy var nav = SlideNavigationController(rootViewController: expenseNameViewController)

    override func viewDidLoad() {
        super.viewDidLoad()
        add(nav)
    }
}
