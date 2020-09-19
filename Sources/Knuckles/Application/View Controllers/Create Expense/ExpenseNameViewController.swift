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
    private let nextButton = Button(title: "Next")

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Name your expense"

        view.addSubview(textField)
        textField.centerYAnchor.pin(to: keyboardLayoutGuide.centerYAnchor)
        textField.pinEdges([.left, .right], to: view)
        textField.placeholder = ["Rent", "Netflix", "Spotify", "Internet"].randomElement()!
        textField.font = .systemFont(ofSize: 32, weight: .bold)
        textField.textColor = .customLabel

        view.addSubview(nextButton)
        nextButton.pinEdges([.left, .right, .bottom], to: keyboardLayoutGuide, insets: .init(all: 20))
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    @objc private func didTapNext() {
        guard let text = textField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
            return
        }

        didEnterName?(text)
    }
}
