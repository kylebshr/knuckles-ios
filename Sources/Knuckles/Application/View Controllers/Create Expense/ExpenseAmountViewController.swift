//
//  EnterAmountViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseAmountViewController: FlowViewController, KeyPadViewDelegate {

    var didEnterAmount: ((Decimal) -> Void)?

    private let button = Button(title: "Next")
    private let amountLabel = UILabel(font: .systemFont(ofSize: 64, weight: .bold), alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "How much is it?"

        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        amountLabel.setHuggingAndCompression(to: .required)
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.text = "$0"
        view.backgroundColor = .customBackground

        let topView = UIView()
        let middleView = UIView()
        let bottomView = UIView()

        let keyPad = KeyPadView(formatter: KeyPadCurrencyFormatter())
        keyPad.delegate = self

        let perMonthLabel = UILabel(font: .systemFont(ofSize: 18, weight: .medium), color: .customSecondaryLabel, alignment: .center)
        perMonthLabel.setHuggingAndCompression(to: .required)
        perMonthLabel.text = "per month"

        let stackView = UIStackView(arrangedSubviews: [
            topView, amountLabel, perMonthLabel, middleView, keyPad, bottomView,
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

    func keyPadView(_ keyPad: KeyPadView, didUpdateText text: String) {
        amountLabel.text = text
    }

    @objc private func didTapNext() {
        guard var amountText = amountLabel.text else {
            return
        }

        amountText.removeFirst()

        guard let amount = Decimal(string: amountText), amount != 0 else {
            return
        }

        didEnterAmount?(amount)
    }
}
