//
//  RootViewController.swift
//  Knuckles
//
//  Created by Kyle Bashour on 4/27/20.
//  Copyright © 2020 Kyle Bashour. All rights reserved.
//

import UIKit

class RootViewController: ViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        LoginController.shared.launchLogin { completed in

        }
    }
}
