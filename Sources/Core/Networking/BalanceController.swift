//
//  BalanceController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/9/20.
//

import Combine
import UIKit

class BalanceController {
    struct BalanceState {
        var balance: Decimal
        var account: Decimal
        var expenses: Decimal
        var goals: Decimal
    }

    static let shared = BalanceController()

    @Published var balance: BalanceState = BalanceState(balance: 0, account: 0, expenses: 0, goals: 0)

    private var expensesObservation: NSKeyValueObservation?
    private var lastUpdate = Date(timeIntervalSince1970: 0)

    init() {
        update(account: UserDefaults.shared.account)
        refresh(completion: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.didBecomeActiveNotification, object: nil)

        expensesObservation = UserDefaults.shared.observe(\.expenses, changeHandler: { [weak self] _, _ in
            self?.update(account: UserDefaults.shared.account)
        })
    }

    @objc private func refresh() {
        refresh(completion: nil)
    }

    func refresh(completion: ((Bool) -> Void)? = nil) {
        guard Date().timeIntervalSince(lastUpdate) > 60 else {
            completion?(false)
            return
        }

        ResourceProvider.shared.fetchResource(at: "balance") { [weak self] (result: ErrorResult<Balance>) in
            guard let self = self else { return }

            switch result {
            case .success(let balance):
                UserDefaults.shared.account = balance.amount
                self.update(account: balance.amount)
                self.lastUpdate = Date()
                completion?(true)
            default:
                completion?(false)
            }
        }
    }

    private func update(account: Decimal) {
        let goals = UserDefaults.shared.goals
        let expenses = UserDefaults.shared.expenses

        let period = PayPeriod.current

        let goalAmount = goals.reduce(0, { $0 + $1.amountSaved(using: period) })
        let expenseAmount = expenses.reduce(0, { $0 + $1.amountSaved(using: period) })

        let balance = account - goalAmount - expenseAmount
        self.balance = .init(balance: balance, account: account, expenses: expenseAmount, goals: goalAmount)
    }
}
