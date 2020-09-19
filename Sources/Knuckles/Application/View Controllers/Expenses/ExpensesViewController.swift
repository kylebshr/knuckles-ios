//
//  ExpensesViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import UIKit

class ExpensesViewController: ViewController, UITableViewDataSource, UITableViewDelegate, TabbedViewController {
    var tabItem: TabBarItem { .symbol("calendar") }

    private let tableView = UITableView()

    private let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: true)
    private var expenses: [Expense] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.pinEdges(to: view)

        navigationItem.title = "Expenses"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(presentCreateExpense)
        )

        tableView.showsVerticalScrollIndicator = true
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .customBackground
        tableView.register(cell: ExpenseCell.self)
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

        action.backgroundColor = .customRed
        return UISwipeActionsConfiguration(actions: [action])
    }

    @objc private func presentCreateExpense() {
        let viewController = ExpenseCreationViewController()
        present(viewController, animated: true, completion: nil)
    }

    private func reload() {
        expenses = UserDefaults.shared.expenses
            .sorted { $0.sortingDate() < $1.sortingDate() }
        tableView.reloadData()
    }
}

private class ExpenseCell: UITableViewCell {

    private let nameLabel = UILabel(font: .systemFont(ofSize: 20, weight: .medium))
    private let statusLabel = UILabel(font: .systemFont(ofSize: 17, weight: .medium))

    private let paymentControl = RevenueControl(direction: .payment)
    private let incomeControl = RevenueControl(direction: .income)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        statusLabel.setHuggingAndCompression(to: .required)
        statusLabel.textAlignment = .right

        contentView.layoutMargins.top = 16
        contentView.layoutMargins.bottom = 16
        backgroundColor = .customBackground

        let topStack = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        topStack.alignment = .firstBaseline
        topStack.distribution = .fill
        topStack.spacing = 8

        let bottomStack = UIStackView(arrangedSubviews: [paymentControl, incomeControl])
        bottomStack.alignment = .firstBaseline
        bottomStack.distribution = .fill
        bottomStack.spacing = 8

        let containerStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
        containerStack.axis = .vertical
        containerStack.alignment = .fill
        containerStack.spacing = 6

        contentView.addSubview(containerStack)
        containerStack.pinEdges(to: contentView.layoutMarginsGuide)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        contentView.backgroundColor = highlighted ? UIColor.black.withAlphaComponent(0.1) : .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = selected ? UIColor.black.withAlphaComponent(0.1) : .clear
    }

    func display(expense: Expense, in period: PayPeriod) {
        nameLabel.text = expense.name

        let state = expense.fundingState(using: period)
        statusLabel.text = state.text

        switch state {
        case .funded:
            statusLabel.textColor = .brand
        case .paid, .onTrack:
            statusLabel.textColor = .customLabel
        }

        paymentControl.display(amount: expense.amount, period: "month")
        incomeControl.display(amount: expense.nextAmountSaved(), period: "payday")
    }
}
