//
//  EnterAmountViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseAmountViewController: FlowViewController, KeyPadViewDelegate {

    var didEnterAmount: ((Decimal) -> Void)?

    private let button = FullWidthButton()
    private let amountLabel = UILabel(font: .monospacedRubik(ofSize: 64, weight: .bold), alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.text = "How much is it?"

        button.text = "Next"
        button.onTap = { [weak self] in self?.didTapNext() }

        amountLabel.setHuggingAndCompression(to: .required)
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.text = "$0"
        view.backgroundColor = .systemBackground

        let topView = UIView()
        let middleView = UIView()
        let bottomView = UIView()

        let keyPad = KeyPadView(formatter: KeyPadCurrencyFormatter())
        keyPad.delegate = self

        let perMonthLabel = UILabel(font: .rubik(ofSize: 18, weight: .regular), color: .secondaryLabel, alignment: .center)
        perMonthLabel.setHuggingAndCompression(to: .required)
        perMonthLabel.text = "per month"

        let stackView = UIStackView(arrangedSubviews: [
            topView, amountLabel, perMonthLabel, middleView, keyPad, bottomView, button,
        ])

        view.addSubview(stackView)
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.pinEdges([.left, .right], to: view.safeAreaLayoutGuide)
        stackView.bottomAnchor.pin(to: view.bottomAnchor)
        stackView.topAnchor.pin(to: navigationView.bottomAnchor)

        middleView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.2)
        bottomView.heightAnchor.pin(to: topView.heightAnchor, multiplier: 0.7)
    }

    func keyPadView(_ keyPad: KeyPadView, didUpdateText text: String) {
        amountLabel.text = text
    }

    private func didTapNext() {
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
