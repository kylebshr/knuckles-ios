//
//  BalanceButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/23/20.
//

import UIKit

class BalanceButton: Control {
    private let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)

    private let balanceLabel = UILabel(font: .rubik(ofSize: 32, weight: .medium))
    private let descriptionLabel = UILabel(font: .rubik(ofSize: 14, weight: .regular), color: .secondaryLabel)

    private lazy var labelStack = UIStackView(arrangedSubviews: [balanceLabel, descriptionLabel])
    private lazy var containerStack = UIStackView(arrangedSubviews: [labelStack])

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .customBackground

        display(balance: 0)
        descriptionLabel.text = "cash available"

        labelStack.axis = .vertical
        labelStack.spacing = 4

        containerStack.alignment = .center
        containerStack.spacing = 8

        addSubview(containerStack)
        containerStack.pinEdges(to: self)
    }

    func display(balance: Decimal) {
        balanceLabel.text = balance.currency()
    }
}
