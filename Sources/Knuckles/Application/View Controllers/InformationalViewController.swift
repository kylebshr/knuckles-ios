//
//  InformationalViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import Combine
import UIKit

class InformationalViewController: ViewController {
    private let balanceView = BalanceButton(style: .balance)
    private let accountView = BalanceButton(style: .account(name: "Account"))
    private let expensesView = BalanceButton(style: .account(name: "Expenses"))
    private let goalsView = BalanceButton(style: .account(name: "Goals"))

    private var observer: AnyCancellable?

    init(user: User) {
        super.init()
        tabBarItem = UITabBarItem(title: "Goals", image: nil, tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = UIStackView(arrangedSubviews: [accountView, expensesView, goalsView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .leading

        view.addSubview(stackView)
        stackView.pinEdges([.left, .right], to: view.layoutMarginsGuide)
        stackView.pinCenter(to: view.layoutMarginsGuide)

        navigationController?.navigationBar.layoutMargins = view.layoutMargins
        navigationController!.navigationBar.addSubview(balanceView)
        balanceView.pinEdges([.left, .bottom], to: navigationController!.navigationBar.layoutMarginsGuide)

        observer = BalanceController.shared.$balance.sink(receiveValue: update)
    }

    @objc private func logout() {
        UserDefaults.shared.logout()
    }

    private func update(amount: BalanceController.BalanceState) {
        tabBarItem = UITabBarItem(amount: amount.balance)
        balanceView.display(balance: amount.balance)
        accountView.display(balance: amount.account)
        expensesView.display(balance: amount.expenses)
        goalsView.display(balance: amount.goals)
    }
}

private extension UITabBarItem {

    private static let label = UILabel(font: .systemFont(ofSize: 20, weight: .bold))

    convenience init(amount: Decimal) {
        Self.label.text = "$\(amount.abbreviated())"
        Self.label.sizeToFit()

        let image = UIGraphicsImageRenderer(bounds: Self.label.bounds).image { context in
            Self.label.layer.render(in: context.cgContext)
        }

        self.init(title: "", image: image, tag: 0)
    }

}
