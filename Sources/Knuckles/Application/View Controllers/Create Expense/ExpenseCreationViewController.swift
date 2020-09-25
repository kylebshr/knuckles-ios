//
//  ExpenseCreationViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseCreationViewController: ViewController {

    private lazy var nameViewController = ExpenseNameViewController()
    private lazy var amountViewController = ExpenseAmountViewController()
    private lazy var dateViewController = ExpenseDueDateViewController()
    private lazy var navigationContainer = PagingNavigationController(rootViewController: nameViewController)

    private var name: String!
    private var amount: Decimal!
    private var day: Int!

    override init() {
        super.init()

        isModalInPresentation = true

        navigationContainer.setNavigationBarHidden(false, animated: false)

        nameViewController.navigationItem.rightBarButtonItem = makeItem()
        nameViewController.didEnterName = { [weak self] name in
            self?.enterName(name)
        }

        add(navigationContainer)

        view.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = self
    }

    private func enterName(_ name: String) {
        self.name = name
        amountViewController.navigationItem.rightBarButtonItem = makeItem()
        navigationContainer.pushViewController(amountViewController, animated: true)
        amountViewController.didEnterAmount = { [weak self] amount in
            self?.enterAmount(amount)
        }
    }

    private func enterAmount(_ amount: Decimal) {
        self.amount = amount
        dateViewController.navigationItem.rightBarButtonItem = makeItem()
        navigationContainer.pushViewController(dateViewController, animated: true)
        dateViewController.didEnterDay = { [weak self] day in
            self?.enterDay(day)
        }
    }

    private func enterDay(_ day: Int) {
        let expense = Expense(name: name, amount: amount, dayDueAt: day)
        let viewController = ExpenseConfirmationViewController(expense: expense)
        viewController.navigationItem.rightBarButtonItem = makeItem()
        navigationContainer.pushViewController(viewController, animated: true)
        viewController.didConfirm = { [weak self] in
            self?.confirm(expense: expense)
        }
    }

    private func confirm(expense: Expense) {
        UserDefaults.shared.expenses.append(expense)
        dismissAnimated()
    }

    private func makeItem() -> UIBarButtonItem {
        .init(barButtonSystemItem: .close, target: self, action: #selector(presentDismiss))
    }

    @objc private func presentDismiss() {
        let sheet = UIAlertController(title: "Delete this expense?", message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(sheet, animated: true, completion: nil)
    }
}

extension ExpenseCreationViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        presentDismiss()
    }
}
