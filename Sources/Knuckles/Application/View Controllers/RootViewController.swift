//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit
import Foundation

class RootViewController: UIViewController {

    private var current: UIViewController?
    private var observation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        observation = UserDefaults.shared.observe(\.loggedInUser, options: [.initial, .new]) { [weak self] defaults, _ in
            if let user = defaults.loggedInUser, user.hasCompletedPlaidLink {
                if self?.children.first is MainViewController { return }
                self?.set(viewController: MainViewController(user: user))
            } else {
                if self?.children.first is PagingNavigationController { return }
                let viewController: UIViewController

                if let user = UserDefaults.shared.loggedInUser, !user.hasCompletedPlaidLink {
                    viewController = LinkPlaidViewController()
                } else {
                    viewController = LoginViewController()
                }

                let navigationController = PagingNavigationController(rootViewController: viewController)
                self?.set(viewController: navigationController)
            }
        }
    }

    private func set(viewController: UIViewController) {
        guard current != nil else {
            add(viewController)
            current = viewController
            return
        }

        viewController.view.alpha = 0
        add(viewController)

        let animator = UIViewPropertyAnimator {
            viewController.view.alpha = 1
        }

        animator.addCompletion { _ in
            self.current?.remove()
            self.current = viewController
        }

        animator.startAnimation()
    }
}
