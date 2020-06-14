//
//  ExpenseDetailViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/12/20.
//

import UIKit

class ExpenseDetailViewController: ViewController {

    private let scrollView = UIScrollView()

    private let emojiLabel = UILabel(font: .systemFont(ofSize: 24))
    private lazy var emojiView = RetroView(content: emojiLabel)

    private let expense: Expense

    init(expense: Expense) {
        self.expense = expense
        super.init()
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)

        emojiView.background = .customPink
        emojiLabel.text = "📱"

        let amountLabel = UILabel(font: .rubik(ofSize: 48, weight: .medium), alignment: .center)
        amountLabel.text = expense.amountSaved(using: .weekly(day: 1)).currency()

        let statusLabel = UILabel(font: .rubik(ofSize: 16, weight: .medium))
        statusLabel.text = "Paid today" // TODO: real text

        let dueButton = EditControl(symbolName: "arrow.2.circlepath", text: "Due on the 27th") // TODO: Date
        let amountButton = EditControl(symbolName: "arrow.right", text: "\(expense.amount.currency()) each month")

        let moveButton = RetroButton(text: "Move Money", color: .customBlue, style: .secondary)
        let deleteButton = DeleteControl()

        let stackView = UIStackView(arrangedSubviews: [
            emojiView, amountLabel, statusLabel, dueButton,
            amountButton, moveButton, deleteButton
        ])

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(20, after: emojiView)
        stackView.setCustomSpacing(5, after: amountLabel)
        stackView.setCustomSpacing(30, after: statusLabel)
        stackView.setCustomSpacing(30, after: amountButton)
        stackView.setCustomSpacing(10, after: moveButton)

        scrollView.addSubview(stackView)
        stackView.pinEdges(to: scrollView)
        stackView.widthAnchor.pin(to: view.widthAnchor)
        dueButton.widthAnchor.pin(to: view.widthAnchor)
        amountButton.widthAnchor.pin(to: view.widthAnchor)
        moveButton.widthAnchor.pin(to: view.widthAnchor, constant: -40)
    }
}

private class EditControl: Control {

    private let icon = UIImageView()
    private let title = UILabel(font: .rubik(ofSize: 18, weight: .medium))
    private let edit = UILabel(font: .rubik(ofSize: 18, weight: .medium), alignment: .right)

    init(symbolName: String, text: String) {
        super.init(frame: .zero)

        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        icon.image = UIImage(systemName: symbolName, withConfiguration: configuration)
        icon.tintColor = .label

        title.text = text
        edit.text = "Edit"

        layoutMargins = .init(vertical: 15, horizontal: 30)

        let stackView = UIStackView(arrangedSubviews: [icon, title, edit])
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10

        icon.setHuggingAndCompression(to: .required)
        edit.setHuggingAndCompression(to: .required)

        addSubview(stackView)
        stackView.pinEdges(to: layoutMarginsGuide)
    }

    override func updateState() {
        edit.alpha = isHighlighted ? 0.3 : 1
    }
}

private class DeleteControl: Control {

    private let label = UILabel(font: .systemFont(ofSize: 13, weight: .medium), color: .customRed, alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.text = "DELETE EXPENSE"

        addSubview(label)
        label.pinEdges(to: self, insets: .init(all: 22))
    }

    override func updateState() {
        label.alpha = isHighlighted ? 0.3 : 1
    }
}
