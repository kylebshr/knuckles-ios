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

        amountLabel.text = "$0"
        view.backgroundColor = .systemBackground

        view.addSubview(amountLabel)
        amountLabel.pinEdges([.left, .right, .top], to: view.safeAreaLayoutGuide)

        let keyPad = KeyPad()
        view.addSubview(keyPad)
        keyPad.delegate = self
        keyPad.pinEdges([.left, .right, .bottom], to: view.safeAreaLayoutGuide)
    }

    private func appendCharacter(character: Character) {
        var currentText = amountLabel.text!
        currentText.removeFirst()

        if character == "." {
            if currentText.contains(".") {
                return
            }
            if currentText == "0" {
                return
            }
        }

        if currentText.suffix(3).starts(with: ".") {
            return
        }

        if currentText == "0" {
            currentText = ""
        }

        if character != "." && !currentText.contains(".") && currentText.count >= 5 {
            return
        }

        currentText.append(character)
        amountLabel.text = "$\(currentText)"
    }

    private func removeCharacter() {
        var currentText = amountLabel.text!
        currentText.removeFirst()
        currentText.removeLast()

        if currentText.isEmpty {
            currentText = "0"
        }

        amountLabel.text = "$\(currentText)"
    }

    func keyPad(_ keyPad: KeyPad, didTap character: Character) {
        appendCharacter(character: character)
    }

    func keyPadDidTapDelete(_ keyPad: KeyPad) {
        removeCharacter()
    }
}
