//
//  ExpensesViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import UIKit

class ExpensesViewController: BarViewController, UITableViewDataSource, UITableViewDelegate, TabbedViewController {
    var scrollView: UIScrollView? { tableView }
    var tabItem: TabBarItem { .symbol("calendar") }

    private let tableView = UITableView()

    private let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: true)
    private var expenses: [Expense] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.pinEdges(to: view)

        customNavigationBar.text = "Expenses"
        customNavigationBar.rightAction = .init(symbolName: "plus") { [weak self] in
            self?.presentCreateExpense()
        }

        tableView.separatorStyle = .none
        tableView.layoutMargins.left = 30
        tableView.layoutMargins.right = 30
        tableView.showsVerticalScrollIndicator = true
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.register(cell: ExpenseCell.self)

        customNavigationBar.observe(scrollView: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as ExpenseCell
        let expense = expenses[indexPath.row]
        cell.display(expense: expense, in: payPeriod)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        let detailViewController = ExpenseDetailViewController(expense: expense)
        show(detailViewController, sender: self)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            UserDefaults.shared.expenses.remove(at: indexPath.row)
            self?.tableView.beginUpdates()
            self?.expenses.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.tableView.endUpdates()
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    private func presentCreateExpense() {
        let viewController = ExpenseCreationViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }

    private func reload() {
        expenses = UserDefaults.shared.expenses
            .sorted { $0.sortingDate() < $1.sortingDate() }
        tableView.reloadData()
    }
}

private class ExpenseCell: UITableViewCell {

    private let emojiView = UILabel(font: .rubik(ofSize: 24, weight: .regular))
    private let nameLabel = UILabel(font: .rubik(ofSize: 16, weight: .medium))
    private let statusLabel = UILabel(font: .rubik(ofSize: 16, weight: .medium))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        statusLabel.setHuggingAndCompression(to: .required)
        statusLabel.textAlignment = .right

        emojiView.setHuggingAndCompression(to: .required, for: .vertical)
        emojiView.widthAnchor.pin(to: emojiView.heightAnchor, multiplier: 1.1)
        emojiView.textAlignment = .center

        backgroundColor = .systemBackground
        contentView.layoutMargins = .init(vertical: 20, horizontal: 30)

        let horizontalStack = UIStackView(arrangedSubviews: [emojiView, nameLabel, statusLabel])
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 8

        contentView.addSubview(horizontalStack)
        horizontalStack.pinEdges(to: contentView.layoutMarginsGuide)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(expense: Expense, in period: PayPeriod) {
        nameLabel.text = expense.name
        emojiView.text = expense.emoji

        let state = expense.fundingState(using: period)
        statusLabel.text = state.text

        switch state {
        case .funded:
            statusLabel.textColor = .customBlue
        case .paid, .onTrack:
            statusLabel.textColor = .label
        }
    }
}
