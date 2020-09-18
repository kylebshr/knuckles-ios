//
//  InformationalViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import Combine
import UIKit

class InformationalViewController: ViewController, TabbedViewController {
    var scrollView: UIScrollView? { nil }
    var tabItem: TabBarItem = .text("$0")

        private let balanceButton = BalanceButton()

    private var observer: AnyCancellable?

    init(user: User) {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 35

        view.addSubview(stackView)
        stackView.pinEdges(to: view.layoutMarginsGuide)

        let topView = UIView()
        stackView.addArrangedSubview(topView)

        balanceButton.display(balance: 0)
        stackView.addArrangedSubview(balanceButton)

        let middleView = UIView()
        stackView.addArrangedSubview(middleView)
        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.6)

        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(logout))

        observer = BalanceController.shared.$balance.sink(receiveValue: update)
    }

    @objc private func logout() {
        UserDefaults.shared.logout()
    }

    @objc private func update(amount: Decimal) {
        balanceButton.display(balance: amount)
        tabItem = .text("$" + amount.abbreviated())
        parent(ofType: TabBarController.self)?.updateTabs()
    }
}
