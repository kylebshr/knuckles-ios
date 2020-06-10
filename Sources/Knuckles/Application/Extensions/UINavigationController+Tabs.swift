//
//  UINavigationController+Tabs.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/6/20.
//

import UIKit

extension UINavigationController: TabbedViewController {
    var scrollView: UIScrollView? {
        guard let child = children.first as? TabbedViewController else { fatalError() }
        return child.scrollView
    }

    var tabItem: TabBarItem {
        guard let child = children.first as? TabbedViewController else { fatalError() }
        return child.tabItem
    }
}
