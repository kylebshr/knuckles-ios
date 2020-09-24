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
    private lazy var amountLabel = UILabel(font: Self.font, color: .customSecondaryLabel)
    private lazy var secondaryLabel = UILabel(font: Self.font, color: .customSecondaryLabel)

    init(direction: Direction) {
        let config = UIImage.SymbolConfiguration(font: Self.font)

        switch direction {
        case .income: icon.image = UIImage(systemName: "arrow.down.left", withConfiguration: config)
        case .payment: icon.image = UIImage(systemName: "arrow.up.right", withConfiguration: config)
        }

        super.init(frame: .zero)

        icon.tintColor = .brand

        let stackView = UIStackView(arrangedSubviews: [amountLabel, icon, secondaryLabel])
        addSubview(stackView)
        stackView.pinEdges(to: self)
        stackView.alignment = .center
        stackView.spacing = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(amount: Decimal, text: String) {
        amountLabel.text = amount.currency()
        secondaryLabel.text = text
    }
}
