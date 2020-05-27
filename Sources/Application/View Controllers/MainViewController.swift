//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit

class MainViewController: ViewController {

    private let balanceButton = BalanceButton()

    private let expenseViewController = ExpenseViewController()
    private let informationalViewController = InformationalViewController()

    private lazy var cardViewController = CardTransitionViewController(
        mainViewController: informationalViewController,
        secondaryViewController: expenseViewController
    )

    init(user: User) {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(balanceButton)
        balanceButton.display(balance: 892.59)
        balanceButton.pinEdges([.left, .bottom, .right], to: view)
        balanceButton.addTarget(self, action: #selector(toggleView), for: .touchUpInside)

        add(cardViewController) { view in
            self.view.addSubview(view)
            view.pinEdges([.left, .top, .right], to: self.view)
            view.bottomAnchor.pin(to: self.balanceButton.topAnchor)
        }
    }

    @objc private func toggleView() {
        balanceButton.isSelected.toggle()
        if balanceButton.isSelected {
            cardViewController.showSecondaryViewController()
        } else {
            cardViewController.showMainViewController()
        }
    }
}
