//
//  BalanceButton.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/23/20.
//

import UIKit

class TodayBalanceButton: Control {
    private let balanceLabel = UILabel(font: .rubik(ofSize: 32, weight: .medium))
    private let descriptionLabel = UILabel(font: .rubik(ofSize: 14, weight: .regular), color: .secondaryLabel)

    private lazy var labelStack = UIStackView(arrangedSubviews: [balanceLabel, descriptionLabel])
    private lazy var containerStack = UIStackView(arrangedSubviews: [labelStack])

    override init(frame: CGRect) {
        super.init(frame: frame)

        display(balance: 0)
        descriptionLabel.text = "cash available"

        labelStack.axis = .vertical
        labelStack.spacing = 2

        containerStack.alignment = .center

        addSubview(containerStack)
        containerStack.pinEdges(to: self)
    }

    func display(balance: Decimal) {
        balanceLabel.text = NumberFormatter.currency.string(from: balance as NSNumber)
    }

    func setLoading(_ isLoading: Bool) {
        balanceLabel.setFlashing(isLoading)
    }

    override func updateState() {
        alpha = isHighlighted ? 0.3 : 1
    }
}
