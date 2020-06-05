//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Kyle Bashour on 6/4/20.
//

import UIKit
import NotificationCenter

@objc(TodayViewController)
class TodayViewController: UIViewController, NCWidgetProviding {

    private let label = UILabel()

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "$100.00"
        view.addSubview(label)

        preferredContentSize.height = 200
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = view.bounds.insetBy(dx: 20, dy: 20)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        print(#function)

        completionHandler(NCUpdateResult.newData)
    }

}
