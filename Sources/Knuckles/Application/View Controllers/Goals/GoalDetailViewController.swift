//
//  GoalDetailViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 6/6/20.
//

import UIKit

class GoalDetailViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let delete = RetroButton(text: "Delete", color: .customPink, style: .secondary)
        let button = RetroButton(text: "Move Money", color: .customBlue, style: .secondary)

        let stack = UIStackView(arrangedSubviews: [delete, button])
        stack.distribution = .fillEqually
        stack.spacing = 24

        view.addSubview(stack)
        stack.pinEdges([.left, .right, .bottom], to: view.layoutMarginsGuide)
    }

}
