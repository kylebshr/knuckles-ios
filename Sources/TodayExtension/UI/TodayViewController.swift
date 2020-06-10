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

    private let button = TodayBalanceButton()

    private var observer: AnyCancellable?

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
        button.addTarget(self, action: #selector(openApplication), for: .touchUpInside)

        preferredContentSize.height = 200
        observer = BalanceController.shared.$balance.sink(receiveValue: update)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = view.bounds.inset(by: view.layoutMargins)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        button.setLoading(true)
        BalanceController.shared.refresh { [weak self] _ in
            self?.button.setLoading(false)
            completionHandler(.newData)
        }
    }

    private func update(amount: Decimal) {
        button.display(balance: amount)
    }

    @objc private func openApplication() {
        let url = URL(stringLiteral: "balance://")
        extensionContext?.open(url, completionHandler: nil)
    }
}
