//
//  InformationalViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/21/20.
//

import Combine
import UIKit

class InformationalViewController: ViewController, UICollectionViewDelegate {

    private let largeHeaderOffset: CGFloat = 52

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

    private let titleView = UILabel(font: .preferredFont(forTextStyle: .headline))

    init(user: User) {
        super.init()
        tabBarItem = UITabBarItem(title: "Goals", image: nil, tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = appearance

        navigationItem.titleView = titleView

        view.addSubview(collectionView)
        collectionView.pinEdges(to: view)
        collectionView.dataSource = dataSource
        collectionView.register(cell: HeaderCell.self)
        collectionView.register(cell: UpNextExpenseCell.self)
        collectionView.register(UpNextDateHeader.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "DateHeader")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .customBackground
//        collectionView.contentInset.top = -largeHeaderOffset
        collectionView.delegate = self
        collectionView.layoutMargins = .init(vertical: 0, horizontal: 15)

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
        titleView.text = balance.currency()
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

    private func upNextLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 15, bottom: 15, trailing: 15)
        section.interGroupSpacing = 10

        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(80))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: "header",
                                                                     alignment: .top)
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]

        return section
    }

    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] section, _ in
            guard let self = self else {
                return nil
            }

            switch section {
            case 0: return self.headerLayout()
            default: return self.upNextLayout()
            }
        }
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .header(let balance):
                let cell = collectionView.dequeue(for: indexPath) as HeaderCell
                cell.display(amount: balance)
                return cell
            case .expense(let expense):
                let cell = collectionView.dequeue(for: indexPath) as UpNextExpenseCell
                cell.display(expense: expense)
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "DateHeader",
                for: indexPath
            ) as? UpNextDateHeader else {
                return nil
            }

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
        let offset = 140 - scrollView.safeAreaInsets.top
        titleView.alpha = offset / largeHeaderOffset
    }
}

private class HeaderCell: UICollectionViewCell {

    static let sizing = HeaderCell()

    private let titleLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), color: .customSecondaryLabel)
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

private class UpNextDateHeader: UICollectionReusableView {

    private let titleLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), color: .customSecondaryLabel)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .customBackground

        addSubview(titleLabel)
        titleLabel.pinEdges(to: self, insets: .init(top: 15, left: 0, bottom: 15, right: 0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(date: Date) {
        titleLabel.text = DateFormatter.readyByFormatter.string(from: date)
    }
}

private class UpNextExpenseCell: UICollectionViewCell {
    private let bubbleView = UIView()
    private let titleLabel = UILabel(font: .systemFont(ofSize: 20, weight: .semibold), color: .customLabel)
    private let amountLabel = UILabel(font: .systemFont(ofSize: 18, weight: .medium), color: .customSecondaryLabel)

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bubbleView)
        bubbleView.pinEdges(to: contentView)
        bubbleView.backgroundColor = .bubbleBackground
        bubbleView.layer.cornerRadius = 12
        bubbleView.layer.cornerCurve = .continuous
        bubbleView.layoutMargins = .init(vertical: 17, horizontal: 15)

        let stack = UIStackView(arrangedSubviews: [titleLabel, amountLabel])
        stack.alignment = .center
        stack.distribution = .equalSpacing

        bubbleView.addSubview(stack)
        stack.pinEdges(to: bubbleView.layoutMarginsGuide)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(expense: Expense) {
        titleLabel.text = expense.name
        amountLabel.text = expense.amount.currency()
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

extension UIView {
    func superview<T>(ofType: T.Type) -> T? {
        var superview = self.superview

        while superview != nil {
            if let superview = superview as? T {
                return superview
            } else {
                superview = superview?.superview
            }
        }

        return nil
    }
}
