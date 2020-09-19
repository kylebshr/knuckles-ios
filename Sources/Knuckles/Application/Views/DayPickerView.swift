//
//  DayPickerView.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class DayPickerView: UIView {
    private var buttons: [DayButton] = []
    private let stackView = UIStackView()

    var didTapDay: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.axis = .vertical
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.pinEdges(to: self)

        for row in [1...7, 8...14, 15...21, 22...28] {

            let rowStackView = UIStackView()
            rowStackView.distribution = .equalSpacing
            stackView.addArrangedSubview(rowStackView)

            for day in row {
                let button = DayButton(day: day)
                button.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
                rowStackView.addArrangedSubview(button)
                buttons.append(button)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.spacing = window!.frame.height / 28
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func dayButtonTapped(sender: DayButton) {
        buttons.forEach { $0.isSelected = false }
        sender.isSelected = true
        didTapDay?(sender.day)
    }
}

private class DayButton: Control {

    private let label = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), alignment: .center)

    let day: Int

    init(day: Int) {
        self.day = day

        super.init(frame: .zero)
        label.text = "\(day < 10 ? "0" : "")\(day)"
        addSubview(label)
        label.pinEdges(to: self, insets: .init(all: 8))

        clipsToBounds = true
        widthAnchor.pin(to: heightAnchor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.midX
    }

    override func updateState() {
        label.textColor = isSelected ? .customWhite : .customLabel
        backgroundColor = isSelected ? .brand : .clear
    }
}
