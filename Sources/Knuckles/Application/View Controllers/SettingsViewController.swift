//
//  SettingsViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 9/21/20.
//

import UIKit

class SettingsViewController: ViewController {

    struct Setting: Hashable {
        var title: String
        var action: (() -> Void)?

        static func == (lhs: SettingsViewController.Setting, rhs: SettingsViewController.Setting) -> Bool {
            lhs.title == rhs.title
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var dataSource: UITableViewDiffableDataSource<String, Setting> = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissAnimated))

        view.addSubview(tableView)
        tableView.pinEdges(to: view)

        tableView.delegate = self
        tableView.register(cell: UITableViewCell.self)
        tableView.dataSource = dataSource

        var snapshot = NSDiffableDataSourceSnapshot<String, Setting>()

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

        snapshot.appendSections(["About"])
        snapshot.appendItems([
            .init(title: "Version \(version) (\(build))", action: nil),
        ])

        snapshot.appendSections(["Settings"])
        snapshot.appendItems([
            .init(title: "Logout", action: logout),
        ])

        dataSource.apply(snapshot)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<String, Setting> {
        .init(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeue(for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        }
    }

    func logout() {
        UserDefaults.shared.logout()
        dismissAnimated()
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        dataSource.itemIdentifier(for: indexPath)?.action != nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataSource.itemIdentifier(for: indexPath)?.action?()
    }
}
