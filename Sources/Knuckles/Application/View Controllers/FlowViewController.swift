//
//  FlowViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class FlowViewController: ViewController {

    let navigationView = NavigationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(navigationView)
        navigationView.pinEdges([.left, .top, .right], to: view)
    }
}
