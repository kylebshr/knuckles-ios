//
//  BalanceViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import Combine
import UIKit

class BalanceViewController: ViewController, UICollectionViewDelegate {

    enum Section: Hashable {
        case header
        case upNext(Date)
    }

    enum Item: Hashable {
        case header(Decimal)
        case expense(Expense)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private lazy var dataSource = makeDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())

    private let titleView = BalanceTitleView()

    init(user: User) {
        super.init()
        tabBarItem = UITabBarItem(title: "Goals", image: nil, tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleView

        view.addSubview(collectionView)
        collectionView.pinEdges(to: view)
        collectionView.dataSource = dataSource
        collectionView.register(cell: BalanceCell.self)
        collectionView.register(cell: BubbleCell.self)
        collectionView.register(view: DateHeader.self, for: UICollectionView.elementKindSectionHeader)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .customBackground
        collectionView.delegate = self
        collectionView.layoutMargins = .init(vertical: 0, horizontal: 15)
        collectionView.allowsSelection = false

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .done,
            target: self,
            action: #selector(openSettings)
        )

        BalanceController.shared.$balance.sink(receiveValue: update).store(in: &cancelBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTitleView()
    }

    @objc private func openSettings() {
        let viewController = NavigationController(rootViewController: SettingsViewController())
        present(viewController, animated: true, completion: nil)
    }

    @objc private func refresh() {
        BalanceController.shared.refresh { didRefresh in
            if didRefresh {
                self.collectionView.refreshControl?.endRefreshing()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
        }
    }

    private func update(amount: BalanceState?) {
        guard let amount = amount else { return }

        let balance = amount.balance(using: .current)

        tabBarItem = UITabBarItem(amount: balance)
        titleView.display(amount: balance)
        titleView.sizeToFit()

        var snapshot = Snapshot()

        snapshot.appendSections([.header])
        snapshot.appendItems([.header(balance)])

        let expenses = Dictionary(grouping: amount.expenses, by: \.dayDueAt)
        let sortedExpenses = expenses.sorted { lhs, rhs in
            lhs.value[0].sortingDate() < rhs.value[0].sortingDate()
        }

        for section in sortedExpenses {
            snapshot.appendSections([.upNext(section.value[0].sortingDate())])
            snapshot.appendItems(section.value.map { .expense($0) })
        }

        dataSource.apply(snapshot)
    }

    private func headerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .estimated(164))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(164))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 15, bottom: 15, trailing: 15)

        return section
    }

    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            guard let self = self else {
                return nil
            }

            switch section {
            case 0: return self.headerLayout()
            default: return .bubbleCellLayout()
            }
        }
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .header(let balance):
                let cell = collectionView.dequeue(for: indexPath) as BalanceCell
                cell.display(amount: balance)
                return cell
            case .expense(let expense):
                let cell = collectionView.dequeue(for: indexPath) as BubbleCell
                cell.display(expense: expense)
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeue(kind: kind, for: indexPath) as DateHeader
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .header:
                return nil
            case .upNext(let date):
                header.display(date: date)
                return header
            }
        }

        return dataSource
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTitleView()
    }

    private func updateTitleView() {
        let visualEffectView = navigationController?.navigationBar.subview(ofType: UIVisualEffectView.self)
        let hackyAlpha = visualEffectView?.alpha ?? 0
        let hackierAlpha = hackyAlpha < 0.02 ? 0 : hackyAlpha
        titleView.alpha = hackierAlpha
    }
}

private class BalanceTitleView: UIView {
    private let titleLabel = UILabel(font: .systemFont(ofSize: 14, weight: .semibold), color: .customLabel)
    private let amountLabel = UILabel(font: .systemFont(ofSize: 18, weight: .bold), color: .emphasis)

    private lazy var stack = UIStackView(arrangedSubviews: [titleLabel, amountLabel])

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.text = "Balance"
        amountLabel.text = "-"

        stack.axis = .vertical
        stack.alignment = .center
        addSubview(stack)
        stack.pinEdges(to: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(amount: Decimal) {
        amountLabel.text = amount.currency()
    }
}

private class BalanceCell: UICollectionViewCell {

    static let sizing = BalanceCell()

    private let titleLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), color: .customLabel)
    private let amountLabel = UILabel(font: .systemFont(ofSize: 35, weight: .bold), color: .emphasis)

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.text = "Balance"
        amountLabel.text = "-"

        let stack = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
        stack.axis = .vertical
        contentView.addSubview(stack)
        stack.pinEdges([.left, .right, .bottom], to: contentView)
        stack.bottomAnchor.pin(to: contentView.topAnchor, constant: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(amount: Decimal) {
        amountLabel.text = amount.currency()
    }
}

private extension BubbleCell {
    func display(expense: Expense) {
        titleLabel.text = expense.name
        detailLabel.text = expense.amount.currency()
    }
}

private extension UITabBarItem {

    private static let label = UILabel(font: .systemFont(ofSize: 20, weight: .bold))

    convenience init(amount: Decimal) {
        Self.label.text = "$\(amount.abbreviated())"
        Self.label.sizeToFit()

        let image = UIGraphicsImageRenderer(bounds: Self.label.bounds).image { context in
            Self.label.layer.render(in: context.cgContext)
        }

        self.init(title: "", image: image, tag: 0)
    }

}
