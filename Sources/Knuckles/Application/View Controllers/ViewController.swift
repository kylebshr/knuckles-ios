import Combine
import UIKit

class ViewController: UIViewController {
    private var didlayoutSubviews = false
    private var keyboardLayoutGuideBottom: NSLayoutConstraint!

    let keyboardLayoutGuide = UILayoutGuide()

    var cancelBag = Set<AnyCancellable>()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layoutMargins.left = 24
        view.layoutMargins.right = 24

        view.backgroundColor = .customBackground

        view.addLayoutGuide(keyboardLayoutGuide)
        keyboardLayoutGuide.pinEdges([.left, .right, .top], to: view)
        keyboardLayoutGuide.bottomAnchor.pin(lessThan: view.safeAreaLayoutGuide.bottomAnchor)
        keyboardLayoutGuideBottom = keyboardLayoutGuide.bottomAnchor.pin(to: view.bottomAnchor, priority: .defaultHigh)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        didlayoutSubviews = true
    }

    @objc func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func keyboardWillChange(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let isShowing = sender.name == UIResponder.keyboardWillShowNotification
        keyboardLayoutGuideBottom.constant = isShowing ? -keyboardFrame.cgRectValue.height : 0
        if didlayoutSubviews {
            view.layoutIfNeeded()
        }
    }
}
