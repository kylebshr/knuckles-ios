//
//  FlowViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 5/22/20.
//

import UIKit

class FlowViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = " "
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "xmark")!, style: .done, target: self, action: #selector(dismissAnimated))
    }
}
