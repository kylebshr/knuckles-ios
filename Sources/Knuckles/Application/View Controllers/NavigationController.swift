//
//  NavigationController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/14/20.
//

import UIKit

class NavigationController: UINavigationController {
    private let fullScreenPanGestureRecognizer = PanDirectionGestureRecognizer(direction: .horizontal)

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        if let controllerSelector = "X2NhY2hlZEludGVyYWN0aW9uQ29udHJvbGxlcg==".base64Decoded,
            let cachedInteractionController = value(forKey: controllerSelector) as? NSObject,
            let handleTransitionSelection = "aGFuZGxlTmF2aWdhdGlvblRyYW5zaXRpb246".base64Decoded {
            let selector = Selector(handleTransitionSelection)
            if cachedInteractionController.responds(to: selector) {
                fullScreenPanGestureRecognizer.addTarget(cachedInteractionController, action: selector)
                view.addGestureRecognizer(fullScreenPanGestureRecognizer)
            }
        }
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController, didShow: UIViewController, animated: Bool) {
        fullScreenPanGestureRecognizer.isEnabled = viewControllers.count > 1
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        viewController.navigationItem.backBarButtonItem = .init(title: " ", style: .plain, target: nil, action: nil)
    }
}

private extension String {
    var base64Decoded: String? {
        if let decodedData = Data(base64Encoded: self),
            let decodedString = String(data: decodedData, encoding: .utf8) {
            return decodedString
        } else {
            return nil
        }
    }
}
