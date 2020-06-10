//
//  BalanceController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/9/20.
//

import Combine
import UIKit

class BalanceController {

    static let shared = BalanceController()

    @Published var balance: Decimal = 0

    init() {
        update(balance: UserDefaults.shared.balance)
        refresh(completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func refresh() {
        refresh(completion: nil)
    }

    func refresh(completion: ((ErrorResult<Balance>) -> Void)? = nil) {
        ResourceProvider.shared.fetchResource(at: "balance") { [weak self] (result: ErrorResult<Balance>) in
            guard let self = self else { return }

            switch result {
            case .success(let balance):
                UserDefaults.shared.balance = balance.amount
                self.update(balance: balance.amount)
            default:
                break
            }

            completion?(result)
        }
    }

    private func update(balance: Decimal) {
        let goals = UserDefaults.shared.goals
        let expenses = UserDefaults.shared.expenses

        let period = PayPeriod.weekly(day: 1)

        let goalAmount = goals.reduce(0, { $0 + $1.amountSaved(using: period) })
        let expenseAmount = expenses.reduce(0, { $0 + $1.amountSaved(using: period) })

        self.balance = balance - goalAmount - expenseAmount
    }
}
