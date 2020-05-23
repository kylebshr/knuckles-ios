//
//  DueDateViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class ExpenseDueDateViewController: FlowViewController {

    let nextButton = FullWidthButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.text = "What day is it due?"

        view.addSubview(nextButton)
        nextButton.text = "Add to expenses"
        nextButton.pinEdges([.left, .right, .bottom], to: view)
    }
}
