//
//  BalanceButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/23/20.
//

import UIKit

class BalanceButton: Control {
    private let balanceLabel = UILabel(font: .systemFont(ofSize: 38), color: .brand)
    private let descriptionLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), color: .customSecondaryLabel)

    private lazy var labelStack = UIStackView(arrangedSubviews: [descriptionLabel, balanceLabel])
    private lazy var containerStack = UIStackView(arrangedSubviews: [labelStack])

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .customBackground

        display(balance: 0)
        descriptionLabel.text = "Balance"

        labelStack.axis = .vertical

        containerStack.alignment = .center
        containerStack.spacing = 8

        addSubview(containerStack)
        containerStack.pinEdges(to: self)
    }

    func display(balance: Decimal) {
        balanceLabel.text = balance.currency()
    }
}
