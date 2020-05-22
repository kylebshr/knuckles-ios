//
//  EnterAmountViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseAmountViewController: UIViewController, KeyPadDelegate {

    private let button = FullWidthButton()
    private let amountLabel = UILabel(font: .monospacedRubik(ofSize: 64, weight: .bold), alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        button.text = "Next"
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.text = "$0"
        view.backgroundColor = .systemBackground

        let keyPad = KeyPad(formatter: KeyPadCurrencyFormatter())
        keyPad.delegate = self

        let perMonthLabel = UILabel(font: .rubik(ofSize: 18, weight: .regular), color: .secondaryLabel, alignment: .center)
        perMonthLabel.text = "per month"

        let stackView = UIStackView(arrangedSubviews: [UIView(), amountLabel, perMonthLabel, keyPad, button])
        view.addSubview(stackView)
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.setCustomSpacing(40, after: keyPad)
        stackView.setCustomSpacing(30, after: perMonthLabel)
        stackView.pinEdges([.left, .right, .top], to: view.safeAreaLayoutGuide)
        stackView.bottomAnchor.pin(to: view.bottomAnchor)
    }

    func keyPad(_ keyPad: KeyPad, didUpdateText text: String) {
        amountLabel.text = text
    }
}
