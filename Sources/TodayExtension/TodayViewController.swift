//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Kyle Bashour on 6/4/20.
//

import Combine
import UIKit
import NotificationCenter

@objc(TodayViewController)
class TodayViewController: UIViewController, NCWidgetProviding {

    private let amountLabel = UILabel(font: .boldSystemFont(ofSize: 30))

    private var observer: AnyCancellable?

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let descriptionLabel = UILabel(font: .systemFont(ofSize: 15), color: .secondaryLabel)
        descriptionLabel.text = "cash available"

        let stackView = UIStackView(arrangedSubviews: [amountLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 2

        view.addSubview(stackView)
        stackView.pinEdges([.left, .right], to: view.layoutMarginsGuide)
        stackView.centerYAnchor.pin(to: view.centerYAnchor)

        preferredContentSize.height = 200

        observer = BalanceController.shared.$balance.sink(receiveValue: update)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        amountLabel.setFlashing(true)
        BalanceController.shared.refresh { [weak self] in
            self?.amountLabel.setFlashing(false)
            completionHandler(.newData)
        }
    }

    private func update(amount: Decimal) {
        amountLabel.text = NumberFormatter.currency.string(from: amount as NSNumber)
    }
}
