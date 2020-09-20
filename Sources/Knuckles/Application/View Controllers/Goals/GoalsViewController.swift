//
//  GoalsViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/27/20.
//

import UIKit

class GoalsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()

    private let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: true)
    private var goals: [Goal] = []

    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "Goals", image: UIImage(systemName: "checkmark.square"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.pinEdges(to: view)

        navigationItem.title = "Goals"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            image: UIImage(systemName: "plus"),
//            style: .done,
//            target: self,
//            action: #selector(presentCreateGoal)
//        )

        tableView.showsVerticalScrollIndicator = true
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .customBackground
        tableView.register(cell: GoalCell.self)

        tableView.separatorStyle = .none
        tableView.register(cell: PlaceholderCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 // goals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(for: indexPath) as GoalCell
//        let goal = goals[indexPath.row]
//        cell.display(goal: goal, in: payPeriod)
//        return cell

        tableView.dequeue(for: indexPath) as PlaceholderCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = GoalDetailViewController()
        show(viewController, sender: self)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            UserDefaults.shared.expenses.remove(at: indexPath.row)
            self?.tableView.beginUpdates()
            self?.goals.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.tableView.endUpdates()
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    @objc private func presentCreateGoal() {
        let viewController = ExpenseCreationViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }

    private func reload() {
        goals = UserDefaults.shared.goals
            .sorted { $0.sortingDate() < $1.sortingDate() }
        tableView.reloadData()
    }
}

private class PlaceholderCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let label = UILabel(font: .systemFont(ofSize: 17, weight: .bold), color: .customTertiaryLabel, alignment: .center)
        label.text = "Coming soon"
        contentView.addSubview(label)
        label.pinEdges(to: contentView.layoutMarginsGuide, insets: .init(vertical: 80, horizontal: 0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class GoalCell: UITableViewCell {
    private let nameLabel = UILabel(font: .rubik(ofSize: 18, weight: .medium))
    private let amountLabel = UILabel(font: .rubik(ofSize: 18, weight: .medium), alignment: .right)
    private let nextAmountLabel = UILabel(font: .rubik(ofSize: 13, weight: .medium), color: .customBlue, alignment: .right)
    private let emojiView = UILabel(font: .rubik(ofSize: 24, weight: .regular))
    private let readyLabel = UILabel(font: .rubik(ofSize: 13, weight: .medium))
    private let progressView = ProgressView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        emojiView.setHuggingAndCompression(to: .required)

        backgroundColor = .customBackground
        preservesSuperviewLayoutMargins = true

        contentView.layoutMargins.top = 20
        contentView.layoutMargins.right = 20
        contentView.layoutMargins.bottom = 20

        let titleStack = UIStackView(arrangedSubviews: [nameLabel, amountLabel])
        titleStack.alignment = .firstBaseline
        titleStack.distribution = .fill
        titleStack.spacing = 2

        let subStack = UIStackView(arrangedSubviews: [readyLabel, nextAmountLabel])
        subStack.distribution = .fill
        subStack.spacing = 2

        let verticalStack = UIStackView(arrangedSubviews: [titleStack, progressView, subStack])
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .fill
        verticalStack.spacing = 10

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

    func display(goal: Goal, in period: PayPeriod) {
        let amountSaved = goal.amountSaved(using: period)

        nameLabel.text = goal.name
        emojiView.text = "\(goal.emoji)"
        amountLabel.text = amountSaved.currency()

        progressView.progress = CGFloat(truncating: (amountSaved / goal.amount) as NSNumber)
        let dueDateString = DateFormatter.readyByFormatter.string(from: goal.dayDueAt)

        if goal.isFunded(using: period) {
            readyLabel.text = "All set for \(dueDateString)"
            nextAmountLabel.text = "Funded"
        } else {
            let nextAmountText = goal.nextAmountSaved(using: period).currency()
            nextAmountLabel.text = "+ \(nextAmountText.droppingZeroes()) next"

            let totalAmountText = goal.amount.currency()
            readyLabel.text = "\(totalAmountText.droppingZeroes()) by \(dueDateString)"
        }
    }
}
