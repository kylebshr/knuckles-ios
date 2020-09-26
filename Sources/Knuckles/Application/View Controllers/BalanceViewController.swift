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
        case thisWeek
    }

    enum Item: Hashable {
        case header(String)
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
        collectionView.register(cell: ExpenseCell.self)
        collectionView.register(view: ThisWeekHeader.self)
        collectionView.backgroundColor = .bubbleBackground
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

    private func update(state: BalanceState?) {
        guard let state = state else {
            var snapshot = Snapshot()

            snapshot.appendSections([.header])
            snapshot.appendItems([.header("-")])

            dataSource.apply(snapshot)
            tabBarItem = .noBalance

            return
        }

        let balance = state.balance(using: .current)

        tabBarItem = UITabBarItem(amount: balance)
        titleView.display(amount: balance)
        titleView.sizeToFit()

        var snapshot = Snapshot()

        snapshot.appendSections([.header])
        snapshot.appendItems([.header(balance.currency())])

        snapshot.appendSections([.thisWeek])
        snapshot.appendItems(state.expenses.map { .expense($0) })

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
        section.contentInsets = .init(top: 0, leading: 15, bottom: 80, trailing: 15)

        return section
    }

    private func nextWeekLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(144),
                                               heightDimension: .absolute(166))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 15, bottom: 15, trailing: 15)
        section.interGroupSpacing = 12

        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(80))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
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
            default: return self.nextWeekLayout()
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
                let cell = collectionView.dequeue(for: indexPath) as ExpenseCell
                cell.display(expense: expense)
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeue(kind: kind, for: indexPath) as ThisWeekHeader
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .header:
                return nil
            case .thisWeek:
                header.display(text: "This week")
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
        stack.pinEdges(to: contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(amount: String) {
        amountLabel.text = amount
    }
}

private class ExpenseCell: UICollectionViewCell {
    private let titleLabel = UILabel(font: .systemFont(ofSize: 18, weight: .semibold), color: .customLabel)
    private let dateLabel = UILabel(font: .systemFont(ofSize: 18, weight: .medium), color: .secondaryLabel)
    private let amountLabel = UILabel(font: .systemFont(ofSize: 15, weight: .medium), color: .customSecondaryLabel)
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .customBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.cornerCurve = .continuous
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = .init(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4

        let config = UIImage.SymbolConfiguration(font: titleLabel.font)
        imageView.image = UIImage(systemName: "arrow.up.right", withConfiguration: config)!
        imageView.tintColor = .customRed

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, dateLabel, UIView(), amountLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.distribution = .fill

        contentView.addSubview(labelStack)
        labelStack.pinEdges([.left, .top, .bottom], to: contentView, insets: .init(all: 15))

        contentView.addSubview(imageView)
        imageView.pinEdges([.top, .right], to: contentView, insets: .init(all: 15))
        imageView.leadingAnchor.pin(to: labelStack.trailingAnchor, constant: 4)

        titleLabel.numberOfLines = 3
        amountLabel.numberOfLines = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(expense: Expense) {
        titleLabel.text = expense.name
        dateLabel.text = expense.isDue() ? "Today" : expense.nextDueDate().readyBy()

        let state = expense.fundingState(using: .current)
        amountLabel.text = "\(state.text)"
    }
}

private class ThisWeekHeader: UICollectionReusableView {

    private let titleLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), color: .customLabel)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.pinEdges(to: self, insets: .init(top: 20, left: 0, bottom: 20, right: 0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(date: Date) {
        display(text: DateFormatter.readyByFormatter.string(from: date))
    }

    func display(text: String) {
        titleLabel.text = text
    }
}

private extension UITabBarItem {

    private static let label = UILabel(font: .systemFont(ofSize: 20, weight: .bold))

    static let noBalance = UITabBarItem(title: "Balance",
                                        image: UIImage(systemName: "house")!,
                                        selectedImage: UIImage(systemName: "house.fill")!)

    convenience init(amount: Decimal) {
        Self.label.text = "$\(amount.abbreviated())"
        Self.label.sizeToFit()

        let image = UIGraphicsImageRenderer(bounds: Self.label.bounds).image { context in
            Self.label.layer.render(in: context.cgContext)
        }

        self.init(title: "", image: image, tag: 0)
    }

}
