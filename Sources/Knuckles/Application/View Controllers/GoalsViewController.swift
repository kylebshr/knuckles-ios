//
//  GoalsViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/27/20.
//

import UIKit

class GoalsViewController: ViewController, TabbedViewController {
    var scrollView: UIScrollView? { nil }
    var tabItem: TabBarItem { .symbol("umbrella") }
    weak var tabDelegate: TabbedViewControllerDelegate?
}
