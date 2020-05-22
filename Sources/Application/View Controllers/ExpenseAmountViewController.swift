//
//  EnterAmountViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseAmountViewController: FlowViewController, KeyPadDelegate {

    private let button = FullWidthButton()
    private let amountLabel = UILabel(font: .monospacedRubik(ofSize: 64, weight: .bold), alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        navigationView.text = "How much is it?"

        button.text = "Next"

        amountLabel.setHuggingAndCompression(to: .required)
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.text = "$0"
        view.backgroundColor = .systemBackground

        let topView = UIView()
        let middleView = UIView()
        let bottomView = UIView()

        let keyPad = KeyPad(formatter: KeyPadCurrencyFormatter())
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

    func keyPad(_ keyPad: KeyPad, didUpdateText text: String) {
        amountLabel.text = text
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
