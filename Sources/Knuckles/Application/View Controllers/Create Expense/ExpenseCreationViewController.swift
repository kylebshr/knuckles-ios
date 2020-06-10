//
//  ExpenseCreationViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseCreationViewController: UIViewController {

    private lazy var nameViewController = ExpenseNameViewController()
    private lazy var amountViewController = ExpenseAmountViewController()
    private lazy var dateViewController = ExpenseDueDateViewController()
    private lazy var navigationContainer = PagingNavigationController(rootViewController: nameViewController)

    private var name: String!
    private var amount: Decimal!
    private var day: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameViewController.didEnterName = { [weak self] name in
            self?.enterName(name)
        }

        add(navigationContainer)
        addCloseButton()
    }

    private func addCloseButton() {
        let closeButton = UIButton(type: .system)
        view.addSubview(closeButton)
        closeButton.tintColor = .label
        closeButton.pinEdges([.right, .top], to: view.layoutMarginsGuide, insets: .init(vertical: 38, horizontal: 0))
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    private func enterName(_ name: String) {
        self.name = name
        navigationContainer.pushViewController(amountViewController, animated: true)
        amountViewController.didEnterAmount = { [weak self] amount in
            self?.enterAmount(amount)
        }
    }

    private func enterAmount(_ amount: Decimal) {
        self.amount = amount
        navigationContainer.pushViewController(dateViewController, animated: true)
        dateViewController.didEnterDay = { [weak self] day in
            self?.enterDay(day)
        }
    }

    private func enterDay(_ day: Int) {
        let expense = Expense(emoji: "🐮", name: name, amount: amount, dayDueAt: day)
        UserDefaults.shared.expenses.append(expense)
        close()
    }
}
