import UIKit

extension UIViewController {

    func add(_ child: UIViewController, addSubview: ((UIView) -> Void)? = nil) {
        addChild(child)

        if let addSubview = addSubview {
            addSubview(child.view)
        } else {
            view.addSubview(child.view)
            child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            child.view.frame = view.bounds
        }

        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    func placeholder(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func parent<T: UIViewController>(ofType: T.Type) -> T? {
        return parent as? T ?? parent?.parent(ofType: ofType)
    }

}
