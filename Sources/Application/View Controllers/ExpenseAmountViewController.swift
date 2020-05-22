//
//  EnterAmountViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseAmountViewController: UIViewController, KeyPadDelegate {

    private let amountLabel = UILabel(font: .monospacedRubik(ofSize: 72, weight: .bold), alignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.text = "$0"
        view.backgroundColor = .systemBackground

        view.addSubview(amountLabel)
        amountLabel.pinEdges([.left, .right, .top], to: view.safeAreaLayoutGuide)

        let keyPad = KeyPad(formatter: KeyPadCurrencyFormatter())
        view.addSubview(keyPad)
        keyPad.delegate = self
        keyPad.pinEdges([.left, .right, .bottom], to: view.safeAreaLayoutGuide)
    }

    func keyPad(_ keyPad: KeyPad, didUpdateText text: String) {
        amountLabel.text = text
    }
}
