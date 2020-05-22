//
//  ExpenseViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import UIKit

class ExpenseViewController: UITableViewController {

    let expenses = [
        Expense(name: "Phone", amount: 35, dayDueAt: 25),
        Expense(name: "Renter’s Insurance", amount: 11.42, dayDueAt: 27),
        Expense(name: "Github", amount: 4, dayDueAt: 27),
        Expense(name: "HBO", amount: 14.99, dayDueAt: 27),
        Expense(name: "Betterment", amount: 1000, dayDueAt: 1),
        Expense(name: "G-Suite", amount: 6, dayDueAt: 2),
        Expense(name: "Netflix", amount: 15.99, dayDueAt: 2),
        Expense(name: "Apple Music", amount: 9.99, dayDueAt: 10),
        Expense(name: "Rent", amount: 1369, dayDueAt: 15),
        Expense(name: "Spotify", amount: 10.94, dayDueAt: 21),
        Expense(name: "Kindle", amount: 9.99, dayDueAt: 21),
    ].sorted { $0.nextDueDate() < $1.nextDueDate() }

    let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Expenses"

        let informationalViewController = InformationalViewController()
        add(informationalViewController) { view in
            view.frame = view.bounds
            self.tableView.tableHeaderView = view
        }

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExpenseCell()
        let expense = expenses[indexPath.row]
        cell.display(expense: expense, in: payPeriod)
        return cell
    }
}

class ExpenseCell: UITableViewCell {
    private let nameLabel = UILabel(font: .systemFont(ofSize: 18, weight: .bold))
    private let amountLabel = UILabel(font: .systemFont(ofSize: 17, weight: .medium))
    private let reservedLabel = UILabel(font: .systemFont(ofSize: 13, weight: .medium), color: .secondaryLabel)
    private let progressView = ProgressView()
    private let readyLabel = UILabel(font: .systemFont(ofSize: 13, weight: .medium))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        reservedLabel.text = "reserved"

        let titleStack = UIStackView(arrangedSubviews: [nameLabel, UIView(), amountLabel, reservedLabel])
        titleStack.alignment = .firstBaseline
        titleStack.distribution = .fill
        titleStack.spacing = 2

        let stack = UIStackView(arrangedSubviews: [titleStack, progressView, readyLabel])
        stack.axis = .vertical
        stack.setCustomSpacing(12, after: progressView)
        stack.spacing = 8

        contentView.addSubview(stack)
        stack.pinEdges(to: contentView.layoutMarginsGuide)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(expense: Expense, in period: PayPeriod) {
        let amountSaved = expense.amountSaved(using: period)

        progressView.tintColor = expense.tintColor
        progressView.progress = CGFloat(truncating: amountSaved / expense.amount as NSNumber)

        nameLabel.text = expense.name
        amountLabel.text = NumberFormatter.currency.string(from: amountSaved as NSNumber)

        let nextDueDate = expense.nextDueDate()
        let dueDateString = DateFormatter.readyByFormatter.string(from: nextDueDate)

        if expense.isFunded(using: period) {
            readyLabel.text = "Ready for \(dueDateString)"
            readyLabel.textColor = .label
        } else {
            readyLabel.text = "Ready by \(dueDateString)"
            readyLabel.textColor = .secondaryLabel
        }
    }
}
