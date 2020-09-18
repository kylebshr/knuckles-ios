//
//  InformationalViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import Combine
import UIKit

class InformationalViewController: ViewController, TabbedViewController {
    var tabItem: TabBarItem = .text("$0")

    private let balanceButton = BalanceButton()

    private var observer: AnyCancellable?

    init(user: User) {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let container = UIView()
        container.layer.cornerRadius = 20
        container.layer.cornerCurve = .continuous
        container.layer.borderColor = UIColor.customLabel.withAlphaComponent(0.5).cgColor
        container.layer.borderWidth = .pixel

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
        container.addSubview(balanceButton)
        balanceButton.pinEdges([.left, .right, .top], to: container, insets: .init(all: 18))
        container.widthAnchor.pin(to: container.heightAnchor, multiplier: 1.6)

        stackView.addArrangedSubview(container)

        let middleView = UIView()
        stackView.addArrangedSubview(middleView)
        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 2)

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
