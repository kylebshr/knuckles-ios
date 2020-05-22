//
//  TransitionViewController.swift
//  Moment
//
//  Created by Kyle Bashour on 11/26/19.
//

import UIKit

class CardTransitionViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let mainContainerView = UIView()
    private let secondaryContainerView = UIView()
    private let realContainerView = UIView()

    let mainViewController: UIViewController
    let secondaryViewController: UIViewController

    init(mainViewController: UIViewController, secondaryViewController: UIViewController) {
        self.mainViewController = mainViewController
        self.secondaryViewController = secondaryViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.pinEdges(to: view)

        scrollView.addSubview(mainContainerView)
        scrollView.addSubview(realContainerView)
        scrollView.addSubview(secondaryContainerView)

        mainContainerView.pinEdges([.left, .right, .top], to: scrollView)
        mainContainerView.widthAnchor.pin(to: scrollView.widthAnchor)
        mainContainerView.heightAnchor.pin(to: scrollView.heightAnchor)

        secondaryContainerView.pinEdges([.left, .right, .bottom], to: scrollView)
        secondaryContainerView.topAnchor.pin(to: mainContainerView.bottomAnchor)
        secondaryContainerView.widthAnchor.pin(to: scrollView.widthAnchor)
        secondaryContainerView.heightAnchor.pin(to: scrollView.heightAnchor)

        initializeContainedViewController()
    }

    func initializeContainedViewController() {
        add(mainViewController) { view in
            self.mainContainerView.insertSubview(view, at: 0)
            view.pinEdges(to: self.mainContainerView)
        }

        add(secondaryViewController) { view in
            self.secondaryContainerView.insertSubview(view, at: 0)
            view.pinEdges(to: self.secondaryContainerView)
        }
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        mainViewController.additionalSafeAreaInsets.bottom = view.safeAreaInsets.bottom
    }
}
