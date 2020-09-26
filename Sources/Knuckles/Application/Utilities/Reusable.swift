import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

extension UITableView {
    func register(cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    func register(view: UITableViewHeaderFooterView.Type) {
        register(view, forHeaderFooterViewReuseIdentifier: view.reuseIdentifier)
    }

    func dequeue<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Register cell of type \(T.self) before dequeueing")
        }

        return cell
    }

    func dequeue<T>() -> T where T: UITableViewHeaderFooterView {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Register table view header footer view of type \(T.self) before dequeueing")
        }

        return view
    }
}

extension UICollectionReusableView: Reusable {}

extension UICollectionView {
    func register(cell: UICollectionViewCell.Type) {
        register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }

    func dequeue<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Register cell of type \(T.self) before dequeueing")
        }

        return cell
    }

    func register(view: UICollectionReusableView.Type, for kind: String = UICollectionView.elementKindSectionHeader) {
        register(view, forSupplementaryViewOfKind: kind, withReuseIdentifier: view.reuseIdentifier)
    }

    func dequeue<T>(kind: String = UICollectionView.elementKindSectionHeader, for indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Register view of type \(T.self) before dequeueing")
        }

        return view
    }
}
