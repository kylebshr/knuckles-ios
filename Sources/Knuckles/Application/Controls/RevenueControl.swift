//
//  RevenueControl.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/18/20.
//

import UIKit

class RevenueControl: UIView {

    enum Direction {
        case income
        case payment
    }

    private static let font = UIFont.systemFont(ofSize: 14, weight: .semibold)

    private let icon = UIImageView()
    private lazy var amountLabel = UILabel(font: Self.font, color: .customTertiaryLabel)
    private lazy var secondaryLabel = UILabel(font: Self.font, color: .customTertiaryLabel)

    init(direction: Direction) {
        let config = UIImage.SymbolConfiguration(font: Self.font)

        switch direction {
        case .income: icon.image = UIImage(systemName: "arrow.down.left", withConfiguration: config)
        case .payment: icon.image = UIImage(systemName: "arrow.up.right", withConfiguration: config)
        }

        super.init(frame: .zero)

        icon.tintColor = .brand
        icon.setHuggingAndCompression(to: .required)

        let stackView = UIStackView(arrangedSubviews: [amountLabel, icon, secondaryLabel])
        addSubview(stackView)
        stackView.pinEdges(to: self)
        stackView.alignment = .firstBaseline
        stackView.spacing = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var forFirstBaselineLayout: UIView {
        amountLabel
    }

    func display(amount: Decimal, text: String) {
        amountLabel.text = amount.currency()
        secondaryLabel.text = text
    }
}
