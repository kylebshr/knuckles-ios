//
//  ExpenseViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import UIKit

class ExpenseViewController: UITableViewController {

    let expenses = [
        Expense(emoji: "📱", name: "Phone", amount: 35, dayDueAt: 25),
        Expense(emoji: "🏠", name: "Renter’s Insurance", amount: 11.42, dayDueAt: 27),
        Expense(emoji: "💻", name: "Github", amount: 4, dayDueAt: 27),
        Expense(emoji: "📺", name: "HBO", amount: 14.99, dayDueAt: 27),
        Expense(emoji: "💎", name: "Betterment", amount: 1000, dayDueAt: 1),
        Expense(emoji: "🖥", name: "G-Suite", amount: 6, dayDueAt: 2),
        Expense(emoji: "📺", name: "Netflix", amount: 15.99, dayDueAt: 2),
        Expense(emoji: "🎵", name: "Apple Music", amount: 9.99, dayDueAt: 10),
        Expense(emoji: "🏠", name: "Rent", amount: 1369, dayDueAt: 15),
        Expense(emoji: "🎧", name: "Spotify", amount: 10.94, dayDueAt: 21),
        Expense(emoji: "📚", name: "Kindle", amount: 9.99, dayDueAt: 22),
    ].sorted { $0.sortingDate() < $1.sortingDate() }

    let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Expenses"

        tableView.layoutMargins.left = 20
        tableView.layoutMargins.right = 20
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cell: ExpenseCell.self)
        tableView.register(view: HeaderView.self)
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentOffset.y = view.safeAreaInsets.top
        tableView.contentInset.top = -view.safeAreaInsets.top
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as ExpenseCell
        let expense = expenses[indexPath.row]
        cell.display(expense: expense, in: payPeriod)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeue() as HeaderView
        header.label.text = section == 0 ? "Expenses" : "Goals"
        header.addButton.addTarget(self, action: #selector(presentCreateExpense), for: .touchUpInside)
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    @objc private func presentCreateExpense() {
        let viewController = ExpenseAmountViewController()
        let navigationController = SlideNavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

private class ExpenseCell: UITableViewCell {
    private let nameLabel = UILabel(font: .rubik(ofSize: 18, weight: .medium))
    private let amountLabel = UILabel(font: .rubik(ofSize: 18, weight: .medium))
    private let nextAmountLabel = AmountLabel()
    private let cadenceLabel = UILabel(font: .rubik(ofSize: 13, weight: .medium))
    private let emojiView = UILabel(font: .rubik(ofSize: 24, weight: .regular))
    private let readyLabel = UILabel(font: .rubik(ofSize: 13, weight: .medium), color: .secondaryLabel)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        emojiView.setHuggingAndCompression(to: .required)

        preservesSuperviewLayoutMargins = true

        contentView.layoutMargins.top = 20
        contentView.layoutMargins.right = 20
        contentView.layoutMargins.bottom = 20

        let titleStack = UIStackView(arrangedSubviews: [nameLabel, UIView(), amountLabel])
        titleStack.alignment = .firstBaseline
        titleStack.distribution = .fill
        titleStack.spacing = 2

        let subStack = UIStackView(arrangedSubviews: [nextAmountLabel, cadenceLabel, UIView(), readyLabel])
        subStack.spacing = 6

        let verticalStack = UIStackView(arrangedSubviews: [titleStack, subStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 5

        let horizontalStack = UIStackView(arrangedSubviews: [emojiView, verticalStack])
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 20

        contentView.addSubview(horizontalStack)
        horizontalStack.pinEdges(to: contentView.layoutMarginsGuide)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(expense: Expense, in period: PayPeriod) {
        let amountSaved = expense.amountSaved(using: period)

        nameLabel.text = expense.name
        emojiView.text = "\(expense.emoji)"
        amountLabel.text = NumberFormatter.currency.string(from: amountSaved as NSNumber)
        cadenceLabel.text = "payday"
        nextAmountLabel.display(amount: expense.nextAmountSaved(using: period))
        nextAmountLabel.tintColor = .systemBlue

        let nextDueDate = expense.nextDueDate()
        let dueDateString = DateFormatter.readyByFormatter.string(from: nextDueDate)

        if expense.isDue() {
            amountLabel.text = "Paid"
            cadenceLabel.text = "today"
            readyLabel.text = "on \(dueDateString)"
            nextAmountLabel.display(amount: -expense.amount)
            nextAmountLabel.tintColor = .systemPink
        } else if expense.isFunded(using: period) {
            readyLabel.text = "Ready for \(dueDateString)"
        } else {
            readyLabel.text = "Ready by \(dueDateString)"
        }
    }
}

private class HeaderView: UITableViewHeaderFooterView {

    let label = UILabel()
    let addButton = UIButton(type: .system)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        preservesSuperviewLayoutMargins = true

        contentView.layoutMargins.bottom = 15
        contentView.layoutMargins.top = 74
        contentView.backgroundColor = .systemBackground

        contentView.addSubview(label)
        label.text = "Expenses"
        label.font = .rubik(ofSize: 32, weight: .bold)
        label.pinEdges([.left, .right, .top], to: contentView.layoutMarginsGuide)
        label.bottomAnchor.pin(to: contentView.layoutMarginsGuide.bottomAnchor, priority: .defaultHigh)

        contentView.addSubview(addButton)
        addButton.tintColor = .label
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        addButton.setImage(UIImage(systemName: "plus.circle", withConfiguration: config), for: .normal)

        addButton.trailingAnchor.pin(to: contentView.layoutMarginsGuide.trailingAnchor)
        addButton.centerYAnchor.pin(to: label.centerYAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class AmountLabel: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 4
        layer.masksToBounds = true

        addSubview(label)
        label.pinEdges(to: self, insets: .init(vertical: 2, horizontal: 6))
        label.textColor = .white
        label.font = .rubik(ofSize: 13, weight: .medium)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var size = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width += 12
        size.height += 8
        return size
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        backgroundColor = tintColor
    }

    func display(amount: Decimal) {
        label.text = (amount > 0 ? "+" : "") + NumberFormatter.currency.string(from: amount as NSNumber)!
    }
}
