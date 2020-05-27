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
    private let arrowView = UIImageView()

    private lazy var labelStack = UIStackView(arrangedSubviews: [balanceLabel, descriptionLabel])
    private lazy var containerStack = UIStackView(arrangedSubviews: [labelStack, arrowView])

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutMargins = .init(all: 36)
        backgroundColor = .customBackground

        display(balance: 0)
        descriptionLabel.text = "cash available"

        arrowView.tintColor = .customBlue
        arrowView.setHuggingAndCompression(to: .required)

        labelStack.axis = .vertical
        labelStack.spacing = 4

        containerStack.alignment = .center
        containerStack.spacing = 8

        addSubview(containerStack)
        containerStack.pinEdges(to: layoutMarginsGuide)
    }

    func display(balance: Decimal) {
        balanceLabel.text = NumberFormatter.currency.string(from: balance as NSNumber)
    }

    override func updateState() {
        if isSelected {
            labelStack.alignment = .trailing
            containerStack.insertArrangedSubview(arrowView, at: 0)
            arrowView.image = UIImage(systemName: "arrow.left.circle", withConfiguration: config)
        } else {
            labelStack.alignment = .leading
            containerStack.addArrangedSubview(arrowView)
            arrowView.image = UIImage(systemName: "arrow.right.circle", withConfiguration: config)
        }

        alpha = isHighlighted ? 0.3 : 1

        setNeedsLayout()
        layoutIfNeeded()
    }
}
