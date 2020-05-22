//
//  ExpenseViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/20/20.
//

import UIKit

class ExpenseViewController: UITableViewController {

    let expenses = [
        Expense(name: "Spotify", amount: 9.99, dayDueAt: 12),
        Expense(name: "Hulu", amount: 12.99, dayDueAt: 19),
        Expense(name: "HBO", amount: 15.99, dayDueAt: 24),
        Expense(name: "Netflix", amount: 11.99, dayDueAt: 3),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Expenses"

        let informationalViewController = InformationalViewController()
        add(informationalViewController) { view in
            view.frame = view.bounds
            self.tableView.tableHeaderView = view
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = expenses[indexPath.row].name
        return cell
    }
}
