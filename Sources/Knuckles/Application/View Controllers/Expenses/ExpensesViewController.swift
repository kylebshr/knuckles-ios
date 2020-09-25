//
//  ExpensesViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import Combine
import UIKit

class ExpensesViewController: ViewController, UICollectionViewDelegate {

    typealias DataSource = UICollectionViewDiffableDataSource<Date, Expense>

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .bubble())
    private lazy var dataSource = makeDataSource()

    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "calendar"), tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.pinEdges(to: view)

        navigationItem.title = "Expenses"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(presentCreateExpense)
        )

        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .customBackground
        collectionView.register(view: DateHeader.self, for: UICollectionView.elementKindSectionHeader)
        collectionView.register(cell: BubbleCell.self)

        BalanceController.shared.$balance.sink { [weak self] state in
            self?.reload(using: state?.expenses ?? [])
        }.store(in: &cancelBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?.first {
            transitionCoordinator?.animate(alongsideTransition: { _ in
                self.collectionView.deselectItem(at: selectedIndexPath, animated: true)
            }, completion: { context in
                if context.isCancelled {
                    self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
                }
            })
        }

        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeue(for: indexPath) as BubbleCell
            cell.display(expense: item, in: .current)
            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeue(kind: kind, for: indexPath) as DateHeader
            let date = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            header.display(date: date)
            return header
        }

        return dataSource
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let expense = dataSource.itemIdentifier(for: indexPath)!
        let detailViewController = ExpenseDetailViewController(expense: expense)
        show(detailViewController, sender: self)
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
        var snapshot = NSDiffableDataSourceSnapshot<Date, Expense>()

        let expenses = Dictionary(grouping: expenses, by: \.dayDueAt)
        let sortedExpenses = expenses.sorted { lhs, rhs in
            lhs.value[0].sortingDate() < rhs.value[0].sortingDate()
        }

        for section in sortedExpenses {
            snapshot.appendSections([section.value[0].sortingDate()])
            snapshot.appendItems(section.value)
        }

        dataSource.apply(snapshot, animatingDifferences: animate)
    }
}

private extension BubbleCell {
    func display(expense: Expense, in period: PayPeriod) {
        titleLabel.text = expense.name
        subtitleLabel.text = "\(expense.amountSaved(using: .current).currency()) reserved"

        let state = expense.fundingState(using: period)
        detailLabel.text = state.text
    }
}
