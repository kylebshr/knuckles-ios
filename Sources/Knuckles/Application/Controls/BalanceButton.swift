//
//  BalanceButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/23/20.
//

import UIKit

class BalanceButton: Control {
    enum Style {
        case balance
        case account(name: String)
    }

    private let style: Style

    private let balanceLabel: UILabel
    private let descriptionLabel: UILabel

    private lazy var labelStack = UIStackView(arrangedSubviews: [descriptionLabel, balanceLabel])
    private lazy var containerStack = UIStackView(arrangedSubviews: [labelStack])

    init(style: Style) {
        self.style = style

        descriptionLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), color: .customSecondaryLabel)

        switch style {
        case .balance:
            descriptionLabel.text = "Balance"
            balanceLabel = UILabel(font: .systemFont(ofSize: 35, weight: .bold), color: .brand)
        case .account(let name):
            descriptionLabel.text = name
            balanceLabel = UILabel(font: .systemFont(ofSize: 26, weight: .bold), color: .customTertiaryLabel)
        }

        super.init(frame: .zero)

        display(balance: 0)

        labelStack.axis = .vertical

        containerStack.alignment = .center
        containerStack.spacing = 8

        addSubview(containerStack)
        containerStack.pinEdges(to: self)
    }

    func display(balance: Decimal) {
        let text = balance.currency()
        balanceLabel.text = text

        if case .account = style, text.hasSuffix(".00") {
            balanceLabel.text = String(text.dropLast(3))
        }
    }
}
