//
//  UINavigationController+Tabs.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/6/20.
//

import UIKit

extension UINavigationController: TabbedViewController {
    var tabItem: TabBarItem {
        guard let child = children.first as? TabbedViewController else { fatalError() }
        return child.tabItem
    }
}
