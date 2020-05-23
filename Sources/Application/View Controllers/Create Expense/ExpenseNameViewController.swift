//
//  ExpenseNameViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseNameViewController: FlowViewController {

    var didEnterName: ((String) -> Void)?

    private let textField = TextField()
    private let nextButton = FullWidthButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.text = "Name this expense"

        view.addSubview(textField)
        textField.centerYAnchor.pin(to: keyboardLayoutGuide.centerYAnchor)
        textField.pinEdges([.left, .right], to: view)
        textField.placeholder = "Try Rent, Phone Bill, Spotify"
        textField.font = .rubik(ofSize: 20, weight: .medium)

        view.addSubview(nextButton)
        nextButton.text = "Next"
        nextButton.pinEdges([.left, .right, .bottom], to: keyboardLayoutGuide)

        nextButton.onTap = { [weak self] in
            guard let text = self?.textField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
                return
            }

            self?.didEnterName?(text)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
}
