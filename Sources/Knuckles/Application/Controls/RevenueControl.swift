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

    private let icon = UIImageView()
    private let label = UILabel(font: .systemFont(ofSize: 14, weight: .semibold), color: .customTertiaryLabel)

    init(direction: Direction) {
        let config = UIImage.SymbolConfiguration(font: label.font)

        switch direction {
        case .income: icon.image = UIImage(systemName: "arrow.down.left", withConfiguration: config)
        case .payment: icon.image = UIImage(systemName: "arrow.up.right", withConfiguration: config)
        }

        super.init(frame: .zero)

        icon.tintColor = UIColor.brand.withAlphaComponent(0.7)
        icon.setHuggingAndCompression(to: .required)

        let stackView = UIStackView(arrangedSubviews: [icon, label])
        addSubview(stackView)
        stackView.pinEdges(to: self)
        stackView.alignment = .firstBaseline
        stackView.spacing = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var forFirstBaselineLayout: UIView {
        label
    }

    func display(amount: Decimal, period: String) {
        label.text = "\(amount.currency())/\(period)"
    }
}
