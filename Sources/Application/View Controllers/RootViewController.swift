//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit
import Foundation

class RootViewController: ViewController {

    private var current: UIViewController?
    private var observation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.logout()

        observation = UserDefaults.standard.observe(\.authenticationToken, options: [.initial, .new]) { [weak self] defaults, _ in
            if let user = defaults.loggedInUser {
                self?.set(viewController: MainViewController(user: user))
            } else {
                let viewController = LoginViewController(completion: nil)
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
