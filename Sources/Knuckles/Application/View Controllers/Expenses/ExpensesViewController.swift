//
//  ExpensesViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import UIKit

class ExpensesViewController: ViewController, UITableViewDataSource, UITableViewDelegate, TabbedViewController {
    var scrollView: UIScrollView? { tableView }
    var tabItem: TabBarItem { .symbol("calendar") }

    private let navigationView = NavigationView()
    private let tableView = UITableView()

    private let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: true)
    private var expenses: [Expense] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(navigationView)

        navigationView.pinEdges([.left, .top, .right], to: view)
        tableView.pinEdges([.left, .right, .bottom], to: view)
        tableView.topAnchor.pin(to: navigationView.bottomAnchor)

        navigationView.text = "Expenses"
        navigationView.action = .init(symbolName: "plus") { [weak self] in
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

        navigationView.observe(scrollView: tableView)
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
    private let nameLabel = UILabel(font: .rubik(ofSize: 18, weight: .medium))
    private let amountLabel = UILabel(font: .rubik(ofSize: 18, weight: .medium), alignment: .right)
    private let nextAmountLabel = UILabel(font: .rubik(ofSize: 13, weight: .medium), color: .customBlue, alignment: .right)
    private let emojiView = UILabel(font: .rubik(ofSize: 24, weight: .regular))
    private let readyLabel = UILabel(font: .rubik(ofSize: 13, weight: .medium))
    private lazy var retroView = RetroView(content: emojiView)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        emojiView.setHuggingAndCompression(to: .required)

        backgroundColor = .systemBackground
        preservesSuperviewLayoutMargins = true

        contentView.layoutMargins.top = 16
        contentView.layoutMargins.right = 30
        contentView.layoutMargins.left = 22
        contentView.layoutMargins.bottom = 16

        let titleStack = UIStackView(arrangedSubviews: [nameLabel, amountLabel])
        titleStack.alignment = .firstBaseline
        titleStack.distribution = .fill
        titleStack.spacing = 2

        let subStack = UIStackView(arrangedSubviews: [readyLabel, nextAmountLabel])
        subStack.distribution = .fill
        subStack.spacing = 2

        let verticalStack = UIStackView(arrangedSubviews: [titleStack, subStack])
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .fill
        verticalStack.spacing = 8

        let horizontalStack = UIStackView(arrangedSubviews: [retroView, verticalStack])
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 16

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
        amountLabel.text = NumberFormatter.currency.string(from: amountSaved as NSNumber)!
        let nextAmountText = NumberFormatter.currency.string(from: expense.nextAmountSaved(using: period) as NSNumber)!
        nextAmountLabel.text = "+ \(nextAmountText.droppingZeroes()) next"

        let dueDateString = DateFormatter.readyByFormatter.string(from: expense.nextDueDate())

        if expense.isDue() {
            let amount = NumberFormatter.currency.string(from: expense.amount as NSNumber)!
            readyLabel.text = "\(amount.droppingZeroes()) paid today"
            retroView.background = .customPink
        } else if expense.isFunded(using: period) {
            readyLabel.text = "Ready for \(dueDateString)"
            retroView.background = .customGreen
        } else {
            let amount = NumberFormatter.currency.string(from: expense.amount as NSNumber)!
            readyLabel.text = "\(amount.droppingZeroes()) by \(dueDateString)"
            retroView.background = .customBlue
        }
    }
}
