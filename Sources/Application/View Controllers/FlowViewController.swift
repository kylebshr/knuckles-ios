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

        view.backgroundColor = .systemBackground
        view.addSubview(navigationView)
        navigationView.pinEdges([.left, .top, .right], to: view)
        navigationView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
