//
//  TabBarController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/27/20.
//

import UIKit

enum TabBarItem {
    case symbol(String)
    case text(String)
}

protocol TabbedViewController {
    var scrollView: UIScrollView? { get }
    var tabItem: TabBarItem { get }
}

class TabBarController: ViewController {
    private let tabBarContainerView = ScrollViewShadowView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tabBarContainerView)
        tabBarContainerView.pinEdges([.left, .right, .bottom], to: view)
        tabBarContainerView.topAnchor.pin(to: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
    }

    var viewControllers: [UIViewController & TabbedViewController] = [] {
        didSet { updateViewControllers() }
    }

    private func updateViewControllers() {
        children.first?.remove()

        if !viewControllers.isEmpty {
            select(index: 0)
        }
    }

    private func select(index: Int) {
        children.first?.remove()
        add(viewControllers[index]) { view in
            self.view.insertSubview(view, at: 0)
            view.pinEdges([.left, .right, .top], to: self.view)
            view.bottomAnchor.pin(to: self.tabBarContainerView.topAnchor)
        }

        tabBarContainerView.observe(scrollView: viewControllers[index].scrollView)
    }
}
