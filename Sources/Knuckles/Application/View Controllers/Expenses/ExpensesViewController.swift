//
//  ExpensesViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import Combine
import UIKit

class ExpensesViewController: ViewController, UITableViewDelegate {
    private class DataSource: UITableViewDiffableDataSource<String, Expense> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            true
        }
    }

    private let tableView = UITableView()
    private var observation: AnyCancellable?
    private lazy var dataSource = makeDataSource()

    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "calendar"), tag: 1)
    }

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
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.backgroundColor = .customBackground
        tableView.register(cell: ExpenseCell.self)

        observation = BalanceController.shared.$balance.sink { [weak self] state in
            self?.reload(using: state?.expenses ?? [])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            transitionCoordinator?.animate(alongsideTransition: { _ in
                self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }, completion: { context in
                if context.isCancelled {
                    self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                }
            })
        }
    }

    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeue(for: indexPath) as ExpenseCell
            cell.display(expense: item, in: .current)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expense = dataSource.itemIdentifier(for: indexPath)!
        let detailViewController = ExpenseDetailViewController(expense: expense)
        show(detailViewController, sender: self)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, confirm in
            self?.presentDelete(for: indexPath, confirm: confirm)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    @objc private func presentCreateExpense() {
        let viewController = ExpenseCreationViewController()
        present(viewController, animated: true, completion: nil)
    }

    func presentDelete(for indexPath: IndexPath, confirm: @escaping (Bool) -> Void) {
        let expense = dataSource.itemIdentifier(for: indexPath)!
        let sheet = UIAlertController(title: "Delete \(expense.name)?", message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.delete(expense: expense)
            confirm(true)
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            confirm(false)
        }))

        present(sheet, animated: true, completion: nil)
    }

    private func delete(expense: Expense) {
        var expenses = UserDefaults.shared.expenses
        expenses.removeAll(where: { $0 == expense })
        UserDefaults.shared.expenses = expenses
    }

    private func reload(using expenses: [Expense]) {
        let animate = !dataSource.snapshot().itemIdentifiers.isEmpty
        var snapshot = NSDiffableDataSourceSnapshot<String, Expense>()
        snapshot.appendSections(["Expenses"])
        snapshot.appendItems(expenses)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

private class ExpenseCell: UITableViewCell {

    private let nameLabel = UILabel(font: .systemFont(ofSize: 20, weight: .semibold))
    private let statusLabel = UILabel(font: .systemFont(ofSize: 18, weight: .medium), color: .secondaryLabel)
    private let amountSavedLabel = UILabel(font: .systemFont(ofSize: 14, weight: .medium), color: .secondaryLabel)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        statusLabel.setHuggingAndCompression(to: .required)
        statusLabel.textAlignment = .right

        contentView.layoutMargins.top = 16
        contentView.layoutMargins.bottom = 16
        backgroundColor = .customBackground

        let leftStack = UIStackView(arrangedSubviews: [nameLabel, amountSavedLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 2

        let containerStack = UIStackView(arrangedSubviews: [leftStack, statusLabel])
        containerStack.distribution = .equalSpacing
        containerStack.alignment = .center
        containerStack.spacing = 6

        contentView.addSubview(containerStack)
        containerStack.pinEdges(to: contentView.layoutMarginsGuide)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(expense: Expense, in period: PayPeriod) {
        nameLabel.text = expense.name
        amountSavedLabel.text = "\(expense.amountSaved(using: .current).currency()) Saved"

        let state = expense.fundingState(using: period)
        statusLabel.text = state.text
    }
}
