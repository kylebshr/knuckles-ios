//
//  BarViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/13/20.
//

import UIKit

class BarViewController: ViewController {

    let customNavigationBar = NavigationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(customNavigationBar)
        customNavigationBar.insetsLayoutMarginsFromSafeArea = false
        customNavigationBar.pinEdges([.left, .right, .top], to: view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let trueSafeAreaInset = view.safeAreaInsets.top - additionalSafeAreaInsets.top
        customNavigationBar.layoutMargins.top = trueSafeAreaInset + 30

        additionalSafeAreaInsets.top = customNavigationBar.frame.height - trueSafeAreaInset
        view.bringSubviewToFront(customNavigationBar)
    }

    func back() -> NavigationView.Action {
        .init(symbolName: "chevron.left") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
