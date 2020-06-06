//
//  InformationalViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import UIKit

class InformationalViewController: ViewController, TabbedViewController {
    var scrollView: UIScrollView? { nil }
    var tabItem: TabBarItem = .text("$ 0")
    weak var tabDelegate: TabbedViewControllerDelegate?

    private let navigationView = NavigationView()
    private let balanceButton = BalanceButton()

    init(user: User) {
        super.init()
        navigationView.text = "Hello, \(user.name)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.layoutMargins = UIEdgeInsets(all: 36)

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

        let label = UILabel()
        label.numberOfLines = 0
        label.font = .rubik(ofSize: 36, weight: .bold)

        let string = "What if you could change the world with just your mind?"
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 36 * 1.3
        paragraphStyle.maximumLineHeight = 36 * 1.3

        attributedString.addAttribute(.foregroundColor, value: UIColor.customBlue,
                                      range: (string as NSString).range(of: "change the world"))
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))

        label.attributedText = attributedString
        stackView.addArrangedSubview(label)

        let middleView = UIView()
        stackView.addArrangedSubview(middleView)
        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.6)

        balanceButton.display(balance: 0)
        stackView.addArrangedSubview(balanceButton)

        view.addSubview(navigationView)
        navigationView.pinEdges([.left, .top, .right], to: view)
        navigationView.action = .init(symbolName: "person", onTap: {
            UserDefaults.standard.logout()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    @objc private func refresh() {
        ResourceProvider.shared.fetchResource(at: "balance") { [weak self] (result: Res<Balance>) in
            switch result {
            case .success(let balance):
                self?.balanceButton.display(balance: balance.amount)
                self?.tabItem = .text("$" + balance.amount.abbreviated())
                self?.tabDelegate?.updateTabs()
            default: break
            }
        }
    }
}