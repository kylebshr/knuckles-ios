//
//  BalanceController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/9/20.
//

import Combine
import UIKit
import WidgetKit

struct BalanceState: Equatable {
    var account: Decimal
    var expenses: [Expense]
    var goals: [Goal]

    func balance(using period: PayPeriod) -> Decimal {
        account - goalsAmount(using: period) - expensesAmount(using: period)
    }

    func goalsAmount(using period: PayPeriod) -> Decimal {
        goals.reduce(0, { $0 + $1.amountSaved(using: period) })
    }

    func expensesAmount(using period: PayPeriod) -> Decimal {
        expenses.reduce(0, { $0 + $1.amountSaved(using: period) })
    }
}

class BalanceController: ObservableObject {

    static let shared = BalanceController()

    @Published var balance: BalanceState?

    private var expensesObservation: NSKeyValueObservation?
    private var lastUpdate = Date(timeIntervalSince1970: 0)

    init() {
        update(account: UserDefaults.shared.account)
        refresh(completion: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateIfPossible), name: UserDefaults.didChangeNotification, object: nil)
    }

    @objc private func refresh() {
        refresh(completion: nil)
    }

    func refresh(completion: ((Bool) -> Void)? = nil) {
        guard Date().timeIntervalSince(lastUpdate) > 60 else {
            completion?(false)
            return
        }

        self.lastUpdate = Date()

        ResourceProvider.shared.fetchResource(at: "balance") { [weak self] (result: ErrorResult<Balance>) in
            guard let self = self else { return }

            print("Got balance")

            switch result {
            case .success(let balance):
                UserDefaults.shared.account = balance.amount
                self.update(account: balance.amount)
                completion?(true)
            default:
                completion?(false)
            }
        }
    }

    @objc private func updateIfPossible() {
        guard let account = balance?.account else {
            return
        }

        update(account: account)
    }

    private func update(account: Decimal) {
        let goals = UserDefaults.shared.goals
        let expenses = UserDefaults.shared.expenses
        let balance = BalanceState(account: account, expenses: expenses, goals: goals)

        guard self.balance != balance else { return }

        self.balance = balance

        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
