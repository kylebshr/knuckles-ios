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
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = expense.name
        navigationItem.largeTitleDisplayMode = .never

        scrollView.alwaysBounceVertical = true
        scrollView.contentInset.top = 40
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)

        emojiView.background = .customPink
        emojiLabel.text = "📱"

        let amountLabel = UILabel(font: .rubik(ofSize: 48, weight: .medium), alignment: .center)
        amountLabel.text = expense.fundingState(using: .current).amount

        let statusLabel = UILabel(font: .rubik(ofSize: 16, weight: .medium))
        statusLabel.text = expense.fundingState(using: .current).text

        let nextAmountView = NextAmountView(expense: expense)

        let nextDate = expense.nextDueDate()
        let dueButton = EditControl(symbolName: "arrow.2.circlepath", text: "Due on the \(nextDate.day())")
        let amountButton = EditControl(symbolName: "arrow.right", text: "\(expense.amount.currency()) each month")

        let moveButton = RetroButton(text: "Move Money", color: .customBlue, style: .secondary)
        let deleteButton = DeleteControl()

        let stackView = UIStackView(arrangedSubviews: [
            emojiView, amountLabel, statusLabel, nextAmountView,
            dueButton, amountButton, moveButton, deleteButton,
        ])

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(20, after: emojiView)
        stackView.setCustomSpacing(5, after: amountLabel)
        stackView.setCustomSpacing(42, after: statusLabel)
        stackView.setCustomSpacing(26, after: amountButton)
        stackView.setCustomSpacing(20, after: moveButton)

        scrollView.addSubview(stackView)
        stackView.pinEdges(to: scrollView)
        stackView.widthAnchor.pin(to: view.widthAnchor)
        nextAmountView.widthAnchor.pin(to: view.widthAnchor)
        dueButton.widthAnchor.pin(to: view.widthAnchor)
        amountButton.widthAnchor.pin(to: view.widthAnchor)
        moveButton.widthAnchor.pin(to: view.widthAnchor, constant: -40)
    }
}

private class NextAmountView: UIView {

    private let icon = UIImageView()
    private let title = UILabel(font: .rubik(ofSize: 18, weight: .medium))

    init(expense: Expense) {
        super.init(frame: .zero)

        layoutMargins = .init(vertical: 15, horizontal: 30)

        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        icon.image = UIImage(systemName: "arrow.right", withConfiguration: configuration)
        icon.setHuggingAndCompression(to: .required)
        icon.tintColor = .customBlue

        let stackView = UIStackView(arrangedSubviews: [icon, title])
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10

        addSubview(stackView)
        stackView.pinEdges(to: layoutMarginsGuide)

        let nextAmount = expense.nextAmountSaved(using: .current).currency()
        let amount = NSMutableAttributedString(string: "\(nextAmount) in",
            attributes: [.foregroundColor: UIColor.customBlue])
        let nextFundingDate = PayPeriod.current.nextDate()
        let nextFundingDateText = DateFormatter.readyByFormatter.string(from: nextFundingDate)

        amount.append(.init(string: " on \(nextFundingDateText)"))
        title.attributedText = amount
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
