//
//  ExpenseConfirmationViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/18/20.
//

import UIKit

class ExpenseConfirmationViewController: FlowViewController {
    var didConfirm: (() -> Void)?

    private let button = Button(title: "Add to expenses")

    init(expense: Expense) {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        view.backgroundColor = .customBackground

        let topView = UIView()
        let middleView = UIView()
        let bottomView = UIView()

        let perMonthLabel = UILabel(font: .systemFont(ofSize: 18, weight: .medium), color: .customSecondaryLabel, alignment: .center)
        perMonthLabel.setHuggingAndCompression(to: .required)
        perMonthLabel.text = "[[ Confirmation UI ]]"

        let stackView = UIStackView(arrangedSubviews: [
            topView, perMonthLabel, middleView, bottomView,
        ])

        view.addSubview(stackView)
        view.addSubview(button)

        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.pinEdges([.top, .left, .right], to: view.safeAreaLayoutGuide)
        stackView.bottomAnchor.pin(to: button.topAnchor)

        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.2)
        bottomView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.7)

        button.pinEdges([.left, .right, .bottom], to: view.safeAreaLayoutGuide, insets: .init(all: 20))
    }

    @objc private func didTapNext() {
        didConfirm?()
    }

}
